//
//  UXKView.h
//  uxkit
//
//  Created by 崔 明辉 on 16/8/14.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UXKView : UIView

@property (nonatomic, copy) NSString *layoutFrame;

+ (BOOL)toBool:(NSString *)stringValue;
+ (CGFloat)toCGFloat:(NSString *)stringValue;
+ (CGRect)toRect:(NSString *)stringValue;
+ (UIColor *)toColor:(NSString *)stringValue;

@end

@interface UIView (UXKProps)

- (void)uxk_setProps:(NSDictionary *)props;

@end
