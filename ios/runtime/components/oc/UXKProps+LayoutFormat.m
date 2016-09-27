//
//  UXKProps+LayoutFormat.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/19.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKProps+LayoutFormat.h"

@implementation UXKProps (LayoutFormat)

+ (CGRect)rectWithView:(UXKView *)view format:(NSString *)format {
    if (![format containsString:@","]) {
        return CGRectZero;
    }
    if ([self conflict:view]) {
        NSAssert(NO, @"Frame conflict.");
        return CGRectZero;
    }
    NSString *horizonFormat = [format componentsSeparatedByString:@","].firstObject;
    NSString *verticalFormat = [format componentsSeparatedByString:@","].lastObject;
    CGRect horizonRect = [self horizonRectWithView:view format:horizonFormat];
    CGRect verticalRect = [self verticalRectWithView:view format:verticalFormat];
    return CGRectMake(horizonRect.origin.x, verticalRect.origin.y, horizonRect.size.width, verticalRect.size.height);
}

+ (BOOL)conflict:(UXKView *)view {
    NSString *thisHorizonFormat;
    NSString *thisVerticalFormat;
    NSString *prevHorizonFormat;
    NSString *prevVerticalFormat;
    NSString *nextHorizonFormat;
    NSString *nextVerticalFormat;
    if (view.formatFrame != nil && [view.formatFrame containsString:@","]) {
        thisHorizonFormat = [view.formatFrame componentsSeparatedByString:@","].firstObject;
        thisVerticalFormat = [view.formatFrame componentsSeparatedByString:@","].lastObject;
    }
    {
        NSInteger idx = (NSInteger)[[[view superview] subviews] indexOfObject:view];
        if (idx - 1 >= 0) {
            UXKView *previousView = [[view superview] subviews][idx - 1];
            if ([previousView isKindOfClass:[UXKView class]] && previousView.formatFrame != nil) {
                if ([previousView.formatFrame containsString:@","]) {
                    prevHorizonFormat = [previousView.formatFrame componentsSeparatedByString:@","].firstObject;
                    prevVerticalFormat = [previousView.formatFrame componentsSeparatedByString:@","].lastObject;
                }
            }
        }
    }
    {
        NSInteger idx = (NSInteger)[[[view superview] subviews] indexOfObject:view];
        if (idx + 1 < [[[view superview] subviews] count]) {
            UXKView *nextView = [[view superview] subviews][idx + 1];
            if ([nextView isKindOfClass:[UXKView class]] && nextView.formatFrame != nil) {
                if ([nextView.formatFrame containsString:@","]) {
                    nextHorizonFormat = [nextView.formatFrame componentsSeparatedByString:@","].firstObject;
                    nextVerticalFormat = [nextView.formatFrame componentsSeparatedByString:@","].lastObject;
                }
            }
        }
    }
    if (thisHorizonFormat != nil && prevHorizonFormat != nil) {
        if ([self relatePrev:thisHorizonFormat] && [self relateNext:prevHorizonFormat]) {
            return YES;
        }
    }
    if (thisHorizonFormat != nil && nextHorizonFormat != nil) {
        if ([self relateNext:thisHorizonFormat] && [self relatePrev:nextHorizonFormat]) {
            return YES;
        }
    }
    if (thisVerticalFormat != nil && prevVerticalFormat != nil) {
        if ([self relatePrev:thisVerticalFormat] && [self relateNext:prevVerticalFormat]) {
            return YES;
        }
    }
    if (thisVerticalFormat != nil && nextVerticalFormat != nil) {
        if ([self relateNext:thisVerticalFormat] && [self relatePrev:nextVerticalFormat]) {
            return YES;
        }
    }
    return NO;
}

+ (CGRect)horizonRectWithView:(UXKView *)view format:(NSString *)format {
    CGPoint point = [self rectWithFormat:format
                              superPoint:([self pressLeft:format] || [self pressRight:format]) ? [self superHorizonRect:view] : CGPointZero
                               prevPoint:[self relatePrev:format] ? [self prevHorizonRect:view] : CGPointZero
                               nextPoint:[self relateNext:format] ? [self nextHorizonRect:view] : CGPointZero
                                    view:view
                     ];
    return CGRectMake(point.x, 0, point.y, 0);
}

