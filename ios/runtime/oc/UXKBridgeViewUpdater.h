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

@class UXKBridgeController;

@interface UXKBridgeViewUpdater : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) UXKBridgeController *bridgeController;
@property (nonatomic, readonly) NSMutableDictionary *mirrorViews;

+ (NSString *)bridgeScript;

+ (void)createTagWithName:(NSString *)tagName viewClass:(Class)viewClass;

- (instancetype)initWithView:(UIView *)view;

@end
