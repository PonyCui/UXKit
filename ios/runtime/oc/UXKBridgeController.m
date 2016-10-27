//
//  UXKBridgeController.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/13.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKBridgeController.h"
#import "UXKBridgeViewUpdater.h"
#import "UXKBridgeValueManager.h"
#import "UXKBridgeTouchUpdater.h"
#import "UXKBridgeAnimationHandler.h"
#import "UXKRouter.h"

@interface UXKBridgeController()

@property (nonatomic, strong) UXKRouter *router;
@property (nonatomic, strong) UXKBridgeViewUpdater *viewUpdater;
@property (nonatomic, strong) UXKBridgeValueManager *valueManager;
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
    [self configureRouter];
    [self configureViewUpdater];
    [self configureValueManager];
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
    [self addUserScript:[[WKUserScript alloc] initWithSource:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UXKProps" ofType:@"js"]
                                                                                       encoding:NSUTF8StringEncoding
                                                                                          error:nil]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                            forMainFrameOnly:YES]];
}

- (void)configureRouter {
    [self addUserScript:[[WKUserScript alloc] initWithSource:[UXKRouter bridgeScript]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                            forMainFrameOnly:YES]];
    self.router = [[UXKRouter alloc] initWithView:self.view];
    [self addScriptMessageHandler:self.router name:@"UXK_Router"];
}

- (void)configureViewUpdater {
    [self addUserScript:[[WKUserScript alloc] initWithSource:[UXKBridgeViewUpdater bridgeScript]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                            forMainFrameOnly:YES]];
    self.viewUpdater = [[UXKBridgeViewUpdater alloc] initWithView:self.view];
    self.viewUpdater.bridgeController = self;
    [self addScriptMessageHandler:self.viewUpdater name:@"UXK_ViewUpdater"];
}

- (void)configureValueManager {
    [self addUserScript:[[WKUserScript alloc] initWithSource:[UXKBridgeValueManager bridgeScript]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                            forMainFrameOnly:YES]];
    self.valueManager = [[UXKBridgeValueManager alloc] init];
    self.valueManager.bridgeController = self;
    [self addScriptMessageHandler:self.valueManager name:@"UXK_ValueManager"];
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
    [self addScriptMessageHandler:self.animationHandler name:@"UXK_AnimationHandler_Decay"];
    [self addScriptMessageHandler:self.animationHandler name:@"UXK_AnimationHandler_Stop"];
}

- (void)configureTasks {
    [self addUserScript:[[WKUserScript alloc] initWithSource:[NSString stringWithContentsOfFile:[[NSBundle mainBundle]
                                                                                                 pathForResource:@"UXKTasks" ofType:@"js"]
                                                                                       encoding:NSUTF8StringEncoding error:nil]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES]];
}

- (void)configureComponents {
    [self addUserScript:[[WKUserScript alloc] initWithSource:[NSString stringWithContentsOfFile:[[NSBundle mainBundle]
                                                                                                 pathForResource:@"UXKComponents" ofType:@"js"]
                                                                                       encoding:NSUTF8StringEncoding error:nil]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
    
    NSBundle *components = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"UXKJSComponents" ofType:@"bundle"]];
    NSArray *dirs = [components pathsForResourcesOfType:@"" inDirectory:@"./"];
    [dirs enumerateObjectsUsingBlock:^(id  _Nonnull dir, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *html = [components pathsForResourcesOfType:@"html" inDirectory:[[dir componentsSeparatedByString:@"/"] lastObject] forLocalization:nil];
        [html enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *nodeName = [[[[obj componentsSeparatedByString:@"/"] lastObject]
                                   stringByReplacingOccurrencesOfString:@"UXK" withString:@""] stringByReplacingOccurrencesOfString:@".html" withString:@""];
            NSString *contents = [NSString stringWithContentsOfFile:obj
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
            NSString *html = [NSString stringWithFormat:@"window._UXK_Components.createJSComponent('%@', '%@');",
                              [nodeName uppercaseString], [[[contents stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                                            dataUsingEncoding:NSUTF8StringEncoding]
                                                           base64EncodedStringWithOptions:kNilOptions]];
            [self addUserScript:[[WKUserScript alloc] initWithSource:html
                                                       injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                    forMainFrameOnly:YES]];
            NSString *js = [NSString stringWithContentsOfFile:[components pathForResource:[NSString stringWithFormat:@"UXK%@", nodeName]
                                                                                   ofType:@"js"
                                                                              inDirectory:[[dir componentsSeparatedByString:@"/"] lastObject]]
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
            [self addUserScript:[[WKUserScript alloc] initWithSource:js
                                                       injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                    forMainFrameOnly:YES]];
        }];
    }];
    [self addUserScript:[[WKUserScript alloc] initWithSource:[NSString stringWithFormat:@"window._UXK_Components.PIXELLINE.scale = %f",
                                                              [UIScreen mainScreen].scale]
                                               injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                            forMainFrameOnly:YES]];
}

@end