+ (CGRect)verticalRectWithView:(UXKView *)view format:(NSString *)format {
    CGPoint superPoint = CGPointZero;
    if ([self pressLeft:format] || [self pressRight:format]) {
        superPoint = [self superVerticalRect:view];
    }
    else if ([self pressLeftPadding:format] && [self pressRightPadding:format]) {
        superPoint = [self superVerticalPaddingRect:view];
    }
    CGPoint point = [self rectWithFormat:format
                              superPoint:superPoint
                               prevPoint:[self relatePrev:format] ? [self prevVerticalRect:view] : CGPointZero
                               nextPoint:[self relateNext:format] ? [self nextVerticalRect:view] : CGPointZero
                                    view:view
                     ];
    return CGRectMake(0, point.x, 0, point.y);
}

+ (CGPoint)rectWithFormat:(NSString *)format
              superPoint:(CGPoint)superPoint
               prevPoint:(CGPoint)prevPoint
               nextPoint:(CGPoint)nextPoint
                    view:(UXKView *)view {
    static NSRegularExpression *leftExp;
    static NSRegularExpression *widthExp;
    static NSRegularExpression *rightExp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        leftExp = [NSRegularExpression regularExpressionWithPattern:@"([<\\|\\!]+)-([@\\-0-9]+)-"
                                                            options:kNilOptions
                                                              error:nil];
        widthExp = [NSRegularExpression regularExpressionWithPattern:@"\\[([<>0-9]+)\\]"
                                                             options:kNilOptions
                                                               error:nil];
        rightExp = [NSRegularExpression regularExpressionWithPattern:@"-([@\\-0-9]+)-([\\!\\|>])"
                                                             options:kNilOptions
                                                               error:nil];
    });
    CGFloat origin = 0.0, distance = 0.0;
    CGFloat lVal = 0.0, cVal = 0.0, rVal = 0.0;
    BOOL lFlex = NO, rFlex = NO;
    BOOL lEqual = NO, rEqual = NO;
    {
        NSArray<NSTextCheckingResult *> *results = [leftExp matchesInString:format
                                                                    options:NSMatchingReportCompletion
                                                                      range:NSMakeRange(0, [format length])];
        if ([results firstObject] != nil && 2 < [[results firstObject] numberOfRanges]) {
            NSString *val = [format substringWithRange:[[results firstObject] rangeAtIndex:2]];
            if ([val isEqualToString:@"@"]) {
                lFlex = YES;
            }
            else {
                lVal = origin = [val floatValue];
            }
        }
    }
    {
        NSArray<NSTextCheckingResult *> *results = [widthExp matchesInString:format
                                                                     options:NSMatchingReportCompletion
                                                                       range:NSMakeRange(0, [format length])];
        if ([results firstObject] != nil && 1 < [[results firstObject] numberOfRanges]) {
            NSString *cString = [format substringWithRange:[[results firstObject] rangeAtIndex:1]];
            if ([cString isEqualToString:@"<"]) {
                lEqual = YES;
                cVal = distance = prevPoint.y;
            }
            else if ([cString isEqualToString:@">"]) {
                rEqual = YES;
                cVal = distance = nextPoint.y;
            }
            else {
                cVal = distance = [cString floatValue];
            }
        }
    }
    {
        NSArray<NSTextCheckingResult *> *results = [rightExp matchesInString:format
                                                                     options:NSMatchingReportCompletion
                                                                       range:NSMakeRange(0, [format length])];
        if ([results firstObject] != nil && 2 < [[results firstObject] numberOfRanges]) {
            NSString *val = [format substringWithRange:[[results firstObject] rangeAtIndex:1]];
            if ([val isEqualToString:@"@"]) {
                rFlex = YES;
            }
            else {
                if (distance > 0.0) {
                    origin = superPoint.y - [val floatValue] - distance;
                }
                else {
                    distance = superPoint.y - [val floatValue] - origin;
                }
                rVal = [val floatValue];
            }
        }
    }
    if (lFlex && rFlex && distance > 0) {
        CGFloat left = 0.0, right = superPoint.y;
        if ([self relateNextRight:format]) {
            right = nextPoint.x + nextPoint.y;
        }
        else if ([self relateNextLeft:format]) {
            right = nextPoint.x;
        }
        if ([self relatePrevLeft:format]) {
            left = prevPoint.x;
        }
        else if ([self relatePrevRight:format]) {
            left = prevPoint.x + prevPoint.y;
        }
        origin = (left + right) / 2.0 - distance / 2.0;
    }
    else if ([self pressLeftPadding:format] && [self pressRightPadding:format]) {
        origin = superPoint.x + lVal;
        distance = superPoint.y - rVal - lVal;
    }
    else if ([self relateNextLeft:format] && [self relatePrevRight:format]) {
        if ([self relatePrevLeft:format]) {
            origin = prevPoint.x + lVal;
        }
        else {
            origin = prevPoint.x + prevPoint.y + lVal;
        }
        if ([self relateNextRight:format]) {
            distance = nextPoint.x + nextPoint.y - origin - rVal;
        }
        else {
            distance = nextPoint.x - rVal - origin;
        }
    }
    else if ([self relateNextLeft:format] && ![self relatePrevRight:format]) {
        if ([self pressLeft:format]) {
            origin = lVal;
            distance = nextPoint.x - rVal - origin;
        }
        else {
            origin = nextPoint.x - rVal - cVal;
            distance = cVal;
        }
        if ([self relateNextRight:format]) {
            if (rEqual) {
                origin = origin + nextPoint.y;
                distance = distance + nextPoint.y;
                distance = distance - cVal;
            }
            else {
                distance = distance + nextPoint.y;
            }
        }
    }
    else if (![self relateNextLeft:format] && [self relatePrevRight:format]) {
        if ([self pressRight:format]) {
            if ([self relatePrevLeft:format]) {
                origin = prevPoint.x + lVal;
                distance = superPoint.y - rVal - origin;
            }
            else {
                origin = prevPoint.x + prevPoint.y + lVal;
                distance = superPoint.y - rVal - origin;
            }
        }
        else {
            origin = prevPoint.x + lVal;
            distance = cVal;
        }
    }
    return CGPointMake(origin, distance);
}

