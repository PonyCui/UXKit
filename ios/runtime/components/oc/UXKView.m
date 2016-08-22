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
#import "UXKProps+LayoutFormat.h"

@interface UXKView ()

@end

@implementation UXKView

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.formatFrame != nil) {
        self.frame = [UXKProps rectWithView:self format:self.formatFrame];
        for (UIView *subview in self.subviews) {
            [subview layoutSubviews];
        }
    }
}

- (void)setProps:(NSDictionary *)props {
    if (props[@"frame"] && [props[@"frame"] isKindOfClass:[NSString class]]) {
        if ([(NSString *)props[@"frame"] containsString:@"["]) {
            if ([self isKindOfClass:[UXKView class]]) {
                [(UXKView *)self setFormatFrame:
                 [[props[@"frame"] stringByReplacingOccurrencesOfString:@"(" withString:@""]
                  stringByReplacingOccurrencesOfString:@")" withString:@""]];
            }
        }
        else {
            CGRect newFrame = [UXKProps toRectWithRect:props[@"frame"]];
            if (!CGRectEqualToRect(self.frame, newFrame)) {
                if (self.animationHandler == nil || ![self.animationHandler addAnimationWithView:self
                                                                                           props:kPOPViewFrame
                                                                                        newValue:[NSValue valueWithCGRect:newFrame]]) {
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
            if (self.animationHandler == nil || ![self.animationHandler addAnimationWithView:self
                                                                                       props:kPOPViewBackgroundColor
                                                                                    newValue:newBackgroundColor]) {
                self.backgroundColor = newBackgroundColor;
            }
        }
    }
    if (props[@"alpha"] && [props[@"alpha"] isKindOfClass:[NSString class]]) {
        CGFloat newAlpha = [UXKProps toCGFloat:props[@"alpha"]];
        if (newAlpha != self.alpha) {
            if (self.animationHandler == nil || ![self.animationHandler addAnimationWithView:self
                                                                                       props:kPOPViewAlpha
                                                                                    newValue:@(newAlpha)]) {
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
