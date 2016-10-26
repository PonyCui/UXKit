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

/**
 Set Debug Mode on enable safari developer tool.

 @param isOn defaults to NO.
 */
+ (void)setDebugMode:(BOOL)isOn;

/**
 Add Specific class with node.

 @param clz      UXKView class
 @param nodeName DOM Node name
 */
+ (void)addClass:(Class)clz nodeName:(NSString *)nodeName;

/**
 Private, request class with node name.

 @param nodeName DOM Node name

 @return UXKView class
 */
+ (Class)classWithNodeName:(NSString *)nodeName;

/**
 Init a bridge to view. The view will seen as BODY.

 @param view UIView instance

 @return UXKBridge instance.
 */
- (instancetype)initWithView:(UIView *)view;

/**
 load a HTML URLRequest.

 @param request Request
 */
- (void)loadRequest:(NSURLRequest *)request;

/**
 load a HTML with String

 @param HTMLString Pure Text.
 @param baseURL    Base URL.
 */
- (void)loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL;

@end
