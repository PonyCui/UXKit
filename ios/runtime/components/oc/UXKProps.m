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

+ (CGSize)toMaxSize:(NSString *)stringValue {
    NSString *rectString = [stringValue stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *components = [rectString componentsSeparatedByString:@","];
    if ([components count] == 2) {
        NSString *hString = components[0];
        NSString *vString = components[1];
        NSRange widthRange = [hString rangeOfString:@"[0-9]+" options:NSRegularExpressionSearch];
        NSRange heightRange = [vString rangeOfString:@"[0-9]+" options:NSRegularExpressionSearch];
        return CGSizeMake(widthRange.location != NSNotFound ? [[hString substringWithRange:widthRange] floatValue] : CGFLOAT_MAX,
                          heightRange.location != NSNotFound ? [[vString substringWithRange:heightRange] floatValue] : CGFLOAT_MAX);
    }
    else if ([components count] == 4) {
        return CGSizeMake([components[2] isEqualToString:@"*"] ? CGFLOAT_MAX : [components[2] floatValue],
                          [components[3] isEqualToString:@"*"] ? CGFLOAT_MAX : [components[3] floatValue]);
    }
    else {
        return CGSizeMake(0, 0);
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

+ (UIFont *)toFont:(NSString *)stringValue {
    BOOL isBold = NO;
    BOOL isItalic = NO;
    CGFloat fontSize = 14.0;
    if ([stringValue rangeOfString:@"bold"].location != NSNotFound) {
        isBold = YES;
    }
    if ([stringValue rangeOfString:@"italic"].location != NSNotFound) {
        isItalic = YES;
    }
    {
        static NSRegularExpression *expression;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            expression = [[NSRegularExpression alloc] initWithPattern:@"[0-9]+"
                                                              options:kNilOptions
                                                                error:NULL];
        });
        NSRange intRange = [expression rangeOfFirstMatchInString:stringValue options:NSMatchingReportCompletion range:NSMakeRange(0, stringValue.length)];
        if (intRange.location != NSNotFound) {
            NSString *intString = [stringValue substringWithRange:intRange];
            fontSize = [intString floatValue];
        }
    }
    if (isBold) {
        return [UIFont boldSystemFontOfSize:fontSize];
    }
    else if (isItalic) {
        return [UIFont italicSystemFontOfSize:fontSize];
    }
    else {
        return [UIFont systemFontOfSize:fontSize];
    }
}

+ (UIReturnKeyType)toReturnKeyType:(NSString *)stringValue {
    if ([stringValue isEqualToString:@"Go"]) {
        return UIReturnKeyGo;
    }
    else if ([stringValue isEqualToString:@"Next"]) {
        return UIReturnKeyNext;
    }
    else if ([stringValue isEqualToString:@"Search"]) {
        return UIReturnKeySearch;
    }
    else if ([stringValue isEqualToString:@"Send"]) {
        return UIReturnKeySend;
    }
    else if ([stringValue isEqualToString:@"Done"]) {
        return UIReturnKeyDone;
    }
    return UIReturnKeyDefault;
}

+ (UITextFieldViewMode)toTextFieldViewMode:(NSString *)stringValue {
    if ([stringValue isEqualToString:@"Always"]) {
        return UITextFieldViewModeAlways;
    }
    else if ([stringValue isEqualToString:@"UnlessEditing"]) {
        return UITextFieldViewModeUnlessEditing;
    }
    else if ([stringValue isEqualToString:@"WhileEditing"]) {
        return UITextFieldViewModeWhileEditing;
    }
    return UITextFieldViewModeNever;
}

+ (UIKeyboardType)toKeyboardType:(NSString *)stringValue {
    if ([stringValue isEqualToString:@"number"]) {
        return UIKeyboardTypeNumberPad;
    }
    else if ([stringValue isEqualToString:@"phone"]) {
        return UIKeyboardTypePhonePad;
    }
    else if ([stringValue isEqualToString:@"ASCII"]) {
        return UIKeyboardTypeASCIICapable;
    }
    else if ([stringValue isEqualToString:@"email"]) {
        return UIKeyboardTypeEmailAddress;
    }
    else if ([stringValue isEqualToString:@"URL"]) {
        return UIKeyboardTypeURL;
    }
    return UIKeyboardTypeDefault;
}

@end
