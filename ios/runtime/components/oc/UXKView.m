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

@property (nonatomic, assign) BOOL firstLayout;
    
@end

@implementation UXKView

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.firstLayout) {
        self.firstLayout = YES;
        [self layoutUXKViews:nil newRect:nil except:nil];
    }
}
    
- (void)layoutUXKViews:(UXKBridgeAnimationHandler *)animationHandler newRect:(NSValue *)newRectValue except:(UXKView *)except {
    CGRect newRect;
    if (self.formatFrame != nil) {
        newRect = [UXKProps rectWithView:self format:self.formatFrame];
    }
    else if (newRectValue != nil) {
        newRect = [newRectValue CGRectValue];
        self.willChangeToFrame = newRectValue;
    }
    else {
        return;
    }
    if (animationHandler == nil || ![animationHandler addAnimationWithView:self
                                                                     props:kPOPViewFrame
                                                                  newValue:[NSValue valueWithCGRect:newRect]]) {
        self.frame = newRect;
    }
    if (self.superview != nil && self.superview != except) {
        for (UXKView *subview in self.superview.subviews) {
            if (subview == except || subview == self || ![subview isKindOfClass:[UXKView class]]) {
                continue;
            }
            [subview layoutUXKViews:animationHandler newRect:nil except:self];
        }
    }
    for (UXKView *subview in self.subviews) {
        if (![subview isKindOfClass:[UXKView class]]) {
            continue;
        }
        [subview layoutUXKViews:animationHandler newRect:nil except:self];
    }
}

- (BOOL)staticLayouts {
    return NO;
}

- (void)setProps:(NSDictionary *)props {
    if (props[@"name"] && [props[@"name"] isKindOfClass:[NSString class]]) {
        self.name = props[@"name"];
    }
    if (props[@"frame"] && [props[@"frame"] isKindOfClass:[NSString class]]) {
        if ([(NSString *)props[@"frame"] containsString:@"["]) {
            if ([self isKindOfClass:[UXKView class]]) {
                [(UXKView *)self setFormatFrame:
                 [[props[@"frame"] stringByReplacingOccurrencesOfString:@"(" withString:@""]
                  stringByReplacingOccurrencesOfString:@")" withString:@""]];
                [self layoutUXKViews:self.animationHandler newRect:nil except:nil];
            }
        }
        else {
            [self layoutUXKViews:self.animationHandler
                         newRect:[NSValue valueWithCGRect:[UXKProps toRectWithRect:props[@"frame"]]]
                          except:nil];
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
        CGFloat newValue  = [UXKProps toCGFloat:props[@"cornerRadius"]];
        if (self.animationHandler == nil || ![self.animationHandler addAnimationWithView:self
                                                                                   props:kPOPLayerCornerRadius
                                                                                newValue:@(newValue)]) {
            self.layer.cornerRadius = newValue;
        }
    }
    if (props[@"borderWidth"] && [props[@"borderWidth"] isKindOfClass:[NSString class]]) {
        CGFloat newValue  = [UXKProps toCGFloat:props[@"borderWidth"]];
        if (self.animationHandler == nil || ![self.animationHandler addAnimationWithView:self
                                                                                   props:kPOPLayerBorderWidth
                                                                                newValue:@(newValue)]) {
            self.layer.borderWidth = newValue;
        }
    }
    if (props[@"borderColor"] && [props[@"borderColor"] isKindOfClass:[NSString class]]) {
        UIColor *newValue = [UXKProps toColor:props[@"borderColor"]];
        if (self.animationHandler == nil || ![self.animationHandler addAnimationWithView:self
                                                                                   props:kPOPLayerBorderColor
                                                                                newValue:newValue]) {
            self.layer.borderColor = newValue.CGColor;
        }
    }
}

@end
