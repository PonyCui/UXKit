//
//  UXKBridgeAnimationHandler.h
//  uxkit
//
//  Created by 崔 明辉 on 16/8/17.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class UXKBridgeController;

@interface UXKBridgeAnimationHandler : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) UXKBridgeController *bridgeController;

@property (nonatomic, readonly) BOOL animationEnabled;
@property (nonatomic, readonly) NSDictionary *animationParams;
@property (nonatomic, readonly) UIView *view;

+ (NSString *)bridgeScript;

- (instancetype)initWithView:(UIView *)view;

- (BOOL)addAnimationWithView:(UIView *)view;

@end
