//
//  UXKAnimation.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/17.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKAnimation.h"
#import "UXKProps.h"
#import <pop/POP.h>

@implementation UXKAnimation

+ (POPAnimation *)animationWithParams:(NSDictionary *)aniParams
                          aniProperty:(NSString *)aniProperty
                            fromValue:(id)fromValue
                              toValue:(id)toValue {
    if ([aniParams[@"aniType"] isKindOfClass:[NSString class]] && [aniParams[@"aniType"] isEqualToString:@"spring"]) {
        return [self springWithParams:aniParams
                          aniProperty:aniProperty
                            fromValue:fromValue
                              toValue:toValue];
    }
    else if ([aniParams[@"aniType"] isKindOfClass:[NSString class]] && [aniParams[@"aniType"] isEqualToString:@"decay"]) {
        return [self decayWithParams:aniParams
                         aniProperty:aniProperty
                           fromValue:fromValue];
    }
    else if ([aniParams[@"aniType"] isKindOfClass:[NSString class]] && [aniParams[@"aniType"] isEqualToString:@"decayBounce"]) {
        return [self decayBounceWithParams:aniParams
                               aniProperty:aniProperty
                                 fromValue:fromValue];
    }
    else {
        return [self timingWithParams:aniParams
                          aniProperty:aniProperty
                            fromValue:fromValue
                              toValue:toValue];
    }
}

+ (POPAnimation *)timingWithParams:(NSDictionary *)aniParams
                       aniProperty:(NSString *)aniProperty
                         fromValue:(id)fromValue
                           toValue:(id)toValue {
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:aniProperty];
    if (aniParams[@"duration"] != nil && [aniParams[@"duration"] isKindOfClass:[NSNumber class]]) {
        animation.duration = [aniParams[@"duration"] floatValue] / 1000.0;
    }
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    return animation;
}

+ (POPAnimation *)springWithParams:(NSDictionary *)aniParams
                       aniProperty:(NSString *)aniProperty
                         fromValue:(id)fromValue
                           toValue:(id)toValue {
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:aniProperty];
    if (aniParams[@"friction"] != nil && [aniParams[@"friction"] isKindOfClass:[NSNumber class]]) {
        animation.dynamicsFriction = [aniParams[@"friction"] floatValue];
    }
    if (aniParams[@"tension"] != nil && [aniParams[@"tension"] isKindOfClass:[NSNumber class]]) {
        animation.dynamicsTension = [aniParams[@"tension"] floatValue];
    }
    if (aniParams[@"speed"] != nil && [aniParams[@"speed"] isKindOfClass:[NSNumber class]]) {
        animation.springSpeed = [aniParams[@"speed"] floatValue];
    }
    if (aniParams[@"bounciness"] != nil && [aniParams[@"bounciness"] isKindOfClass:[NSNumber class]]) {
        animation.springBounciness = [aniParams[@"bounciness"] floatValue];
    }
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    return animation;
}

+ (POPAnimation *)decayWithParams:(NSDictionary *)aniParams
                      aniProperty:(NSString *)aniProperty
                        fromValue:(id)fromValue {
    POPDecayAnimation *animation = [POPDecayAnimation animationWithPropertyNamed:aniProperty];
    if ([aniProperty isEqualToString:kPOPViewFrame]) {
        if (aniParams[@"velocity"] != nil && [aniParams[@"velocity"] isKindOfClass:[NSString class]]) {
            [animation setVelocity:[NSValue valueWithCGRect:[UXKProps toRectWithRect:aniParams[@"velocity"]]]];
        }
    }
    if (aniParams[@"deceleration"] != nil && [aniParams[@"deceleration"] isKindOfClass:[NSNumber class]]) {
        [animation setDeceleration:[aniParams[@"deceleration"] floatValue]];
    }
    animation.fromValue = fromValue;
    return animation;
}

