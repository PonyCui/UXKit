//
//  UXKBridgeController.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/13.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKBridgeController.h"
#import "UXKBridgeViewUpdater.h"
#import "UXKBridgeTouchUpdater.h"
#import "UXKBridgeAnimationHandler.h"

@interface UXKBridgeController()

@property (nonatomic, strong) UXKBridgeViewUpdater *viewUpdater;
@property (nonatomic, strong) UXKBridgeTouchUpdater *touchUpdater;
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
    [self configureJQuery];
    [self configureViewUpdater];
    [self configureTouchUpdater];
    [self configureAnimationHandler];
    [self configureTasks];
    [self configureComponents];
}

- (void)configureJQuery {
    [self addUserScript:[[WKUserScript alloc] initWithSource:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UXKjQuery.min" ofType:@"js"]
                                                                                       encoding:NSUTF8StringEncoding
                                                                                          error:nil]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                            forMainFrameOnly:YES]];
}

- (void)configureViewUpdater {
    [self addUserScript:[[WKUserScript alloc] initWithSource:[UXKBridgeViewUpdater bridgeScript]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                            forMainFrameOnly:YES]];
    self.viewUpdater = [[UXKBridgeViewUpdater alloc] initWithView:self.view];
    self.viewUpdater.bridgeController = self;
    [self addScriptMessageHandler:self.viewUpdater name:@"UXK_ViewUpdater"];
}

- (void)configureTouchUpdater {
    [self addUserScript:[[WKUserScript alloc] initWithSource:[UXKBridgeTouchUpdater bridgeScript]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                            forMainFrameOnly:YES]];
    self.touchUpdater = [[UXKBridgeTouchUpdater alloc] init];
    self.touchUpdater.bridgeController = self;
    [self addScriptMessageHandler:self.touchUpdater name:@"UXK_TouchUpdater"];
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
    [self addUserScript:[[WKUserScript alloc] initWithSource:[NSString stringWithContentsOfFile:[[NSBundle mainBundle]
                                                                                                 pathForResource:@"UXKTasks" ofType:@"js"]
                                                                                       encoding:NSUTF8StringEncoding error:nil]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES]];
}

- (void)configureComponents {
    static NSArray *components;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        components = @[@"TEST"];
    });
    [self addUserScript:[[WKUserScript alloc] initWithSource:[NSString stringWithContentsOfFile:[[NSBundle mainBundle]
                                                                                                 pathForResource:@"UXKComponents" ofType:@"js"]
                                                                                       encoding:NSUTF8StringEncoding error:nil]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
    [components enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *contents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"UXK%@", obj]
                                                                                                ofType:@"html"] 
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
        NSString *html = [NSString stringWithFormat:@"window._UXK_Components.createJSComponent('%@', '%@');",
                          obj, [[[contents stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                 dataUsingEncoding:NSUTF8StringEncoding]
                                base64EncodedStringWithOptions:kNilOptions]];
        [self addUserScript:[[WKUserScript alloc] initWithSource:html
                                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                forMainFrameOnly:YES]];
        NSString *js = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"UXK%@", obj]
                                                                                          ofType:@"js"]
                                                 encoding:NSUTF8StringEncoding
                                                    error:nil];
        [self addUserScript:[[WKUserScript alloc] initWithSource:js
                                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                forMainFrameOnly:YES]];
    }];
}

@end