+ (BOOL)relateNext:(NSString *)formatFrame {
    return [formatFrame containsString:@">"];
}

+ (BOOL)relateNextLeft:(NSString *)formatFrame {
    return [formatFrame hasSuffix:@">"];
}

+ (BOOL)relateNextRight:(NSString *)formatFrame {
    return [formatFrame hasSuffix:@">>"];
}

+ (BOOL)relatePrev:(NSString *)formatFrame {
    return [formatFrame containsString:@"<"];
}

+ (BOOL)relatePrevRight:(NSString *)formatFrame {
    return [formatFrame hasPrefix:@"<"];
}

+ (BOOL)relatePrevLeft:(NSString *)formatFrame {
    return [formatFrame hasPrefix:@"<<"];
}

+ (BOOL)pressRight:(NSString *)formatFrame {
    return [formatFrame containsString:@"-|"];
}

+ (BOOL)pressLeft:(NSString *)formatFrame {
    return [formatFrame containsString:@"|-"];
}

+ (BOOL)pressRightPadding:(NSString *)formatFrame {
    return [formatFrame containsString:@"-!"];
}

+ (BOOL)pressLeftPadding:(NSString *)formatFrame {
    return [formatFrame containsString:@"!-"];
}

+ (CGPoint)superHorizonRect:(UXKView *)view {
    UXKView *superView = (UXKView *)[view superview];
    if ([superView isKindOfClass:[UXKView class]] && superView.formatFrame != nil) {
        CGRect rect = [self rectWithView:superView format:superView.formatFrame];
        return CGPointMake(rect.origin.x, rect.size.width);
    }
    else if ([superView isKindOfClass:[UXKView class]] && superView.willChangeToFrame != nil) {
        CGRect rect = [superView.willChangeToFrame CGRectValue];
        return CGPointMake(rect.origin.x, rect.size.width);
    }
    else {
        return CGPointMake(superView.frame.origin.x, superView.frame.size.width);
    }
}

+ (CGPoint)superVerticalRect:(UXKView *)view {
    UXKView *superView = (UXKView *)[view superview];
    if ([superView isKindOfClass:[UXKView class]] && superView.formatFrame != nil) {
        CGRect rect = [self rectWithView:superView format:superView.formatFrame];
        return CGPointMake(rect.origin.y, rect.size.height);
    }
    else if ([superView isKindOfClass:[UXKView class]] && superView.willChangeToFrame != nil) {
        CGRect rect = [superView.willChangeToFrame CGRectValue];
        return CGPointMake(rect.origin.y, rect.size.height);
    }
    else {
        return CGPointMake(superView.frame.origin.y, superView.frame.size.height);
    }
}

