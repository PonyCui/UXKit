//
//  UXKRouter.h
//  uxkit
//
//  Created by 崔 明辉 on 2016/9/29.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WebKit;

@interface UXKRouter : NSObject<WKScriptMessageHandler>

+ (NSString *)bridgeScript;

- (instancetype)initWithView:(UIView *)view;

- (void)showNextWithURLString:(NSString *)URLString
         sourceViewController:(UIViewController *)sourceViewController;

- (void)showNextWithHTMLString:(NSString *)HTMLString
                       baseURL:(NSURL *)baseURL
          sourceViewController:(UIViewController *)sourceViewController;

@end
