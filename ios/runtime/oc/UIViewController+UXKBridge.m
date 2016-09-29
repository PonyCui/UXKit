//
//  UIViewController+UXKBridge.m
//  uxkit
//
//  Created by 崔 明辉 on 16/9/26.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UIViewController+UXKBridge.h"
#import "UXKView.h"
#import <objc/runtime.h>

@implementation UIViewController (UXKBridge)

- (void)uxk_setup {
    [self.view addSubview:self.uxk_bodyView];
    self.uxk_bodyView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bodyView]-0-|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:@{
                                                                                @"bodyView": self.uxk_bodyView,
                                                                                }]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[bodyView]-0-|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:@{
                                                                                @"bodyView": self.uxk_bodyView,
                                                                                }]];
}

- (void)uxk_loadURLString:(NSString *)URLString {
    [self.uxk_bridge loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
}

- (void)uxk_loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL {
    [self.uxk_bridge loadHTMLString:HTMLString baseURL:baseURL];
}

static int kUXKBridgeIdentifier;

- (UXKBridge *)uxk_bridge {
    UXKBridge *bridge = objc_getAssociatedObject(self, &kUXKBridgeIdentifier);
    if (bridge == nil) {
        bridge = [[UXKBridge alloc] initWithView:self.uxk_bodyView];
        [self setUxk_bridge:bridge];
    }
    return bridge;
}

- (void)setUxk_bridge:(UXKBridge *)uxk_bridge {
    objc_setAssociatedObject(self, &kUXKBridgeIdentifier, uxk_bridge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static int kUXKBodyViewIdentifier;

- (UIView *)uxk_bodyView {
    UIView *view = objc_getAssociatedObject(self, &kUXKBodyViewIdentifier);
    if (view == nil) {
        view = [[UXKView alloc] initWithFrame:CGRectZero];
        [self setUxk_bodyView:view];
    }
    return view;
}

- (void)setUxk_bodyView:(UIView *)uxk_bodyView {
    objc_setAssociatedObject(self, &kUXKBodyViewIdentifier, uxk_bodyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
