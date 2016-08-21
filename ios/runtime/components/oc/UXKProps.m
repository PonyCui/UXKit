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
    rectString = [rectString stringByReplacingOccurrencesOfString:@" " withString:@""];
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
