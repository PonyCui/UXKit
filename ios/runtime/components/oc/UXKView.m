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

- (NSString *)description {
    return [NSString stringWithFormat:@"Name = %@, %@", self.name, [super description]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect shouldChangeRect = [self.shouldChangeToFrame CGRectValue];
    if (shouldChangeRect.size.width == -1.0 || shouldChangeRect.size.height == -1.0) {
        [self layoutUXKViews:nil newRect:self.shouldChangeToFrame except:nil];
    }
    else {
        [self layoutUXKViews:nil newRect:nil except:nil];
    }
}
    
- (void)layoutUXKViews:(UXKBridgeAnimationHandler *)animationHandler newRect:(NSValue *)newRectValue except:(UXKView *)except {
    CGRect newRect = CGRectZero;
    BOOL hasNewRect = NO;
    if (self.formatFrame != nil) {
        newRect = [UXKProps rectWithView:self format:self.formatFrame];
        hasNewRect = YES;
    }
    else if (newRectValue != nil) {
        newRect = [newRectValue CGRectValue];
        self.willChangeToFrame = newRectValue;
        hasNewRect = YES;
    }
    else if (self.shouldChangeToFrame != nil) {
        CGRect shouldChangeRect = [self.shouldChangeToFrame CGRectValue];
        if (shouldChangeRect.size.width == -1.0 || shouldChangeRect.size.height == -1.0) {
            newRect = shouldChangeRect;
            self.willChangeToFrame = self.shouldChangeToFrame;
            hasNewRect = YES;
        }
    }
    if (hasNewRect) {
        if (animationHandler == nil || ![animationHandler addAnimationWithView:self
                                                                         props:kPOPViewFrame
                                                                      newValue:[NSValue valueWithCGRect:newRect]]) {
            if (newRect.size.width == -1) {
                newRect.size.width = self.superview.bounds.size.width;
            }
            if (newRect.size.height == -1) {
                newRect.size.height = self.superview.bounds.size.height;
            }
            self.frame = newRect;
        }
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
                [self setFormatFrame:
                 [[props[@"frame"] stringByReplacingOccurrencesOfString:@"(" withString:@""]
                  stringByReplacingOccurrencesOfString:@")" withString:@""]];
                [self layoutUXKViews:self.animationHandler newRect:nil except:nil];
            }
        }
        else {
            if ([props[@"frame"] rangeOfString:@"*"].location != NSNotFound) {
                CGRect newRect = [UXKProps toRectWithRect:props[@"frame"]];
                newRect.size = [self intrinsicContentSizeWithProps:props];
                [self layoutUXKViews:self.animationHandler
                             newRect:[NSValue valueWithCGRect:newRect]
                              except:nil];
            }
            else {
                [self setShouldChangeToFrame:[NSValue valueWithCGRect:[UXKProps toRectWithRect:props[@"frame"]]]];
                [self layoutUXKViews:self.animationHandler
                             newRect:[NSValue valueWithCGRect:[UXKProps toRectWithRect:props[@"frame"]]]
                              except:nil];
            }
        }
    }
    if (props[@"userinteractionenabled"] && [props[@"userinteractionenabled"] isKindOfClass:[NSString class]]) {
        self.userInteractionEnabled = [UXKProps toBool:props[@"userinteractionenabled"]];
    }
    if (props[@"clipstobounds"] && [props[@"clipstobounds"] isKindOfClass:[NSString class]]) {
        self.clipsToBounds = [UXKProps toBool:props[@"clipstobounds"]];
    }
    if (props[@"backgroundcolor"] && [props[@"backgroundcolor"] isKindOfClass:[NSString class]]) {
        UIColor *newBackgroundColor = [UXKProps toColor:props[@"backgroundcolor"]];
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
    if (props[@"cornerradius"] && [props[@"cornerradius"] isKindOfClass:[NSString class]]) {
        CGFloat newValue  = [UXKProps toCGFloat:props[@"cornerradius"]];
        if (self.animationHandler == nil || ![self.animationHandler addAnimationWithView:self
                                                                                   props:kPOPLayerCornerRadius
                                                                                newValue:@(newValue)]) {
            self.layer.cornerRadius = newValue;
        }
    }
    if (props[@"borderwidth"] && [props[@"borderwidth"] isKindOfClass:[NSString class]]) {
        CGFloat newValue  = [UXKProps toCGFloat:props[@"borderWidth"]];
        if (self.animationHandler == nil || ![self.animationHandler addAnimationWithView:self
                                                                                   props:kPOPLayerBorderWidth
                                                                                newValue:@(newValue)]) {
            self.layer.borderWidth = newValue;
        }
    }
    if (props[@"bordercolor"] && [props[@"bordercolor"] isKindOfClass:[NSString class]]) {
        UIColor *newValue = [UXKProps toColor:props[@"bordercolor"]];
        if (self.animationHandler == nil || ![self.animationHandler addAnimationWithView:self
                                                                                   props:kPOPLayerBorderColor
                                                                                newValue:newValue]) {
            self.layer.borderColor = newValue.CGColor;
        }
    }
}

- (void)requestValueWithKey:(NSString *)aKey valueBlock:(UXKViewValueBlock)valueBlock {
    if ([aKey isEqualToString:@"blur"]) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }
    else if ([aKey isEqualToString:@"frame"]) {
        valueBlock(@{
                     @"x": @(self.frame.origin.x),
                     @"y": @(self.frame.origin.y),
                     @"width": @(self.frame.size.width),
                     @"height": @(self.frame.size.height),
                     });
    }
}

- (void)listenValueWithKey:(NSString *)aKey valueBlock:(UXKViewValueBlock)valueBlock {
    
}

- (CGSize)intrinsicContentSizeWithProps:(NSDictionary *)props {
    return CGSizeZero;
}

@end
