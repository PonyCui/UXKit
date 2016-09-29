//
//  UIViewController+UXKBridge.h
//  uxkit
//
//  Created by 崔 明辉 on 16/9/26.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UXKBridge.h"

@interface UIViewController (UXKBridge)

@property (nonatomic, strong) UXKBridge *uxk_bridge;
@property (nonatomic, strong) UIView *uxk_bodyView;

- (void)uxk_setup;
- (void)uxk_loadURLString:(NSString *)URLString;
- (void)uxk_loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL;

@end
