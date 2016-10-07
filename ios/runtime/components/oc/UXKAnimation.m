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

@interface UXKAnimationObject : NSObject

@property (nonatomic, assign) CGFloat val;

+ (POPAnimatableProperty *)aniProps;

@end

@implementation UXKAnimationObject

+ (POPAnimatableProperty *)aniProps {
    POPAnimatableProperty *aniProps = [POPAnimatableProperty propertyWithName:@"com.UXKanimationObject.val" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            [obj setVal:values[0]];
        };
        prop.readBlock = ^(id obj, CGFloat values[]) {
            values[0] = [obj val];
        };
    }];
    return aniProps;
}

@end

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

+ (void)runAnimation:(void (^)(CGFloat value, BOOL finished))valueBlock
            velocity:(CGFloat)velocity
        deceleration:(CGFloat)deceleration
              bounce:(BOOL)bounce
         bouncePoint:(CGPoint)bouncePoint
           fromValue:(CGFloat)fromValue {
    UXKAnimationObject *animationObject = [UXKAnimationObject new];
    CGFloat maxValue = fromValue + ((velocity / 1000.0) / (1 - deceleration)) * (1 - exp(-(1 - deceleration) * 16000));
    CGFloat delta = 0.0;
    if (-fromValue < bouncePoint.x) {
        POPSpringAnimation *animation = [POPSpringAnimation animation];
        animation.property = [UXKAnimationObject aniProps];
        animation.fromValue = @(fromValue);
        animation.toValue = @(-bouncePoint.x);
        [animation setAnimationDidApplyBlock:^(POPAnimation *_) {
            valueBlock(animationObject.val, NO);
        }];
        [animation setCompletionBlock:^(POPAnimation *_, BOOL __) {
            valueBlock(animationObject.val, YES);
        }];
        [animationObject pop_addAnimation:animation forKey:@"_"];
        return;
    }
    else if (-fromValue > bouncePoint.x + bouncePoint.y) {
        POPSpringAnimation *animation = [POPSpringAnimation animation];
        animation.property = [UXKAnimationObject aniProps];
        animation.fromValue = @(fromValue);
        animation.toValue = @(-(bouncePoint.x + bouncePoint.y));
        [animation setAnimationDidApplyBlock:^(POPAnimation *_) {
            valueBlock(animationObject.val, NO);
        }];
        [animation setCompletionBlock:^(POPAnimation *_, BOOL __) {
            valueBlock(animationObject.val, YES);
        }];
        [animationObject pop_addAnimation:animation forKey:@"_"];
        return;
    }
    else if (-maxValue < bouncePoint.x) {
        delta = bouncePoint.x - (-maxValue);
    }
    else if (-maxValue > bouncePoint.x + bouncePoint.y) {
        delta = (-maxValue) - (bouncePoint.x + bouncePoint.y);
    }
    else {
        POPDecayAnimation *animation = [POPDecayAnimation animation];
        animation.property = [UXKAnimationObject aniProps];
        animation.velocity = @(velocity);
        animation.fromValue = @(fromValue);
        [animation setAnimationDidApplyBlock:^(POPAnimation *_) {
            valueBlock(animationObject.val, NO);
        }];
        [animation setCompletionBlock:^(POPAnimation *_, BOOL __) {
            valueBlock(animationObject.val, YES);
        }];
        [animationObject pop_addAnimation:animation forKey:@"_"];
        return;
    }
    POPDecayAnimation *decayAnimation = [POPDecayAnimation animation];
    decayAnimation.property = [UXKAnimationObject aniProps];
    [decayAnimation setVelocity:@(velocity)];
    [decayAnimation setDeceleration:deceleration];
    decayAnimation.fromValue = @(fromValue);
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [UXKAnimationObject aniProps];
    springAnimation.springBounciness = 1.0;
    [decayAnimation setAnimationDidApplyBlock:^(POPAnimation *_) {
        CGFloat newValue = animationObject.val;
        BOOL limited = NO;
        if (-(newValue) < bouncePoint.x - delta / 6.0) {
            // top bounce limited
            newValue = -((bouncePoint.x - delta / 6.0) / 3.0);
            springAnimation.toValue = @(-bouncePoint.x);
            limited = YES;
        }
        else if (-(newValue) < bouncePoint.x) {
            // top bounce start
            newValue = -(bouncePoint.x - (bouncePoint.x - (-(newValue))) / 3.0);
            if (!bounce) {
                newValue = -bouncePoint.x;
                [animationObject pop_removeAllAnimations];
                valueBlock(newValue, YES);
                return;
            }
        }
        else if (-(newValue) > bouncePoint.x + bouncePoint.y + delta / 6.0) {
            // bottom bounce limited
            newValue = -(bouncePoint.x + bouncePoint.y + delta / 6.0 / 3.0);
            springAnimation.toValue = @(-(bouncePoint.x + bouncePoint.y));
            limited = YES;
        }
        else if (-(newValue) > bouncePoint.x + bouncePoint.y) {
            // bottom bounce start
            CGFloat dy = -(newValue) - (bouncePoint.x + bouncePoint.y);
            newValue = -((bouncePoint.x + bouncePoint.y) + dy / 3.0);
            if (!bounce) {
                newValue = -((bouncePoint.x + bouncePoint.y));
                [animationObject pop_removeAllAnimations];
                valueBlock(newValue, YES);
                return;
            }
        }
        valueBlock(newValue, NO);
        if (limited) {
            springAnimation.fromValue = @(newValue);
            [animationObject pop_removeAllAnimations];
            [animationObject pop_addAnimation:springAnimation forKey:@"_"];
        }
    }];
    [springAnimation setAnimationDidApplyBlock:^(POPAnimation *_) {
        valueBlock(animationObject.val, NO);
    }];
    [springAnimation setCompletionBlock:^(POPAnimation *_, BOOL __) {
        valueBlock(animationObject.val, YES);
    }];
    [animationObject pop_addAnimation:decayAnimation forKey:@"_"];
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
    CGRect fromRect = [fromValue CGRectValue];
    BOOL bounce = YES;
    if (aniParams[@"velocity"] != nil && [aniParams[@"velocity"] isKindOfClass:[NSString class]]) {
        velocity = [UXKProps toRectWithRect:aniParams[@"velocity"]];
    }
    if (aniParams[@"bounceRect"] != nil && [aniParams[@"bounceRect"] isKindOfClass:[NSString class]]) {
        bounceRect = [UXKProps toRectWithRect:aniParams[@"bounceRect"]];
    }
    if (aniParams[@"deceleration"] != nil && [aniParams[@"deceleration"] isKindOfClass:[NSNumber class]]) {
        deceleration = [aniParams[@"deceleration"] floatValue];
    }
    if (aniParams[@"bounce"] != nil && [aniParams[@"bounce"] isKindOfClass:[NSNumber class]]) {
        bounce = [aniParams[@"bounce"] boolValue];
    }
    __block CGFloat x = 0.0;
    __block CGFloat y = 0.0;
    __block BOOL xEnd = NO;
    __block BOOL yEnd = NO;
    [self runAnimation:^(CGFloat value, BOOL finished) {
        x = value;
        xEnd = finished;
    } velocity:velocity.origin.x
          deceleration:deceleration
                bounce:bounce
           bouncePoint:CGPointMake(bounceRect.origin.x, bounceRect.size.width)
             fromValue:fromRect.origin.x];
    [self runAnimation:^(CGFloat value, BOOL finished) {
        y = value;
        yEnd = finished;
    } velocity:velocity.origin.y
          deceleration:deceleration
                bounce:bounce
           bouncePoint:CGPointMake(bounceRect.origin.y, bounceRect.size.height)
             fromValue:fromRect.origin.y];
    POPCustomAnimation *customAnimation = [POPCustomAnimation animationWithBlock:^BOOL(id target, POPCustomAnimation *animation) {
//        NSLog(@"%f, %f", x, y);
        [target setFrame:CGRectMake(x, y, fromRect.size.width, fromRect.size.height)];
        return !(xEnd && yEnd);
    }];
    return customAnimation;
}

@end
