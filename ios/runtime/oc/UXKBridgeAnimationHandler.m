//
//  UXKBridgeAnimationHandler.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/17.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKBridgeAnimationHandler.h"
#import "UXKBridgeController.h"
#import "UXKBridgeViewUpdater.h"
#import "UXKAnimation.h"
#import "UXKView.h"
#import "UXKProps.h"
#import <pop/POP.h>

@interface UXKBridgeAnimationHandler()

@property (nonatomic, readwrite) BOOL animationEnabled;
@property (nonatomic, strong) NSDictionary *animationParams;
@property (nonatomic, strong) UIView *view;

@end

@implementation UXKBridgeAnimationHandler

+ (NSString *)bridgeScript {
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UXKAnimation" ofType:@"js"]
                                     encoding:NSUTF8StringEncoding
                                        error:nil];
}

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        _view = view;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"UXK_AnimationHandler_Commit"]) {
        if ([[message body] isKindOfClass:[NSString class]]) {
            NSData *aniData = [[message body] dataUsingEncoding:NSUTF8StringEncoding];
            if (aniData == nil) {
                return;
            }
            NSDictionary *aniParams = [NSJSONSerialization JSONObjectWithData:aniData
                                                                      options:kNilOptions
                                                                        error:nil];
            self.animationParams = aniParams;
        }
    }
    else if ([message.name isEqualToString:@"UXK_AnimationHandler_Enable"]) {
        self.animationEnabled = YES;
    }
    else if ([message.name isEqualToString:@"UXK_AnimationHandler_Disable"]) {
        self.animationEnabled = NO;
    }
    else if ([message.name isEqualToString:@"UXK_AnimationHandler_Decay"]) {
        if ([[message body] isKindOfClass:[NSString class]]) {
            NSData *aniData = [[message body] dataUsingEncoding:NSUTF8StringEncoding];
            if (aniData == nil) {
                return;
            }
            NSDictionary *aniParams = [NSJSONSerialization JSONObjectWithData:aniData
                                                                      options:kNilOptions
                                                                        error:nil];
            if (![aniParams[@"vKey"] isKindOfClass:[NSString class]]) {
                return;
            }
            UIView *view = self.bridgeController.viewUpdater.mirrorViews[aniParams[@"vKey"]];
            if (view == nil) {
                return;
            }
            NSString *aniProps = @"";
            if (![aniParams[@"aniProps"] isKindOfClass:[NSString class]]) {
                return;
            }
            if ([aniParams[@"aniProps"] isEqualToString:@"frame"]) {
                aniProps = kPOPViewFrame;
            }
            self.animationParams = aniParams;
            self.animationEnabled = YES;
            [self addAnimationWithView:view props:aniProps newValue:nil];
            self.animationEnabled = NO;
        }
    }
    else if ([message.name isEqualToString:@"UXK_AnimationHandler_Stop"]) {
        if ([[message body] isKindOfClass:[NSString class]]) {
            NSData *aniData = [[message body] dataUsingEncoding:NSUTF8StringEncoding];
            if (aniData == nil) {
                return;
            }
            NSDictionary *aniParams = [NSJSONSerialization JSONObjectWithData:aniData
                                                                      options:kNilOptions
                                                                        error:nil];
            if (![aniParams[@"vKey"] isKindOfClass:[NSString class]]) {
                return;
            }
            UIView *view = self.bridgeController.viewUpdater.mirrorViews[aniParams[@"vKey"]];
            if (view == nil) {
                return;
            }
            [self removeAnimationsWithView:view];
            if ([aniParams[@"callbackID"] isKindOfClass:[NSString class]]) {
                NSString * script = [NSString stringWithFormat:@"window._UXK_Animation.callbacks['%@'].call(this)",
                          aniParams[@"callbackID"]];
                [self.bridgeController.webView evaluateJavaScript:script completionHandler:nil];
            }
        }
    }
}

- (BOOL)addAnimationWithView:(UIView *)view props:(NSString *)props newValue:(id)newValue {
    if (!self.animationEnabled || self.animationParams == nil) {
        return NO;
    }
    POPAnimation *animation = [UXKAnimation animationWithParams:self.animationParams
                                                    aniProperty:props
                                                      fromValue:[self fromValueWithProps:props view:view]
                                                        toValue:newValue];
    if (animation == nil) {
        return NO;
    }
    [self configureCallbacks:view props:props animation:animation];
    if (props == kPOPLayerCornerRadius || props == kPOPLayerBorderWidth || props == kPOPLayerBorderColor) {
        [view.layer pop_addAnimation:animation forKey:props];
    }
    else {
        [view pop_addAnimation:animation forKey:props];
    }
    return YES;
}

- (void)configureCallbacks:(UIView *)view props:(NSString *)props animation:(POPAnimation *)animation {
    if ([self.animationParams[@"onChange"] isKindOfClass:[NSString class]]) {
        [animation setAnimationDidApplyBlock:^(POPAnimation *animation) {
            NSString *script = @"";
            if ([props isEqualToString:kPOPViewFrame]) {
                script = [NSString stringWithFormat:@"window._UXK_Animation.callbacks['%@'].call(this, %@)",
                          self.animationParams[@"onChange"],
                          [UXKProps stringWithRect:view.frame]];
            }
            [self.bridgeController.webView evaluateJavaScript:script completionHandler:nil];
        }];
    }
    if ([self.animationParams[@"onComplete"] isKindOfClass:[NSString class]]) {
        [animation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
            NSString *script = @"";
            if ([props isEqualToString:kPOPViewFrame]) {
                script = [NSString stringWithFormat:@"window._UXK_Animation.callbacks['%@'].call(this, %@)",
                          self.animationParams[@"onComplete"],
                          [UXKProps stringWithRect:view.frame]];
            }
            [self.bridgeController.webView evaluateJavaScript:script completionHandler:nil];
        }];
    }
}

- (void)removeAnimationsWithView:(UIView *)view {
    [view pop_removeAllAnimations];
    [view.layer pop_removeAllAnimations];
}

- (NSValue *)fromValueWithProps:(NSString *)props view:(UIView *)view {
    if ([props isEqualToString:kPOPViewScaleXY]) {
        return [NSValue valueWithCGSize:CGSizeMake(view.transform.a, view.transform.d)];
    }
    else if ([props isEqualToString:kPOPViewFrame]) {
        return [NSValue valueWithCGRect:view.frame];
    }
    return nil;
}

@end
