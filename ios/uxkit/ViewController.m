//
//  ViewController.m
//  uxkit
//
//  Created by 崔 明辉 on 16/8/13.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "ViewController.h"
#import "UXKBridge.h"

@interface ViewController ()

@property (nonatomic, strong) UXKBridge *bridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bridge = [[UXKBridge alloc] initWithView:self.view];
    [self.bridge loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RedBox" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
}

@end
