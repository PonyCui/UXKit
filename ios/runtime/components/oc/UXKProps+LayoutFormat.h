//
//  UXKProps+LayoutFormat.h
//  uxkit
//
//  Created by 崔 明辉 on 16/8/19.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKProps.h"
#import "UXKView.h"

@interface UXKProps (LayoutFormat)

+ (CGRect)rectWithView:(UXKView *)view format:(NSString *)format;

@end
