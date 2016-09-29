//
//  UXKViewController.m
//  uxkit
//
//  Created by 崔 明辉 on 2016/9/29.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKViewController.h"
#import "UIViewController+UXKBridge.h"

@interface UXKViewController ()

@end

@implementation UXKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uxk_setup];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.uxk_bodyView layoutSubviews];
}

@end