+ (CGPoint)superVerticalPaddingRect:(UXKView *)view {
    UXKView *superView = (UXKView *)[view superview];
    UIViewController *viewController = (id)superView;
    while (viewController != nil) {
        viewController = (id)[viewController nextResponder];
        if ([viewController isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    if (viewController == nil) {
        return CGPointMake(0, superView.frame.size.height);
    }
    return CGPointMake(superView.frame.origin.y + [viewController.topLayoutGuide length],
                       superView.frame.size.height - [viewController.topLayoutGuide length] - [viewController.bottomLayoutGuide length]);
}

+ (CGPoint)prevHorizonRect:(UXKView *)view {
    NSInteger idx = (NSInteger)[[[view superview] subviews] indexOfObject:view];
    if (idx - 1 >= 0) {
        UXKView *previousView = [[view superview] subviews][idx - 1];
        if ([previousView isKindOfClass:[UXKView class]] && previousView.formatFrame != nil) {
            CGRect rect = [self rectWithView:previousView format:previousView.formatFrame];
            return CGPointMake(rect.origin.x, rect.size.width);
        }
        else if ([previousView isKindOfClass:[UXKView class]] && previousView.willChangeToFrame != nil) {
            CGRect rect = [previousView.willChangeToFrame CGRectValue];
            return CGPointMake(rect.origin.x, rect.size.width);
        }
        else {
            return CGPointMake(previousView.frame.origin.x, previousView.frame.size.width);
        }
    }
    return CGPointZero;
}

+ (CGPoint)prevVerticalRect:(UXKView *)view {
    NSInteger idx = (NSInteger)[[[view superview] subviews] indexOfObject:view];
    if (idx - 1 >= 0) {
        UXKView *previousView = [[view superview] subviews][idx - 1];
        if ([previousView isKindOfClass:[UXKView class]] && previousView.formatFrame != nil) {
            CGRect rect = [self rectWithView:previousView format:previousView.formatFrame];
            return CGPointMake(rect.origin.y, rect.size.height);
        }
        else if ([previousView isKindOfClass:[UXKView class]] && previousView.willChangeToFrame != nil) {
            CGRect rect = [previousView.willChangeToFrame CGRectValue];
            return CGPointMake(rect.origin.y, rect.size.height);
        }
        else {
            return CGPointMake(previousView.frame.origin.y, previousView.frame.size.height);
        }
    }
    return CGPointZero;
}

+ (CGPoint)nextHorizonRect:(UXKView *)view {
    NSInteger idx = (NSInteger)[[[view superview] subviews] indexOfObject:view];
    if (idx + 1 < [[[view superview] subviews] count]) {
        UXKView *nextView = [[view superview] subviews][idx + 1];
        if ([nextView isKindOfClass:[UXKView class]] && nextView.formatFrame != nil) {
            CGRect rect = [self rectWithView:nextView format:nextView.formatFrame];
            return CGPointMake(rect.origin.x, rect.size.width);
        }
        else if ([nextView isKindOfClass:[UXKView class]] && nextView.willChangeToFrame != nil) {
            CGRect rect = [nextView.willChangeToFrame CGRectValue];
            return CGPointMake(rect.origin.x, rect.size.width);
        }
        else {
            return CGPointMake(nextView.frame.origin.x, nextView.frame.size.width);
        }
    }
    return CGPointZero;
}

+ (CGPoint)nextVerticalRect:(UXKView *)view {
    NSInteger idx = (NSInteger)[[[view superview] subviews] indexOfObject:view];
    if (idx + 1 < [[[view superview] subviews] count]) {
        UXKView *nextView = [[view superview] subviews][idx + 1];
        if ([nextView isKindOfClass:[UXKView class]] && nextView.formatFrame != nil) {
            CGRect rect = [self rectWithView:nextView format:nextView.formatFrame];
            return CGPointMake(rect.origin.y, rect.size.height);
        }
        else if ([nextView isKindOfClass:[UXKView class]] && nextView.willChangeToFrame != nil) {
            CGRect rect = [nextView.willChangeToFrame CGRectValue];
            return CGPointMake(rect.origin.y, rect.size.height);
        }
        else {
            return CGPointMake(nextView.frame.origin.y, nextView.frame.size.height);
        }
    }
    return CGPointZero;
}

@end
