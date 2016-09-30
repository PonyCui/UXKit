//
//  UXKNav.m
//  uxkit
//
//  Created by 崔明辉 on 2016/9/30.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKNav.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UXKNav ()

@property (nonatomic, copy) NSString *navType;
@property (nonatomic, strong) UIBarButtonItem *barItem;
@property (nonatomic, strong) UIButton *customView;

@end

@implementation UXKNav

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.customView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.customView addTarget:self action:@selector(handleTouchDown) forControlEvents:UIControlEventTouchDown];
        [self.customView addTarget:self action:@selector(handleTouchUp) forControlEvents:UIControlEventTouchCancel];
        [self.customView addTarget:self action:@selector(handleTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [self.customView addTarget:self action:@selector(handleTouchUp) forControlEvents:UIControlEventTouchUpOutside];
        self.barItem = [[UIBarButtonItem alloc] initWithCustomView:self.customView];
        self.hidden = YES;
    }
    return self;
}

- (void)handleTouchDown {
    self.customView.alpha = 0.4;
}

- (void)handleTouchUp {
    self.customView.alpha = 1.0;
}

- (BOOL)staticLayouts {
    return YES;
}

- (void)layoutUXKViews:(UXKBridgeAnimationHandler *)animationHandler
               newRect:(NSValue *)newRectValue
                except:(UXKView *)except {
    self.frame = newRectValue.CGRectValue;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self attachBarButtonItem];
}

- (void)attachBarButtonItem {
    if ([self.navType isEqualToString:@"left"]) {
        [[self sourceViewController] navigationItem].leftBarButtonItem = self.barItem;
        if ([[self sourceViewController] navigationItem].rightBarButtonItem == self.barItem) {
            [[self sourceViewController] navigationItem].rightBarButtonItem = nil;
        }
    }
    else if ([self.navType isEqualToString:@"right"]) {
        [[self sourceViewController] navigationItem].rightBarButtonItem = self.barItem;
        if ([[self sourceViewController] navigationItem].leftBarButtonItem == self.barItem) {
            [[self sourceViewController] navigationItem].leftBarButtonItem = nil;
        }
    }
}

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    [self.customView addGestureRecognizer:gestureRecognizer];
}

- (void)setProps:(NSDictionary *)props {
    [super setProps:props];
    if ([props[@"type"] isKindOfClass:[NSString class]]) {
        self.navType = props[@"type"];
        [self attachBarButtonItem];
    }
    if ([props[@"text"] isKindOfClass:[NSString class]]) {
        [self setText:props[@"text"]];
    }
    if ([props[@"url"] isKindOfClass:[NSString class]]) {
        [self setImageViewWithURLString:props[@"url"]];
    }
}

- (void)setText:(NSString *)text {
    if (text == nil) {
        return;
    }
    [self.customView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.userInteractionEnabled = NO;
    [button setAttributedTitle:[[NSAttributedString alloc] initWithString:text
                                                               attributes:@{
                                                                            NSFontAttributeName: [UIFont systemFontOfSize:17.0],
                                                                            }]
                      forState:UIControlStateNormal];
    [button sizeToFit];
    button.frame = CGRectMake(0, 0, button.bounds.size.width, 44.0);
    [self.customView addSubview:button];
    self.customView.frame = CGRectMake(self.customView.frame.origin.x, 0, button.bounds.size.width, 44.0);
}

- (void)setImageViewWithURLString:(NSString *)URLString {
    [self.customView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:[NSURL URLWithString:URLString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.customView addSubview:imageView];
        }];
    }];
    self.customView.frame = CGRectMake(self.customView.frame.origin.x, 0, self.bounds.size.width, self.bounds.size.height);
}

- (UIViewController *)sourceViewController {
    UIResponder *responder = self;
    while (responder != nil) {
        responder = [responder nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (id)responder;
        }
    }
    return nil;
}

@end
