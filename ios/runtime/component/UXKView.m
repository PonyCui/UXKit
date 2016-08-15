//
//  UXKView.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/14.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKView.h"

@implementation UXKView

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

+ (CGRect)toRect:(NSString *)stringValue {
    NSArray *components = [stringValue componentsSeparatedByString:@","];
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

+ (CGRect)toRect:(NSString *)layoutFrame forView:(UIView *)view {
    static NSRegularExpression *leftExp;
    static NSRegularExpression *widthExp;
    static NSRegularExpression *rightExp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        leftExp = [NSRegularExpression regularExpressionWithPattern:@"\\|-([0-9]+)-"
                                                            options:kNilOptions
                                                              error:nil];
        widthExp = [NSRegularExpression regularExpressionWithPattern:@"\\[([0-9]+)\\]"
                                                             options:kNilOptions
                                                               error:nil];
        rightExp = [NSRegularExpression regularExpressionWithPattern:@"-([0-9]+)-\\|"
                                                             options:kNilOptions
                                                               error:nil];
    });
    CGRect superBounds = [[view superview] bounds];
    NSArray *components = [layoutFrame componentsSeparatedByString:@","];
    if ([components count] == 2) {
        CGFloat x = 0.0, y = 0.0, width = 0.0, height = 0.0;
        {
            {
                NSArray<NSTextCheckingResult *> *results = [leftExp matchesInString:components[0]
                                                                            options:NSMatchingReportCompletion
                                                                              range:NSMakeRange(0, [components[0] length])];
                if ([results firstObject] != nil && 1 < [[results firstObject] numberOfRanges]) {
                    x = [[components[0] substringWithRange:[[results firstObject] rangeAtIndex:1]] floatValue];
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
                    if (width > 0.0) {
                        x = superBounds.size.width - [[components[0] substringWithRange:[[results firstObject] rangeAtIndex:1]] floatValue] - width;
                    }
                    else {
                        width = superBounds.size.width - [[components[0] substringWithRange:[[results firstObject] rangeAtIndex:1]] floatValue] - x;
                    }
                }
            }
        }
        {
            {
                NSArray<NSTextCheckingResult *> *results = [leftExp matchesInString:components[1]
                                                                            options:NSMatchingReportCompletion
                                                                              range:NSMakeRange(0, [components[1] length])];
                if ([results firstObject] != nil && 1 < [[results firstObject] numberOfRanges]) {
                    y = [[components[1] substringWithRange:[[results firstObject] rangeAtIndex:1]] floatValue];
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
                    if (height > 0.0) {
                        y = superBounds.size.height - [[components[1] substringWithRange:[[results firstObject] rangeAtIndex:1]] floatValue] - height;
                    }
                    else {
                        height = superBounds.size.height - [[components[1] substringWithRange:[[results firstObject] rangeAtIndex:1]] floatValue] - y;
                    }
                }
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

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.layoutFrame != nil) {
        self.frame = [UXKView toRect:self.layoutFrame forView:self];
        for (UIView *subview in self.subviews) {
            [subview layoutSubviews];
        }
    }
}

@end

@implementation UIView (UXKProps)

- (void)uxk_setProps:(NSDictionary *)props {
    if (props[@"frame"] && [props[@"frame"] isKindOfClass:[NSString class]]) {
        if ([(NSString *)props[@"frame"] containsString:@"["]) {
            if ([self isKindOfClass:[UXKView class]]) {
                [(UXKView *)self setLayoutFrame:props[@"frame"]];
            }
        }
        else {
            self.frame = [UXKView toRect:props[@"frame"]];
        }
    }
    if (props[@"userInteractionEnabled"] && [props[@"userInteractionEnabled"] isKindOfClass:[NSString class]]) {
        self.userInteractionEnabled = [UXKView toBool:props[@"userInteractionEnabled"]];
    }
    if (props[@"clipsToBounds"] && [props[@"clipsToBounds"] isKindOfClass:[NSString class]]) {
        self.clipsToBounds = [UXKView toBool:props[@"clipsToBounds"]];
    }
    if (props[@"backgroundColor"] && [props[@"backgroundColor"] isKindOfClass:[NSString class]]) {
        self.backgroundColor = [UXKView toColor:props[@"backgroundColor"]];
    }
    if (props[@"alpha"] && [props[@"alpha"] isKindOfClass:[NSString class]]) {
        self.alpha = [UXKView toCGFloat:props[@"alpha"]];
    }
    if (props[@"hidden"] && [props[@"hidden"] isKindOfClass:[NSString class]]) {
        self.hidden = [UXKView toBool:props[@"hidden"]];
    }
}

@end
