//
//  UXKBridgeCallbackHandler.h
//  uxkit
//
//  Created by 崔 明辉 on 16/10/30.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UXKBridgeController;

@interface UXKBridgeCallbackHandler : NSObject

@property (nonatomic, weak) UXKBridgeController *bridgeController;

- (void)callback:(NSString *)callbackID args:(NSArray *)args;

@end
