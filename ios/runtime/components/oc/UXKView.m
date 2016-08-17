//
//  UXKView.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/14.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKView.h"
#import "UXKProps.h"

@interface UXKView ()

@end

@implementation UXKView

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.formatFrame != nil) {
        if (([self.formatFrame containsString:@"<"] || [self.formatFrame containsString:@">"]) && [self superview] != nil) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSInteger currentIndex = [[[self superview] subviews] indexOfObject:self];
                CGRect newFrame = [UXKProps toRectWithFormat:self.formatFrame
                                                     forView:self
                                                previousView:(currentIndex - 1 >= 0 ? [[self superview] subviews][currentIndex - 1] : nil)
                                                    nextView:(currentIndex + 1 < [[[self superview] subviews] count] ? [[self superview] subviews][currentIndex + 1] : nil)];
                if (!CGRectEqualToRect(self.frame, newFrame)) {
                    self.frame = newFrame;
                    for (UIView *subview in self.subviews) {
                        [subview layoutSubviews];
                    }
                }
            });
        }
        else {
            CGRect newFrame = [UXKProps toRectWithFormat:self.formatFrame
                                                 forView:self
                                            previousView:nil
                                                nextView:nil];
            if (!CGRectEqualToRect(self.frame, newFrame)) {
                self.frame = newFrame;
                for (UIView *subview in self.subviews) {
                    [subview layoutSubviews];
                }
            }
        }
    }
}

@end

@implementation UIView (UXKProps)

- (void)uxk_setProps:(NSDictionary *)props {
    if (props[@"frame"] && [props[@"frame"] isKindOfClass:[NSString class]]) {
        if ([(NSString *)props[@"frame"] containsString:@"["]) {
            if ([self isKindOfClass:[UXKView class]]) {
                [(UXKView *)self setFormatFrame:props[@"frame"]];
            }
        }
        else {
            self.frame = [UXKProps toRectWithRect:props[@"frame"]];
        }
    }
    if (props[@"userInteractionEnabled"] && [props[@"userInteractionEnabled"] isKindOfClass:[NSString class]]) {
        self.userInteractionEnabled = [UXKProps toBool:props[@"userInteractionEnabled"]];
    }
    if (props[@"clipsToBounds"] && [props[@"clipsToBounds"] isKindOfClass:[NSString class]]) {
        self.clipsToBounds = [UXKProps toBool:props[@"clipsToBounds"]];
    }
    if (props[@"backgroundColor"] && [props[@"backgroundColor"] isKindOfClass:[NSString class]]) {
        self.backgroundColor = [UXKProps toColor:props[@"backgroundColor"]];
    }
    if (props[@"alpha"] && [props[@"alpha"] isKindOfClass:[NSString class]]) {
        self.alpha = [UXKProps toCGFloat:props[@"alpha"]];
    }
    if (props[@"hidden"] && [props[@"hidden"] isKindOfClass:[NSString class]]) {
        self.hidden = [UXKProps toBool:props[@"hidden"]];
    }
}

@end
