//
//  ViewController.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/13.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+UXKBridge.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uxk_loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RedBox" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
}

@end
