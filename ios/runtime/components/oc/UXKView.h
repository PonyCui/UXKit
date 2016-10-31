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

#pragma mark - Public 

/**
 Current Props
 */
@property (nonatomic, strong) NSDictionary *props;

/**
 Callback on Touch.
 */
@property (nonatomic, copy) UXKViewTouchBlock touchCallback;

/**
 Callback on Layout
 */
@property (nonatomic, strong) NSString *layoutCallbackID;


/**
 Return YES to AVOID cleanning subviews.
 */
- (BOOL)staticLayouts;

/**
 Props will deliver to here.

 @param props           NSDictionary
 @param updatePropsOnly Bool
 */
- (void)setProps:(NSDictionary *)props updatePropsOnly:(BOOL)updatePropsOnly;

/**
 Request a value, and callback immediately.

 @param aKey       Value Key
 @param valueBlock Value Callback Block
 */
- (void)requestValueWithKey:(NSString *)aKey valueBlock:(UXKViewValueBlock)valueBlock;

/**
 Listen a value change.

 @param aKey       Value Key
 @param valueBlock Value Callback Block
 */
- (void)listenValueWithKey:(NSString *)aKey valueBlock:(UXKViewValueBlock)valueBlock;

/**
 Return intrinsicContentSize to satisfy dynamic frame.

 @param props Current View Props.

 @return CGSize.
 */
- (CGSize)intrinsicContentSizeWithProps:(NSDictionary *)props;

#pragma mark - Private

/**
 Private
 */
@property (nonatomic, weak) UXKBridgeController *bridgeController;

/**
 Private
 */
@property (nonatomic, weak) UXKBridgeAnimationHandler *animationHandler;

/**
 Private
 */
@property (nonatomic, strong) NSString *visualDOMKey;

/**
 Private
 */
@property (nonatomic, copy) NSString *formatFrame;

/**
 Private
 */
@property (nonatomic, strong) NSValue *shouldChangeToFrame;

/**
 Private
 */
@property (nonatomic, strong) NSValue *willChangeToFrame;

/**
 Private
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSValue *> *formatFrameCache;

- (NSString *)requestFormatFrameCacheKey;

@end
