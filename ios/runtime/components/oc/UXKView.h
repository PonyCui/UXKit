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

@property (nonatomic, strong) NSString *name;
@property (nonatomic, weak) UXKBridgeAnimationHandler *animationHandler;
@property (nonatomic, copy) NSString *formatFrame;
@property (nonatomic, strong) NSValue *willChangeToFrame;

- (BOOL)staticLayouts;
- (void)setProps:(NSDictionary *)props;

@end
