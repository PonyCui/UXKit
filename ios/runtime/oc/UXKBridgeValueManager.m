//
//  UXKBridgeValueManager.m
//  uxkit
//
//  Created by 崔 明辉 on 16/9/25.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKBridgeValueManager.h"
#import "UXKBridgeController.h"
#import "UXKBridgeViewUpdater.h"
#import "UXKBridgeCallbackHandler.h"
#import "UXKView.h"

@implementation UXKBridgeValueManager

+ (NSString *)bridgeScript {
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UXKValue" ofType:@"js"]
                                     encoding:NSUTF8StringEncoding
                                        error:nil];
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([[message body] isKindOfClass:[NSString class]]) {
        NSString *argsString = [message body];
        NSData *argsData = [argsString dataUsingEncoding:NSUTF8StringEncoding];
        if (argsData == nil) {
            return;
        }
        NSDictionary *args = [NSJSONSerialization JSONObjectWithData:argsData
                                                             options:kNilOptions
                                                               error:nil];
        if ([args isKindOfClass:[NSDictionary class]]) {
            NSString *vKey = args[@"vKey"];
            NSString *rKey = args[@"rKey"];
            BOOL listen = [args[@"listen"] isKindOfClass:[NSNumber class]] ? [args[@"listen"] boolValue] : NO;
            NSString *callbackID = args[@"callbackID"];
            if ([vKey isKindOfClass:[NSString class]] &&
                [rKey isKindOfClass:[NSString class]] &&
                [callbackID isKindOfClass:[NSString class]]) {
                UXKView *view = self.bridgeController.viewUpdater.mirrorViews[vKey];
                if (view != nil && [view isKindOfClass:[UXKView class]]) {
                    if (listen) {
                        [view listenValueWithKey:rKey valueBlock:^(id value) {
                            if (value == nil) {
                                value = [NSNull null];
                            }
                            [self.bridgeController.callbackHandler callback:callbackID args:@[value]];
                        }];
                    }
                    else {
                        [view requestValueWithKey:rKey valueBlock:^(id value) {
                            if (value == nil) {
                                value = [NSNull null];
                            }
                            [self.bridgeController.callbackHandler callback:callbackID args:@[value]];
                        }];
                    }
                }
            }
        }
    }
}

@end
