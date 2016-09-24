//
//  UXKBridge.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/13.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "UXKBridge.h"
#import "UXKBridgeController.h"

@interface UXKBridge ()

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) WKWebViewConfiguration *configureation;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation UXKBridge

static BOOL debugMode;

+ (void)setDebugMode:(BOOL)isOn {
    debugMode = isOn;
}

+ (WKWebViewConfiguration *)configurationWithView:(UIView *)view {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [[UXKBridgeController alloc] initWithView:view];
    return configuration;
}

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[UXKBridge configurationWithView:view]];
        [(UXKBridgeController *)_webView.configuration.userContentController setWebView:_webView];
        _view = view;
        if (debugMode) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[[UIApplication sharedApplication] keyWindow] addSubview:self.webView];
            });
        }
    }
    return self;
}

- (void)loadRequest:(NSURLRequest *)request {
    [self.webView loadRequest:request];
}

- (void)loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL {
    [self.webView loadHTMLString:HTMLString baseURL:baseURL];
}

@end
