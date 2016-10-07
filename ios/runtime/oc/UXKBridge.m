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

@interface UXKBridge ()<WKNavigationDelegate>

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
        _webView.navigationDelegate = self;
        [(UXKBridgeController *)_webView.configuration.userContentController setWebView:_webView];
        _view = view;
        if (debugMode) {
            [[view superview] addSubview:self.webView];
            self.webView.alpha = 0.0;
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

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    UIViewController *responder = (id)self.view;
    while (responder != nil) {
        responder = (id)[responder nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    [responder setTitle:webView.title];
}

@end
