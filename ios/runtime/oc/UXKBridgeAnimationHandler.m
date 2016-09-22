//
//  UXKBridgeAnimationHandler.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/17.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKBridgeAnimationHandler.h"
#import "UXKAnimation.h"
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
}

- (BOOL)addAnimationWithView:(UIView *)view props:(NSString *)props newValue:(id)newValue {
    if (!self.animationEnabled || self.animationParams == nil) {
        return NO;
    }
    POPAnimation *animation = [UXKAnimation animationWithParams:self.animationParams
                                                    aniProperty:props
                                                      fromValue:nil
                                                        toValue:newValue];
    if (animation == nil) {
        return NO;
    }
    if (props == kPOPLayerCornerRadius || props == kPOPLayerBorderWidth || props == kPOPLayerBorderColor) {
        [view.layer pop_addAnimation:animation forKey:props];
    }
    else {
        [view pop_addAnimation:animation forKey:props];
    }
    return YES;
}

@end
