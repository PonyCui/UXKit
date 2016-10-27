//
//  UXKView.h
//  uxkit
//
//  Created by 崔 明辉 on 16/8/14.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UXKBridgeAnimationHandler, UXKBridgeController;

typedef void(^UXKViewValueBlock)(id value);
typedef void(^UXKViewTouchBlock)(NSString *eventType);

@interface UXKView : UIView

@property (nonatomic, weak) UXKBridgeController *bridgeController;
@property (nonatomic, weak) UXKBridgeAnimationHandler *animationHandler;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDictionary *props;
@property (nonatomic, strong) NSString *layoutCallbackID;
@property (nonatomic, strong) NSString *vKey;
@property (nonatomic, copy) NSString *formatFrame;
@property (nonatomic, strong) NSValue *shouldChangeToFrame;
@property (nonatomic, strong) NSValue *willChangeToFrame;
@property (nonatomic, copy) UXKViewTouchBlock touchCallback;

- (BOOL)staticLayouts;
- (void)setProps:(NSDictionary *)props updatePropsOnly:(BOOL)updatePropsOnly;
- (void)requestValueWithKey:(NSString *)aKey valueBlock:(UXKViewValueBlock)valueBlock;
- (void)listenValueWithKey:(NSString *)aKey valueBlock:(UXKViewValueBlock)valueBlock;
- (CGSize)intrinsicContentSizeWithProps:(NSDictionary *)props;

@end
