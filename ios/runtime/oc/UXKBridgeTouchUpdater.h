//
//  UXKBridgeTouchUpdater.h
//  uxkit
//
//  Created by 崔 明辉 on 16/9/24.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class UXKBridgeController;

@interface UXKBridgeTouchUpdater : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) UXKBridgeController *bridgeController;

+ (NSString *)bridgeScript;

@end