+ (POPAnimation *)decayBounceWithParams:(NSDictionary *)aniParams
                            aniProperty:(NSString *)aniProperty
                              fromValue:(id)fromValue {
    if (![aniProperty isEqualToString:kPOPViewFrame]) {
        return [self decayWithParams:aniParams aniProperty:aniProperty fromValue:fromValue];
    }
    CGRect velocity = CGRectZero;
    CGFloat deceleration = 0.998;
    CGRect bounceRect = CGRectZero;
    if (aniParams[@"velocity"] != nil && [aniParams[@"velocity"] isKindOfClass:[NSString class]]) {
        velocity = [UXKProps toRectWithRect:aniParams[@"velocity"]];
    }
    if (aniParams[@"bounceRect"] != nil && [aniParams[@"bounceRect"] isKindOfClass:[NSString class]]) {
        bounceRect = [UXKProps toRectWithRect:aniParams[@"bounceRect"]];
    }
    if (aniParams[@"deceleration"] != nil && [aniParams[@"deceleration"] isKindOfClass:[NSNumber class]]) {
        deceleration = [aniParams[@"deceleration"] floatValue];
    }
    CGRect fromRect = [fromValue CGRectValue];
    CGRect finalRect = CGRectMake(fromRect.origin.x + ((velocity.origin.x / 1000.0) / (1 - deceleration)) * (1 - exp(-(1 - deceleration) * 16000)),
                                  fromRect.origin.y + ((velocity.origin.y / 1000.0) / (1 - deceleration)) * (1 - exp(-(1 - deceleration) * 16000)),
                                  fromRect.size.width + ((velocity.size.width / 1000.0) / (1 - deceleration)) * (1 - exp(-(1 - deceleration) * 16000)),
                                  fromRect.size.height + ((velocity.size.height / 1000.0) / (1 - deceleration)) * (1 - exp(-(1 - deceleration) * 16000)));
    CGFloat delta = 0.0;
    if (-(fromRect.origin.y) < bounceRect.origin.y) {
        fromRect.origin.y = -(bounceRect.origin.y);
        return [self springWithParams:@{@"bounciness": @(1.0)}
                          aniProperty:kPOPViewFrame
                            fromValue:nil
                              toValue:[NSValue valueWithCGRect:fromRect]];
    }
    else if (-(fromRect.origin.y) > bounceRect.origin.y + bounceRect.size.height) {
        fromRect.origin.y = -(bounceRect.origin.y + bounceRect.size.height);
        return [self springWithParams:@{@"bounciness": @(1.0)}
                          aniProperty:kPOPViewFrame
                            fromValue:nil
                              toValue:[NSValue valueWithCGRect:fromRect]];
    }
    else if (-(finalRect.origin.y) < bounceRect.origin.y) {
        delta = bounceRect.origin.y - (-(finalRect.origin.y));
    }
    else if (-(finalRect.origin.y) > bounceRect.origin.y + bounceRect.size.height) {
        delta = (-(finalRect.origin.y)) - (bounceRect.origin.y + bounceRect.size.height);
    }
    else {
        return [self decayWithParams:aniParams aniProperty:aniProperty fromValue:fromValue];
    }
    
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectZero];
    POPDecayAnimation *decayAnimation = [POPDecayAnimation animationWithPropertyNamed:aniProperty];
    [decayAnimation setVelocity:[NSValue valueWithCGRect:velocity]];
    [decayAnimation setDeceleration:deceleration];
    decayAnimation.fromValue = fromValue;
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:aniProperty];
    springAnimation.springBounciness = 1.0;
    __block BOOL springed = NO;
    [animationView pop_addAnimation:decayAnimation forKey:@"_"];
    POPCustomAnimation *customAnimation = [POPCustomAnimation animationWithBlock:^BOOL(id target, POPCustomAnimation *animation) {
        if ([target isKindOfClass:[UIView class]]) {
            CGRect newFrame = animationView.frame;
            if (springed) {
                [target setFrame:newFrame];
                return !springAnimation.isPaused;
            }
            else if (-(newFrame.origin.y) < bounceRect.origin.y - delta / 6.0) {
                // bounce up limited
                newFrame.origin.y = -((bounceRect.origin.y - delta / 6.0) / 3.0);
                [target setFrame:newFrame];
                if (!springed) {
                    springed = YES;
                    CGRect finalValue = [fromValue CGRectValue];
                    finalValue.origin.y = -(bounceRect.origin.y);
                    springAnimation.fromValue = [NSValue valueWithCGRect:newFrame];
                    springAnimation.toValue = [NSValue valueWithCGRect:finalValue];
                    [animationView pop_removeAllAnimations];
                    [animationView pop_addAnimation:springAnimation forKey:@"_"];
                    return YES;
                }
            }
            else if (-(newFrame.origin.y) < bounceRect.origin.y){
                // bounce up
                newFrame.origin.y = -(bounceRect.origin.y - (bounceRect.origin.y - (-(newFrame.origin.y))) / 3.0);
                [target setFrame:newFrame];
            }
            else if (-(newFrame.origin.y) > bounceRect.origin.y + bounceRect.size.height + delta / 6.0) {
                // bounce down limited
                newFrame.origin.y = -(bounceRect.origin.y + bounceRect.size.height + delta / 6.0 / 3.0);
                [target setFrame:newFrame];
                if (!springed) {
                    springed = YES;
                    CGRect finalValue = [fromValue CGRectValue];
                    finalValue.origin.y = -(bounceRect.origin.y + bounceRect.size.height);
                    springAnimation.fromValue = [NSValue valueWithCGRect:newFrame];
                    springAnimation.toValue = [NSValue valueWithCGRect:finalValue];
                    [animationView pop_removeAllAnimations];
                    [animationView pop_addAnimation:springAnimation forKey:@"_"];
                    return YES;
                }
            }
            else if (-(newFrame.origin.y) > bounceRect.origin.y + bounceRect.size.height) {
                // bounce down
                CGFloat dy = -(newFrame.origin.y) - (bounceRect.origin.y + bounceRect.size.height);
                newFrame.origin.y = -((bounceRect.origin.y + bounceRect.size.height) + dy / 3.0);
                [target setFrame:newFrame];
            }
            else {
                [target setFrame:newFrame];
            }
        }
        return !decayAnimation.isPaused;
    }];
    return customAnimation;
}

@end
