//
//  UXKRouter.m
//  uxkit
//
//  Created by 崔 明辉 on 2016/9/29.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKRouter.h"
#import "UXKViewController.h"
#import "UIViewController+UXKBridge.h"

@interface UXKRouter()

@property (nonatomic, strong) UIView *view;

@end

@implementation UXKRouter

+ (NSString *)bridgeScript {
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UXKRouter" ofType:@"js"]
                                     encoding:NSUTF8StringEncoding
                                        error:nil];
}

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        _view = view;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([[message body] isKindOfClass:[NSString class]]) {
        NSString *spec = [message body];
        NSData *specData = [spec dataUsingEncoding:NSUTF8StringEncoding];
        if (specData == nil) {
            return;
        }
        NSDictionary *specObj = [NSJSONSerialization JSONObjectWithData:specData
                                                                options:kNilOptions
                                                                  error:nil];
        if ([specObj isKindOfClass:[NSDictionary class]]) {
            if ([specObj[@"routeType"] isKindOfClass:[NSString class]]) {
                if ([specObj[@"routeType"] isEqualToString:@"open"] &&
                    [specObj[@"url"] isKindOfClass:[NSString class]]) {
                    [self openURL:specObj];
                }
                else if ([specObj[@"routeType"] isEqualToString:@"openHTML"] &&
                    [specObj[@"html"] isKindOfClass:[NSString class]]) {
                    [self openHTML:specObj];
                }
                else if ([specObj[@"routeType"] isEqualToString:@"back"]) {
                    [[[self sourceViewController] navigationController] popViewControllerAnimated:YES];
                }
            }
        }
    }
}

- (UIViewController *)sourceViewController {
    UIResponder *responder = self.view;
    while (responder != nil) {
        responder = [responder nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (id)responder;
        }
    }
    return nil;
}

- (void)openURL:(NSDictionary *)obj {
    [self showNextWithURLString:obj[@"url"]
                          title:([obj[@"title"] isKindOfClass:[NSString class]] ? obj[@"title"] : nil)
           sourceViewController:[self sourceViewController]];
}

- (void)openHTML:(NSDictionary *)obj {
    NSData *HTMLData = [[NSData alloc] initWithBase64EncodedString:obj[@"html"] options:kNilOptions];
    if (HTMLData != nil) {
        NSString *HTMLString = [[NSString alloc] initWithData:HTMLData encoding:NSUTF8StringEncoding];
        [self showNextWithHTMLString:HTMLString
                             baseURL:nil
                               title:([obj[@"title"] isKindOfClass:[NSString class]] ? obj[@"title"] : nil)
                sourceViewController:[self sourceViewController]];
    }
}

- (void)showNextWithURLString:(NSString *)URLString
                        title:(NSString *)title
         sourceViewController:(UIViewController *)sourceViewController {
    UXKViewController *viewController = [UXKViewController new];
    viewController.title = title;
    [viewController uxk_loadURLString:URLString];
    [sourceViewController.navigationController showViewController:viewController sender:nil];
}

- (void)showNextWithHTMLString:(NSString *)HTMLString
                       baseURL:(NSURL *)baseURL
                         title:(NSString *)title
          sourceViewController:(UIViewController *)sourceViewController {
    UXKViewController *viewController = [UXKViewController new];
    viewController.title = title;
    [viewController uxk_loadHTMLString:HTMLString baseURL:baseURL];
    [sourceViewController.navigationController showViewController:viewController sender:nil];
}

@end
