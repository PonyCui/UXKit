//
//  UXKView.h
//  uxkit
//
//  Created by 崔 明辉 on 16/8/14.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UXKBridgeAnimationHandler;

@interface UXKView : UIView

@property (nonatomic, weak) UXKBridgeAnimationHandler *animationHandler;
@property (nonatomic, copy) NSString *formatFrame;

- (void)setProps:(NSDictionary *)props;

@end