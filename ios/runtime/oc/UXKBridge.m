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
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation UXKBridge

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [[UXKBridgeController alloc] initWithView:view];
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _view = view;
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
