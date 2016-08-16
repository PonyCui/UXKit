//
//  UXKProps.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/16.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKProps.h"

@implementation UXKProps

+ (BOOL)toBool:(NSString *)stringValue {
    if ([stringValue isEqualToString:@"true"]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (CGFloat)toCGFloat:(NSString *)stringValue {
    return (CGFloat)[stringValue floatValue];
}

+ (CGRect)toRectWithRect:(NSString *)rectString {
    NSArray *components = [rectString componentsSeparatedByString:@","];
    if ([components count] == 4) {
        return CGRectMake([components[0] floatValue],
                          [components[1] floatValue],
                          [components[2] floatValue],
                          [components[3] floatValue]);
    }
    else {
        return CGRectZero;
    }
}

+ (CGRect)toRectWithFormat:(NSString *)formatString
                   forView:(UIView *)view
              previousView:(UIView *)previousView
                  nextView:(UIView *)nextView {
    static NSRegularExpression *leftExp;
    static NSRegularExpression *widthExp;
    static NSRegularExpression *rightExp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        leftExp = [NSRegularExpression regularExpressionWithPattern:@"([<\\|])-([@\\-0-9]+)-"
                                                            options:kNilOptions
                                                              error:nil];
        widthExp = [NSRegularExpression regularExpressionWithPattern:@"\\[([0-9]+)\\]"
                                                             options:kNilOptions
                                                               error:nil];
        rightExp = [NSRegularExpression regularExpressionWithPattern:@"-([@\\-0-9]+)-\\|"
                                                             options:kNilOptions
                                                               error:nil];
    });
    CGRect superBounds = [[view superview] bounds];
    NSArray *components = [formatString componentsSeparatedByString:@","];
    if ([components count] == 2) {
        CGFloat x = 0.0, y = 0.0, width = 0.0, height = 0.0;
        {
            BOOL cl = NO, cr = NO, relatePrev = NO;
            {
                NSArray<NSTextCheckingResult *> *results = [leftExp matchesInString:components[0]
                                                                            options:NSMatchingReportCompletion
                                                                              range:NSMakeRange(0, [components[0] length])];
                if ([results firstObject] != nil && 2 < [[results firstObject] numberOfRanges]) {
                    NSString *lSymbol = [components[0] substringWithRange:[[results firstObject] rangeAtIndex:1]];
                    NSString *val = [components[0] substringWithRange:[[results firstObject] rangeAtIndex:2]];
                    if ([lSymbol isEqualToString:@"<"]) {
                        relatePrev = YES;
                    }
                    if ([val isEqualToString:@"@"]) {
                        cl = YES;
                    }
                    else {
                        x = [val floatValue];
                    }
                }
            }
            {
                NSArray<NSTextCheckingResult *> *results = [widthExp matchesInString:components[0]
                                                                             options:NSMatchingReportCompletion
                                                                               range:NSMakeRange(0, [components[0] length])];
                if ([results firstObject] != nil && 1 < [[results firstObject] numberOfRanges]) {
                    width = [[components[0] substringWithRange:[[results firstObject] rangeAtIndex:1]] floatValue];
                }
            }
            {
                NSArray<NSTextCheckingResult *> *results = [rightExp matchesInString:components[0]
                                                                             options:NSMatchingReportCompletion
                                                                               range:NSMakeRange(0, [components[0] length])];
                if ([results firstObject] != nil && 1 < [[results firstObject] numberOfRanges]) {
                    NSString *val = [components[0] substringWithRange:[[results firstObject] rangeAtIndex:1]];
                    if ([val isEqualToString:@"@"]) {
                        cr = YES;
                    }
                    else {
                        if (width > 0.0) {
                            x = superBounds.size.width - [val floatValue] - width;
                        }
                        else {
                            width = superBounds.size.width - [val floatValue] - x;
                        }
                    }
                }
            }
            if (cl && cr && width > 0) {
                x = (superBounds.size.width - width) / 2.0;
            }
        }
        {
            BOOL cl = NO, cr = NO, relatePrev = NO;
            {
                NSArray<NSTextCheckingResult *> *results = [leftExp matchesInString:components[1]
                                                                            options:NSMatchingReportCompletion
                                                                              range:NSMakeRange(0, [components[1] length])];
                if ([results firstObject] != nil && 2 < [[results firstObject] numberOfRanges]) {
                    NSString *lSymbol = [components[0] substringWithRange:[[results firstObject] rangeAtIndex:1]];
                    NSString *val = [components[1] substringWithRange:[[results firstObject] rangeAtIndex:2]];
                    if ([lSymbol isEqualToString:@"<"]) {
                        relatePrev = YES;
                    }
                    if ([val isEqualToString:@"@"]) {
                        cl = YES;
                    }
                    else {
                        y = [[components[1] substringWithRange:[[results firstObject] rangeAtIndex:1]] floatValue];
                    }
                }
            }
            {
                NSArray<NSTextCheckingResult *> *results = [widthExp matchesInString:components[1]
                                                                             options:NSMatchingReportCompletion
                                                                               range:NSMakeRange(0, [components[1] length])];
                if ([results firstObject] != nil && 1 < [[results firstObject] numberOfRanges]) {
                    height = [[components[1] substringWithRange:[[results firstObject] rangeAtIndex:1]] floatValue];
                }
            }
            {
                NSArray<NSTextCheckingResult *> *results = [rightExp matchesInString:components[1]
                                                                             options:NSMatchingReportCompletion
                                                                               range:NSMakeRange(0, [components[1] length])];
                if ([results firstObject] != nil && 1 < [[results firstObject] numberOfRanges]) {
                    NSString *val = [components[1] substringWithRange:[[results firstObject] rangeAtIndex:1]];
                    if ([val isEqualToString:@"@"]) {
                        cr = YES;
                    }
                    else {
                        if (height > 0.0) {
                            y = superBounds.size.height - [[components[1] substringWithRange:[[results firstObject] rangeAtIndex:1]] floatValue] - height;
                        }
                        else {
                            height = superBounds.size.height - [[components[1] substringWithRange:[[results firstObject] rangeAtIndex:1]] floatValue] - y;
                        }
                    }
                }
            }
            if (cl && cr && height > 0) {
                y = (superBounds.size.height - height) / 2.0;
            }
        }
        return CGRectMake(x, y, width, height);
    }
    else {
        return CGRectZero;
    }
}

+ (UIColor *)toColor:(NSString *)stringValue {
    NSString *colorHex = [stringValue stringByReplacingOccurrencesOfString:@"#" withString:@""];
    colorHex = [colorHex uppercaseString];
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    switch ([colorHex length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorHex start: 0 length: 1];
            green = [self colorComponentFrom:colorHex start: 1 length: 1];
            blue  = [self colorComponentFrom:colorHex start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorHex start: 0 length: 1];
            red   = [self colorComponentFrom:colorHex start: 1 length: 1];
            green = [self colorComponentFrom:colorHex start: 2 length: 1];
            blue  = [self colorComponentFrom:colorHex start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorHex start: 0 length: 2];
            green = [self colorComponentFrom:colorHex start: 2 length: 2];
            blue  = [self colorComponentFrom:colorHex start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorHex start: 0 length: 2];
            red   = [self colorComponentFrom:colorHex start: 2 length: 2];
            green = [self colorComponentFrom:colorHex start: 4 length: 2];
            blue  = [self colorComponentFrom:colorHex start: 6 length: 2];
            break;
        default:
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end
