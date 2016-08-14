//
//  UXKBridge.h
//  uxkit
//
//  Created by 崔 明辉 on 16/8/13.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UXKBridge : NSObject

- (instancetype)initWithView:(UIView *)view;

- (void)loadRequest:(NSURLRequest *)request;

- (void)loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL;

@end
