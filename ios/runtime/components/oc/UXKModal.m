//
//  UXKModal.m
//  uxkit
//
//  Created by 崔明辉 on 2016/10/26.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKModal.h"

static UIWindow *modalWindow;

@interface UXKModal ()

@end

@implementation UXKModal

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [self createModalWindow];
    [super willMoveToWindow:newWindow];
    if (newWindow == modalWindow) {
        self.frame = modalWindow.bounds;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.hidden = NO;
    }
    else {
        self.hidden = YES;
    }
}

- (void)createModalWindow {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        modalWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        modalWindow.windowLevel = UIWindowLevelNormal + 1;
    });
}

- (void)requestValueWithKey:(NSString *)aKey valueBlock:(UXKViewValueBlock)valueBlock {
    if ([aKey isEqualToString:@"show"]) {
        [modalWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [modalWindow addSubview:self];
        modalWindow.hidden = NO;
    }
    else if ([aKey isEqualToString:@"hide"]) {
        modalWindow.hidden = YES;
    }
}

@end
