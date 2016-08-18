//
//  UXKView.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/14.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKView.h"
#import "UXKProps.h"
#import "UXKBridgeAnimationHandler.h"
#import "UXKAnimation.h"
#import <pop/POP.h>

@interface UXKView ()

@end

@implementation UXKView

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self layoutSubviews];
}

- (CGRect)nextFrame {
    if (self.formatFrame != nil) {
        if (self.superview == nil) {
            return CGRectZero;
        }
        return [UXKProps toRectWithFormat:self.formatFrame
                           superViewFrame:[self superViewFrame]
                        previousViewFrame:[self.formatFrame containsString:@"<"] ? [self previousViewFrame] : CGRectZero
                            nextViewFrame:[self.formatFrame containsString:@">"] ? [self nextViewFrame] : CGRectZero];
    }
    else {
        return self.frame;
    }
}

- (CGRect)superViewFrame {
    UXKView *superView = (UXKView *)[self superview];
    if ([superView isKindOfClass:[UXKView class]]) {
        return [superView nextFrame];
    }
    else {
        return superView.frame;
    }
}

- (CGRect)previousViewFrame {
    NSInteger idx = (NSInteger)[[[self superview] subviews] indexOfObject:self];
    if (idx - 1 >= 0) {
        UXKView *previousView = [[self superview] subviews][idx - 1];
        if ([previousView isKindOfClass:[UXKView class]]) {
            if (previousView.formatFrame != nil && [previousView.formatFrame hasSuffix:@">"] &&
                self.formatFrame != nil && [self.formatFrame hasSuffix:@"<"]) {
                NSAssert(NO, @"Frame Conflict!");
                return CGRectZero;
            }
            return [previousView nextFrame];
        }
    }
    return CGRectZero;
}

- (CGRect)nextViewFrame {
    NSInteger idx = (NSInteger)[[[self superview] subviews] indexOfObject:self];
    if (idx + 1 < [[[self superview] subviews] count]) {
        UXKView *nextView = [[self superview] subviews][idx + 1];
        if ([nextView isKindOfClass:[UXKView class]]) {
            if (nextView.formatFrame != nil && [nextView.formatFrame hasSuffix:@"<"] &&
                self.formatFrame != nil && [self.formatFrame hasSuffix:@">"]) {
                NSAssert(NO, @"Frame Conflict!");
                return CGRectZero;
            }
            return [nextView nextFrame];
        }
    }
    return CGRectMake([self superViewFrame].size.width, [self superViewFrame].size.height, 0, 0);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.formatFrame != nil) {
        self.frame = [self nextFrame];
        for (UIView *subview in self.subviews) {
            [subview layoutSubviews];
        }
    }
}

- (void)setProps:(NSDictionary *)props {
    if (props[@"frame"] && [props[@"frame"] isKindOfClass:[NSString class]]) {
        if ([(NSString *)props[@"frame"] containsString:@"["]) {
            if ([self isKindOfClass:[UXKView class]]) {
                [(UXKView *)self setFormatFrame:props[@"frame"]];
            }
        }
        else {
            CGRect newFrame = [UXKProps toRectWithRect:props[@"frame"]];
            if (!CGRectEqualToRect(self.frame, newFrame)) {
                if (self.animationHandler == nil || ![self.animationHandler addAnimationWithView:self props:kPOPViewFrame newValue:[NSValue valueWithCGRect:newFrame]]) {
                    self.frame = newFrame;
                }
            }
        }
    }
    if (props[@"userInteractionEnabled"] && [props[@"userInteractionEnabled"] isKindOfClass:[NSString class]]) {
        self.userInteractionEnabled = [UXKProps toBool:props[@"userInteractionEnabled"]];
    }
    if (props[@"clipsToBounds"] && [props[@"clipsToBounds"] isKindOfClass:[NSString class]]) {
        self.clipsToBounds = [UXKProps toBool:props[@"clipsToBounds"]];
    }
    if (props[@"backgroundColor"] && [props[@"backgroundColor"] isKindOfClass:[NSString class]]) {
        UIColor *newBackgroundColor = [UXKProps toColor:props[@"backgroundColor"]];
        if (![newBackgroundColor isEqual:self.backgroundColor]) {
            if (self.animationHandler == nil || ![self.animationHandler addAnimationWithView:self props:kPOPViewBackgroundColor newValue:newBackgroundColor]) {
                self.backgroundColor = newBackgroundColor;
            }
        }
    }
    if (props[@"alpha"] && [props[@"alpha"] isKindOfClass:[NSString class]]) {
        CGFloat newAlpha = [UXKProps toCGFloat:props[@"alpha"]];
        if (newAlpha != self.alpha) {
            if (self.animationHandler == nil || ![self.animationHandler addAnimationWithView:self props:kPOPViewAlpha newValue:@(newAlpha)]) {
                self.alpha = newAlpha;
            }
        }
    }
    if (props[@"hidden"] && [props[@"hidden"] isKindOfClass:[NSString class]]) {
        self.hidden = [UXKProps toBool:props[@"hidden"]];
    }
    if (props[@"cornerRadius"] && [props[@"cornerRadius"] isKindOfClass:[NSString class]]) {
        self.layer.cornerRadius = [UXKProps toCGFloat:props[@"cornerRadius"]];
    }
    if (props[@"borderWidth"] && [props[@"borderWidth"] isKindOfClass:[NSString class]]) {
        self.layer.borderWidth = [UXKProps toCGFloat:props[@"borderWidth"]];
    }
    if (props[@"borderColor"] && [props[@"borderColor"] isKindOfClass:[NSString class]]) {
        self.layer.borderColor = [UXKProps toColor:props[@"borderColor"]].CGColor;
    }
}

@end
