//
//  UXKBridgeTouchUpdater.m
//  uxkit
//
//  Created by 崔 明辉 on 16/9/24.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKBridgeTouchUpdater.h"
#import "UXKBridgeController.h"
#import "UXKBridgeViewUpdater.h"
#import "UXKBridgeCallbackHandler.h"
#import "UXKView.h"
#import <objc/runtime.h>

@interface UIGestureRecognizer (UXKProps)

@property (nonatomic, strong) NSString *uxk_callbackID;

@end

@implementation UXKBridgeTouchUpdater

+ (NSString *)bridgeScript {
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UXKTouch"
                                                                              ofType:@"js"]
                                     encoding:NSUTF8StringEncoding
                                        error:nil];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([[message body] isKindOfClass:[NSString class]]) {
        NSString *argsString = [message body];
        NSData *argsData = [argsString dataUsingEncoding:NSUTF8StringEncoding];
        if (argsData == nil) {
            return;
        }
        NSDictionary *args = [NSJSONSerialization JSONObjectWithData:argsData
                                                             options:kNilOptions
                                                               error:nil];
        if ([args isKindOfClass:[NSDictionary class]]) {
            if ([args[@"removed"] isKindOfClass:[NSNumber class]] && [args[@"removed"] boolValue]) {
                [self removeGestureWithArgs:args];
            }
            else {
                [self addGestureWithArgs:args];
            }
        }
    }
}

- (void)removeGestureWithArgs:(NSDictionary *)args {
    NSString *vKey = args[@"vKey"];
    if ([vKey isKindOfClass:[NSString class]]) {
        UIView *view = self.bridgeController.viewUpdater.mirrorViews[vKey];
        if (view != nil) {
            for (UIGestureRecognizer *obj in [view.gestureRecognizers copy]) {
                if ([obj.uxk_callbackID isEqualToString:args[@"callbackID"]]) {
                    [view removeGestureRecognizer:obj];
                }
            }
        }
    }
}

- (void)addGestureWithArgs:(NSDictionary *)args {
    NSString *touchType = args[@"touchType"];
    NSString *vKey = args[@"vKey"];
    if ([touchType isKindOfClass:[NSString class]] && [vKey isKindOfClass:[NSString class]]) {
        UIView *view = self.bridgeController.viewUpdater.mirrorViews[vKey];
        if ([touchType isEqualToString:@"touch"] && view != nil) {
            [self addTouchToView:view args:args];
        }
        else if ([touchType isEqualToString:@"tap"] && view != nil) {
            [self addTapGestureToView:view args:args];
        }
        else if ([touchType isEqualToString:@"longPress"] && view != nil) {
            [self addLongPressGestureToView:view args:args];
        }
        else if ([touchType isEqualToString:@"pan"] && view != nil) {
            [self addPanGestureToView:view args:args];
        }
    }
}

- (void)addTouchToView:(UIView *)view args:(NSDictionary *)args {
    if ([view isKindOfClass:[UXKView class]]) {
        [(UXKView *)view setTouchCallback:^(NSString *eventType){
            NSString *callbackID = args[@"callbackID"];
            NSString *script = [NSString stringWithFormat:@"window.UXK_TouchCallback('%@', {state: '%@'})",
                                callbackID, eventType];
            [self.bridgeController.webView evaluateJavaScript:script completionHandler:nil];
        }];
    }
}

- (void)addTapGestureToView:(UIView *)view args:(NSDictionary *)args {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouch:)];
    gesture.uxk_callbackID = [args[@"callbackID"] isKindOfClass:[NSString class]] ? args[@"callbackID"] : nil;
    gesture.numberOfTapsRequired = [args[@"taps"] isKindOfClass:[NSNumber class]] ? [args[@"taps"] unsignedIntegerValue] : 1;
    gesture.numberOfTouchesRequired = [args[@"touches"] isKindOfClass:[NSNumber class]] ? [args[@"touches"] unsignedIntegerValue] : 1;
    [view addGestureRecognizer:gesture];
}

- (void)addLongPressGestureToView:(UIView *)view args:(NSDictionary *)args {
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onTouch:)];
    gesture.uxk_callbackID = [args[@"callbackID"] isKindOfClass:[NSString class]] ? args[@"callbackID"] : nil;
    gesture.numberOfTapsRequired = [args[@"taps"] isKindOfClass:[NSNumber class]] ? [args[@"taps"] unsignedIntegerValue] : 0;
    gesture.numberOfTouchesRequired = [args[@"touches"] isKindOfClass:[NSNumber class]] ? [args[@"touches"] unsignedIntegerValue] : 1;
    gesture.minimumPressDuration = [args[@"duration"] isKindOfClass:[NSNumber class]] ? [args[@"duration"] doubleValue] : 0.5;
    gesture.allowableMovement = [args[@"allowMovement"] isKindOfClass:[NSNumber class]] ? [args[@"allowMovement"] floatValue] : 10.0;
    [view addGestureRecognizer:gesture];
}

- (void)addPanGestureToView:(UIView *)view args:(NSDictionary *)args {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onTouch:)];
    gesture.uxk_callbackID = [args[@"callbackID"] isKindOfClass:[NSString class]] ? args[@"callbackID"] : nil;
    [view addGestureRecognizer:gesture];
}

- (void)onTouch:(UIGestureRecognizer *)sender {
    NSDictionary *arg;
    if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        arg = @{
                @"state": [self state:sender],
                @"windowX": @([sender locationInView:nil].x),
                @"windowY": @([sender locationInView:nil].y),
                @"locationX": @([sender locationInView:sender.view].x),
                @"locationY": @([sender locationInView:sender.view].y),
                @"translateX": @([(UIPanGestureRecognizer *)sender translationInView:nil].x),
                @"translateY": @([(UIPanGestureRecognizer *)sender translationInView:nil].y),
                @"velocityX": @([(UIPanGestureRecognizer *)sender velocityInView:nil].x),
                @"velocityY": @([(UIPanGestureRecognizer *)sender velocityInView:nil].y),
                @"superX": @([sender locationInView:sender.view.superview].x),
                @"superY": @([sender locationInView:sender.view.superview].y)
                };
    }
    else {
        arg = @{
                @"state": [self state:sender],
                @"windowX": @([sender locationInView:nil].x),
                @"windowY": @([sender locationInView:nil].y),
                @"locationX": @([sender locationInView:sender.view].x),
                @"locationY": @([sender locationInView:sender.view].y),
                };
    }
    [self.bridgeController.callbackHandler callback:sender.uxk_callbackID args:@[arg]];
}

- (NSString *)state:(UIGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStatePossible:
            return @"Possible";
            break;
        case UIGestureRecognizerStateBegan:
            return @"Began";
            break;
        case UIGestureRecognizerStateChanged:
            return @"Changed";
            break;
        case UIGestureRecognizerStateEnded:
            return @"Ended";
            break;
        case UIGestureRecognizerStateCancelled:
            return @"Cancelled";
            break;
        case UIGestureRecognizerStateFailed:
            return @"Failed";
            break;
        default:
            break;
    }
    return @"";
}

@end

@implementation UIGestureRecognizer (UXKProps)

static int kCallbackIDIdentifier;

- (void)setUxk_callbackID:(NSString *)uxk_callbackID {
    objc_setAssociatedObject(self, &kCallbackIDIdentifier, uxk_callbackID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)uxk_callbackID {
    return objc_getAssociatedObject(self, &kCallbackIDIdentifier);
}

@end
