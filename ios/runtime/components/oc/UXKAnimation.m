//
//  UXKAnimation.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/17.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKAnimation.h"
#import <pop/POP.h>

@implementation UXKAnimation

+ (POPAnimation *)animationWithParams:(NSDictionary *)aniParams
                          aniProperty:(NSString *)aniProperty
                            fromValue:(id)fromValue
                              toValue:(id)toValue {
    if ([aniParams[@"aniType"] isKindOfClass:[NSString class]]) {
        if ([aniParams[@"aniType"] isEqualToString:@"spring"]) {
            return [self springWithParams:aniParams
                              aniProperty:aniProperty
                                fromValue:fromValue
                                  toValue:toValue];
        }
    }
    return nil;
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

@end
