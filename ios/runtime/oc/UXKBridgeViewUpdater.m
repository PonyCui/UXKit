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
#import "UXKBridgeCallbackHandler.h"
#import "UXKBridge.h"
#import "UIViewController+UXKBridge.h"

@interface UXKBridgeViewUpdater()

@property (nonatomic, strong) UIView *view;
@property (nonatomic, assign) BOOL nonMargins;
@property (nonatomic, strong) NSMutableDictionary *mirrorViews;

@end

@implementation UXKBridgeViewUpdater

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
                        view.visualDOMKey, aKey, aValue];
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
            [self updateViewWithNode:specObj];
            if ([specObj[@"callbackID"] isKindOfClass:[NSString class]]) {
                [self.bridgeController.callbackHandler callback:specObj[@"callbackID"] args:nil];
            }
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

- (UIView *)updateViewWithNode:(NSDictionary *)node {
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
    else if ([UXKBridge classWithNodeName:nodeName] != NULL) {
        currentView = [[UXKBridge classWithNodeName:nodeName] new];
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
                UIView *nextView = [self updateViewWithNode:subview];
                if (nextView != nil && [nextView superview] != currentView) {
                    [currentView addSubview:nextView];
                }
            }
        }
    }
    return currentView;
}

@end
