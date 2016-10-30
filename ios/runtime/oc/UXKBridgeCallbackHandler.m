//
//  UXKBridgeCallbackHandler.m
//  uxkit
//
//  Created by 崔 明辉 on 16/10/30.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKBridgeCallbackHandler.h"
#import "UXKBridgeController.h"

@implementation UXKBridgeCallbackHandler

- (void)callback:(NSString *)callbackID args:(NSArray *)args {
    NSMutableArray *argParams = [NSMutableArray array];
    [args enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *charEncoded = [obj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *base64Encoded = [[charEncoded dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:kNilOptions];
            [argParams addObject:[NSString stringWithFormat:@"decodeURIComponent(atob('%@'))", base64Encoded]];
        }
        else if ([obj isKindOfClass:[NSNumber class]]) {
            [argParams addObject:[NSString stringWithFormat:@"%f", [obj floatValue]]];
        }
        else if ([obj isKindOfClass:[NSArray class]]) {
            NSData *JSONData = [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:NULL];
            NSString *base64Encoded = [JSONData base64EncodedStringWithOptions:kNilOptions];
            [argParams addObject:[NSString stringWithFormat:@"JSON.parse(decodeURIComponent(atob('%@')))", base64Encoded]];
        }
        else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSData *JSONData = [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:NULL];
            NSString *base64Encoded = [JSONData base64EncodedStringWithOptions:kNilOptions];
            [argParams addObject:[NSString stringWithFormat:@"JSON.parse(decodeURIComponent(atob('%@')))", base64Encoded]];
        }
    }];
    NSString *script;
    if (argParams.count == 0) {
        script = [NSString stringWithFormat:@"window.ux.callbacks['%@'].call(this)", callbackID];
    }
    else {
        script = [NSString stringWithFormat:@"window.ux.callbacks['%@'].call(this, %@)", callbackID, [argParams componentsJoinedByString:@","]];
    }
    [self.bridgeController.webView evaluateJavaScript:script completionHandler:nil];
}

@end
