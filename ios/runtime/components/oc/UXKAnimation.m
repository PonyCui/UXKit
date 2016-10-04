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

@end
