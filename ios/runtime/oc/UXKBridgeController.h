//
//  UXKBridgeController.h
//  uxkit
//
//  Created by 崔 明辉 on 16/8/13.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class UXKBridgeViewUpdater, UXKBridgeTouchUpdater, UXKBridgeAnimationHandler;

@interface UXKBridgeController : WKUserContentController

@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, readonly) UXKBridgeViewUpdater *viewUpdater;
@property (nonatomic, readonly) UXKBridgeTouchUpdater *touchUpdater;
@property (nonatomic, readonly) UXKBridgeAnimationHandler *animationHandler;

- (instancetype)initWithView:(UIView *)view;

@end
