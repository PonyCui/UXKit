//
//  UXKBridgeController.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/13.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKBridgeController.h"
#import "UXKBridgeViewUpdater.h"
#import "UXKBridgeAnimationHandler.h"

@interface UXKBridgeController()

@property (nonatomic, strong) UXKBridgeViewUpdater *viewUpdater;
@property (nonatomic, strong) UXKBridgeAnimationHandler *animationHandler;
@property (nonatomic, strong) UIView *view;

@end

@implementation UXKBridgeController

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        _view = view;
        [self configure];
    }
    return self;
}

- (void)configure {
    [self configureViewUpdater];
    [self configureAnimationHandler];
    [self configureTasks];
}

- (void)configureViewUpdater {
    [self addUserScript:[[WKUserScript alloc] initWithSource:[UXKBridgeViewUpdater bridgeScript]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                            forMainFrameOnly:YES]];
    self.viewUpdater = [[UXKBridgeViewUpdater alloc] initWithView:self.view];
    self.viewUpdater.bridgeController = self;
    [self addScriptMessageHandler:self.viewUpdater
                             name:@"UXK_ViewUpdater"];
}

- (void)configureAnimationHandler {
    [self addUserScript:[[WKUserScript alloc] initWithSource:[UXKBridgeAnimationHandler bridgeScript]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                            forMainFrameOnly:YES]];
    self.animationHandler = [[UXKBridgeAnimationHandler alloc] initWithView:self.view];
    self.animationHandler.bridgeController = self;
    [self addScriptMessageHandler:self.animationHandler name:@"UXK_AnimationHandler_Commit"];
    [self addScriptMessageHandler:self.animationHandler name:@"UXK_AnimationHandler_Enable"];
    [self addScriptMessageHandler:self.animationHandler name:@"UXK_AnimationHandler_Disable"];
}

- (void)configureTasks {
    [self addUserScript:[[WKUserScript alloc] initWithSource:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UXKTasks" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES]];
}

@end
