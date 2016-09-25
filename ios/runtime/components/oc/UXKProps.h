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

+ (BOOL)toBool:(NSString *)stringValue;
+ (CGFloat)toCGFloat:(NSString *)stringValue;
+ (CGSize)toMaxSize:(NSString *)stringValue;
+ (CGRect)toRectWithRect:(NSString *)rectString;
+ (UIColor *)toColor:(NSString *)stringValue;
+ (UIFont *)toFont:(NSString *)stringValue;
+ (UIReturnKeyType)toReturnKeyType:(NSString *)stringValue;

@end
