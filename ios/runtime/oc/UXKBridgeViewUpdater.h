//
//  UXKBridgeViewUpdater.h
//  uxkit
//
//  Created by 崔 明辉 on 16/8/13.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface UXKBridgeViewUpdater : NSObject<WKScriptMessageHandler>

+ (NSString *)bridgeScript;

- (instancetype)initWithView:(UIView *)view;

@end
