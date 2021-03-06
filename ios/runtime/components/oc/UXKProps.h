//
//  UXKProps.h
//  uxkit
//
//  Created by 崔 明辉 on 16/8/16.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UXKProps : NSObject

+ (CGAffineTransform)toTransform:(NSString *)stringValue;
+ (BOOL)toBool:(NSString *)stringValue;
+ (CGFloat)toCGFloat:(NSString *)stringValue;
+ (CGPoint)toCGPoint:(NSString *)stringValue;
+ (CGSize)toCGSize:(NSString *)stringValue;
+ (CGSize)toMaxSize:(NSString *)stringValue;
+ (CGRect)toRectWithRect:(NSString *)rectString;
+ (NSString *)stringWithRect:(CGRect)rect;
+ (UIColor *)toColor:(NSString *)stringValue;
+ (UIFont *)toFont:(NSString *)stringValue;
+ (UIReturnKeyType)toReturnKeyType:(NSString *)stringValue;
+ (UITextFieldViewMode)toTextFieldViewMode:(NSString *)stringValue;
+ (UIKeyboardType)toKeyboardType:(NSString *)stringValue;
+ (NSTextAlignment)toTextAlignment:(NSString *)stringValue;

@end
