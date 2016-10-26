//
//  UXKBridgeViewUpdater.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/13.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKBridgeViewUpdater.h"
#import "UXKView.h"
#import "UXKBridgeController.h"
#import "UIViewController+UXKBridge.h"

static NSDictionary *kUXKViewTypes;

@interface UXKBridgeViewUpdater()

@property (nonatomic, strong) UIView *view;
@property (nonatomic, assign) BOOL nonMargins;
@property (nonatomic, strong) NSMutableDictionary *mirrorViews;

@end

@implementation UXKBridgeViewUpdater

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kUXKViewTypes = @{
                          @"VIEW": @"UXKView",
                          @"IMAGEVIEW": @"UXKImageView",
                          @"LABEL": @"UXKLabel",
                          @"TEXTFIELD": @"UXKTextField",
                          @"NAV": @"UXKNav",
                          @"MODAL": @"UXKModal",
                          };
    });
}

+ (void)createTagWithName:(NSString *)tagName viewClass:(Class)viewClass {
    NSMutableDictionary *dict = [kUXKViewTypes mutableCopy];
    [dict setObject:NSStringFromClass(viewClass) forKey:tagName];
    kUXKViewTypes = [dict copy];
}

+ (NSString *)bridgeScript {
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UXKDom" ofType:@"js"]
                                     encoding:NSUTF8StringEncoding
                                        error:nil];
}

- (void)dealloc {
    [self.view removeObserver:self forKeyPath:@"bounds" context:nil];
}

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        _view = view;
        _mirrorViews = [NSMutableDictionary dictionary];
        [view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)updateView:(UXKView *)view aKey:(NSString *)aKey aValue:(NSString *)aValue {
    NSString *script = [NSString stringWithFormat:@"jQuery(\"[vKey='%@']\").attr('%@', '%@')",
                        view.vKey, aKey, aValue];
    [self.bridgeController.webView evaluateJavaScript:script completionHandler:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    for (UIView *subview in [self.view subviews]) {
        [subview layoutSubviews];
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([[message body] isKindOfClass:[NSString class]]) {
        NSString *spec = [message body];
        NSData *specData = [spec dataUsingEncoding:NSUTF8StringEncoding];
        if (specData == nil) {
            return;
        }
        NSDictionary *specObj = [NSJSONSerialization JSONObjectWithData:specData
                                                                options:kNilOptions
                                                                  error:nil];
        if ([specObj isKindOfClass:[NSDictionary class]]) {
            [self viewWithNode:specObj];
        }
    }
}

- (UIViewController *)sourceViewController {
    UIResponder *responder = self.view;
    while (responder != nil) {
        responder = [responder nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (id)responder;
        }
    }
    return nil;
}

- (UIView *)viewWithNode:(NSDictionary *)node {
    NSString *nodeName = node[@"name"];
    BOOL updatePropsOnly = [node[@"updatePropsOnly"] isKindOfClass:[NSNumber class]] ? [node[@"updatePropsOnly"] boolValue] : NO;
    NSString *visualKey = node[@"vKey"];
    NSDictionary *props = node[@"props"];
    NSArray *subviews = node[@"subviews"];
    if (nodeName == nil || ![nodeName isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (visualKey == nil || ![visualKey isKindOfClass:[NSString class]]) {
        if (![nodeName isEqualToString:@"BODY"]) {
            return nil;
        }
    }
    UIView *currentView;
    if ([nodeName isEqualToString:@"BODY"]) {
        if ([props[@"margin"] isEqualToString:@"auto"] && !self.nonMargins) {
            self.nonMargins = YES;
            [[self sourceViewController] uxk_setupWithoutMargins];
        }
        currentView = self.view;
    }
    else if (self.mirrorViews[visualKey] != nil) {
        currentView = self.mirrorViews[visualKey];
    }
    else if (kUXKViewTypes[nodeName] != nil) {
        currentView = [NSClassFromString(kUXKViewTypes[nodeName]) new];
        if (visualKey != nil && [visualKey isKindOfClass:[NSString class]]) {
            [self.mirrorViews setObject:currentView forKey:visualKey];
        }
    }
    else {
        return nil;
    }
    currentView.accessibilityIdentifier = visualKey;
    if ([currentView isKindOfClass:[UXKView class]]) {
        [(UXKView *)currentView setBridgeController:self.bridgeController];
        [(UXKView *)currentView setAnimationHandler:self.bridgeController.animationHandler];
    }
    if (props != nil && [props isKindOfClass:[NSDictionary class]] && [currentView isKindOfClass:[UXKView class]]) {
        [(UXKView *)currentView setProps:props updatePropsOnly:updatePropsOnly];
    }
    if (updatePropsOnly) {
        return currentView;
    }
    BOOL staticLayouts = NO;
    if ([currentView isKindOfClass:[UXKView class]]) {
        staticLayouts = [(UXKView *)currentView staticLayouts];
    }
    if (!staticLayouts && subviews != nil && [subviews isKindOfClass:[NSArray class]]) {
        __block BOOL changed = NO;
        if ([subviews count] != [[currentView subviews] count]) {
            changed = YES;
        }
        else {
            [subviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj[@"vKey"] != nil && [obj[@"vKey"] isKindOfClass:[NSString class]]) {
                    if (idx >= [[currentView subviews] count]) {
                        changed = YES;
                        *stop = YES;
                        return;
                    }
                    if (![[[currentView subviews][idx] accessibilityIdentifier] isEqualToString:obj[@"vKey"]]) {
                        changed = YES;
                        *stop = YES;
                        return;
                    }
                }
            }];
        }
        if (changed) {
            for (UIView *subview in [currentView subviews]) {
                [subview removeFromSuperview];
            }
        }
        for (NSDictionary *subview in subviews) {
            if ([subview isKindOfClass:[NSDictionary class]]) {
                UIView *nextView = [self viewWithNode:subview];
                if (nextView != nil && [nextView superview] != currentView) {
                    [currentView addSubview:nextView];
                }
            }
        }
    }
    return currentView;
}

@end
