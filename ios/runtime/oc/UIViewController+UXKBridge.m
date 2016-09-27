//
//  UIViewController+UXKBridge.m
//  uxkit
//
//  Created by 崔 明辉 on 16/9/26.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UIViewController+UXKBridge.h"
#import <objc/runtime.h>

@implementation UIViewController (UXKBridge)

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
        bridge = [[UXKBridge alloc] initWithView:self.view];
        [self setUxk_bridge:bridge];
    }
    return bridge;
}

- (void)setUxk_bridge:(UXKBridge *)uxk_bridge {
    objc_setAssociatedObject(self, &kUXKBridgeIdentifier, uxk_bridge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
