//
//  UXKView.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/14.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKView.h"
#import "UXKBridge.h"
#import "UXKProps.h"
#import "UXKBridgeController.h"
#import "UXKBridgeAnimationHandler.h"
#import "UXKBridgeCallbackHandler.h"
#import "UXKAnimation.h"
#import <pop/POP.h>
#import "UXKProps+LayoutFormat.h"

@interface UXKView ()
    
@end

@implementation UXKView

+ (void)load {
    [UXKBridge addClass:[self class] nodeName:@"View"];
}

#pragma mark - Props

- (void)setProps:(NSDictionary *)props updatePropsOnly:(BOOL)updatePropsOnly {
    self.props = props;
    NSArray *excepts = nil;
    if (updatePropsOnly) {
        if (self.superview != nil) {
            excepts = [@[self.superview] arrayByAddingObjectsFromArray:self.subviews];
        }
        else {
            excepts = self.subviews;
        }
    }
    if ([props[@"_uxk_layoutcallbackid"] isKindOfClass:[NSString class]]) {
        self.layoutCallbackID = props[@"_uxk_layoutcallbackid"];
    }
    if (props[@"_uxk_vkey"] && [props[@"_uxk_vkey"] isKindOfClass:[NSString class]]) {
        self.visualDOMKey = props[@"_uxk_vkey"];
    }
    if (props[@"frame"] && [props[@"frame"] isKindOfClass:[NSString class]]) {
        if ([(NSString *)props[@"frame"] containsString:@"["]) {
            if ([self isKindOfClass:[UXKView class]]) {
                [self setFormatFrame:
                 [[props[@"frame"] stringByReplacingOccurrencesOfString:@"(" withString:@""]
                  stringByReplacingOccurrencesOfString:@")" withString:@""]];
                [self layoutUXKViews:self.animationHandler newRect:nil excepts:excepts];
            }
        }
        else {
            if ([props[@"frame"] rangeOfString:@"*"].location != NSNotFound) {
                CGRect newRect = [UXKProps toRectWithRect:props[@"frame"]];
                CGSize intrinsicSize = [self intrinsicContentSizeWithProps:props];
                if (newRect.size.width == 0.0) {
                    newRect.size.width = intrinsicSize.width;
                }
                if (newRect.size.height == 0.0) {
                    newRect.size.height = intrinsicSize.height;
                }
                [self layoutUXKViews:self.animationHandler
                             newRect:[NSValue valueWithCGRect:newRect]
                             excepts:excepts];
            }
            else {
                [self setShouldChangeToFrame:[NSValue valueWithCGRect:[UXKProps toRectWithRect:props[@"frame"]]]];
                [self layoutUXKViews:self.animationHandler
                             newRect:[NSValue valueWithCGRect:[UXKProps toRectWithRect:props[@"frame"]]]
                              excepts:excepts];
            }
        }
    }
    if (props[@"transform"] && [props[@"transform"] isKindOfClass:[NSString class]]) {
        CGAffineTransform transform = [UXKProps toTransform:props[@"transform"]];
        if (!CGAffineTransformEqualToTransform(transform, self.transform)) {
            if (transform.b == 0.0 && transform.c == 0.0 && transform.tx == 0.0 && transform.ty == 0.0) {
                if (self.animationHandler == nil || ![self.animationHandler addAnimationWithView:self
                                                                                           props:kPOPViewScaleXY
                                                                                        newValue:[NSValue valueWithCGSize:CGSizeMake(transform.a, transform.d)]]) {
                    self.transform = transform;
                }
            }
            else {
                self.transform = transform;
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
        if (newValue != self.layer.cornerRadius) {
            if (self.animationHandler == nil || ![self.animationHandler addAnimationWithView:self
                                                                                       props:kPOPLayerCornerRadius
                                                                                    newValue:@(newValue)]) {
                self.layer.cornerRadius = newValue;
            }
        }
    }
    if (props[@"borderwidth"] && [props[@"borderwidth"] isKindOfClass:[NSString class]]) {
        CGFloat newValue  = [UXKProps toCGFloat:props[@"borderwidth"]];
        if (newValue != self.layer.borderWidth) {
            if (self.animationHandler == nil || ![self.animationHandler addAnimationWithView:self
                                                                                       props:kPOPLayerBorderWidth
                                                                                    newValue:@(newValue)]) {
                self.layer.borderWidth = newValue;
            }
        }
    }
    if (props[@"bordercolor"] && [props[@"bordercolor"] isKindOfClass:[NSString class]]) {
        UIColor *newValue = [UXKProps toColor:props[@"bordercolor"]];
        if (![newValue isEqual:[UIColor colorWithCGColor:self.layer.borderColor]]) {
            if (self.animationHandler == nil || ![self.animationHandler addAnimationWithView:self
                                                                                       props:kPOPLayerBorderColor
                                                                                    newValue:newValue]) {
                self.layer.borderColor = newValue.CGColor;
            }
        }
    }
    if (props[@"shadowcolor"] && [props[@"shadowcolor"] isKindOfClass:[NSString class]]) {
        UIColor *newValue = [UXKProps toColor:props[@"shadowcolor"]];
        if (![newValue isEqual:[UIColor colorWithCGColor:self.layer.borderColor]]) {
            self.layer.shadowColor = newValue.CGColor;
        }
    }
    if (props[@"shadowoffset"] && [props[@"shadowoffset"] isKindOfClass:[NSString class]]) {
        CGSize newValue = [UXKProps toCGSize:props[@"shadowoffset"]];
        if (!CGSizeEqualToSize(newValue, self.layer.shadowOffset)) {
            self.layer.shadowOffset = newValue;
        }
    }
    if (props[@"shadowradius"] && [props[@"shadowradius"] isKindOfClass:[NSString class]]) {
        CGFloat newValue = [UXKProps toCGFloat:props[@"shadowradius"]];
        if (newValue != self.layer.shadowRadius) {
            self.layer.shadowRadius = newValue;
        }
    }
    if (props[@"shadowopacity"] && [props[@"shadowopacity"] isKindOfClass:[NSString class]]) {
        CGFloat newValue = [UXKProps toCGFloat:props[@"shadowopacity"]];
        if (newValue != self.layer.shadowOpacity) {
            self.layer.shadowOpacity = newValue;
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

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect shouldChangeRect = [self.shouldChangeToFrame CGRectValue];
    if (shouldChangeRect.size.width == -1.0 || shouldChangeRect.size.height == -1.0) {
        [self layoutUXKViews:nil newRect:self.shouldChangeToFrame excepts:nil];
    }
    else {
        [self layoutUXKViews:nil newRect:nil excepts:nil];
    }
}

- (void)setFrame:(CGRect)frame {
    BOOL originChanged = !CGPointEqualToPoint(frame.origin, self.frame.origin);
    BOOL sizeChanged = !CGSizeEqualToSize(frame.size, self.frame.size);
    [super setFrame:frame];
    if (self.layoutCallbackID != nil) {
        [self.bridgeController.callbackHandler callback:self.layoutCallbackID
                                                   args:@[
                                                          @{
                                                              @"x": @(self.frame.origin.x),
                                                              @"y": @(self.frame.origin.y),
                                                              @"width": @(self.frame.size.width),
                                                              @"height": @(self.frame.size.height),
                                                              @"originChanged": @(originChanged),
                                                              @"sizeChanged": @(sizeChanged),
                                                              }
                                                          ]];
    }
}

- (void)layoutUXKViews:(UXKBridgeAnimationHandler *)animationHandler newRect:(NSValue *)newRectValue excepts:(NSArray<UXKView *> *)excepts {
    CGRect newRect = CGRectZero;
    BOOL hasNewRect = NO;
    if (self.formatFrame != nil) {
        newRect = [UXKProps rectWithView:self format:self.formatFrame];
        hasNewRect = YES;
    }
    else if (newRectValue != nil) {
        newRect = [newRectValue CGRectValue];
        hasNewRect = YES;
    }
    else if (self.shouldChangeToFrame != nil) {
        CGRect shouldChangeRect = [self.shouldChangeToFrame CGRectValue];
        if (shouldChangeRect.size.width == -1.0 || shouldChangeRect.size.height == -1.0) {
            newRect = shouldChangeRect;
            hasNewRect = YES;
        }
        self.shouldChangeToFrame = nil;
    }
    if (hasNewRect) {
        if (newRect.size.width == -1) {
            newRect.size.width = self.superview.bounds.size.width;
        }
        if (newRect.size.height == -1) {
            newRect.size.height = self.superview.bounds.size.height;
        }
        if (!CGRectEqualToRect(self.frame, newRect)) {
            if (animationHandler == nil || ![animationHandler addAnimationWithView:self
                                                                             props:kPOPViewFrame
                                                                          newValue:[NSValue valueWithCGRect:newRect]]) {
                self.willChangeToFrame = [NSValue valueWithCGRect:newRect];
                self.frame = newRect;
            }
        }
    }
    if (self.superview != nil && ![excepts containsObject:(id)self.superview]) {
        for (UXKView *subview in self.superview.subviews) {
            if ([excepts containsObject:subview] || subview == self || ![subview isKindOfClass:[UXKView class]]) {
                continue;
            }
            [subview layoutUXKViews:animationHandler newRect:nil excepts:self.superview.subviews];
        }
    }
    for (UXKView *subview in self.subviews) {
        if (![subview isKindOfClass:[UXKView class]]) {
            continue;
        }
        [subview layoutUXKViews:animationHandler newRect:nil excepts:@[self]];
    }
}

- (CGSize)intrinsicContentSizeWithProps:(NSDictionary *)props {
    return CGSizeZero;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.touchCallback) {
        self.touchCallback(@"Began");
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.touchCallback) {
        self.touchCallback(@"Ended");
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    if (self.touchCallback) {
        self.touchCallback(@"Cancelled");
    }
}

#pragma mark - Others

- (NSString *)description {
    return [NSString stringWithFormat:@"Name = %@, %@", self.props[@"name"], [super description]];
}

- (BOOL)staticLayouts {
    return NO;
}

@end
