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
        if ([touchType isEqualToString:@"tap"] && view != nil) {
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
    NSString *script;
    if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        script = [NSString stringWithFormat:@"window.UXK_TouchCallback('%@', {state: '%@', windowX: %f, windowY: %f, locationX: %f, locationY: %f, translateX: %f, translateY: %f, velocityX: %f, velocityY: %f})",
                  sender.uxk_callbackID,
                  [self state:sender],
                  [sender locationInView:nil].x,
                  [sender locationInView:nil].y,
                  [sender locationInView:sender.view].x,
                  [sender locationInView:sender.view].y,
                  [(UIPanGestureRecognizer *)sender translationInView:nil].x,
                  [(UIPanGestureRecognizer *)sender translationInView:nil].y,
                  [(UIPanGestureRecognizer *)sender velocityInView:nil].x,
                  [(UIPanGestureRecognizer *)sender velocityInView:nil].y];
    }
    else {
        script = [NSString stringWithFormat:@"window.UXK_TouchCallback('%@', {state: '%@', windowX: %f, windowY: %f, locationX: %f, locationY: %f})",
                  sender.uxk_callbackID,
                  [self state:sender],
                  [sender locationInView:nil].x,
                  [sender locationInView:nil].y,
                  [sender locationInView:sender.view].x,
                  [sender locationInView:sender.view].y];
    }
    [self.bridgeController.webView evaluateJavaScript:script completionHandler:nil];
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
