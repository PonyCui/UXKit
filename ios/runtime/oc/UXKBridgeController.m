//
//  UXKBridgeController.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/13.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKBridgeController.h"
#import "UXKBridgeViewUpdater.h"

@interface UXKBridgeController()

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
    [self configureTasks];
}

- (void)configureViewUpdater {
    [self addUserScript:[[WKUserScript alloc] initWithSource:[UXKBridgeViewUpdater bridgeScript]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                            forMainFrameOnly:YES]];
    [self addScriptMessageHandler:[[UXKBridgeViewUpdater alloc] initWithView:self.view]
                             name:@"UXK_ViewUpdater"];
}

- (void)configureTasks {
    [self addUserScript:[[WKUserScript alloc] initWithSource:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UXKTasks" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES]];
}

@end
