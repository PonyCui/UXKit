//
//  UXKLabel.m
//  uxkit
//
//  Created by 崔 明辉 on 16/9/25.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKLabel.h"
#import "UXKProps.h"

@interface UXKLabel ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation UXKLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.label];
    }
    return self;
}

- (BOOL)staticLayouts {
    return YES;
}

- (void)setProps:(NSDictionary *)props {
    [super setProps:props];
    if ([props[@"textColor"] isKindOfClass:[NSString class]]) {
        self.label.textColor = [UXKProps toColor:props[@"textColor"]];
    }
    if ([props[@"font"] isKindOfClass:[NSString class]]) {
        self.label.font = [UXKProps toFont:props[@"font"]];
    }
    if ([props[@"text"] isKindOfClass:[NSString class]]) {
        self.label.text = props[@"text"];
    }
    if ([props[@"lines"] isKindOfClass:[NSString class]]) {
        self.label.numberOfLines = [props[@"lines"] integerValue];
    }
}

- (CGSize)intrinsicContentSizeWithProps:(NSDictionary *)props {
    UIFont *font = [props[@"font"] isKindOfClass:[NSString class]] ? [UXKProps toFont:props[@"font"]] : self.label.font;
    NSString *text = [props[@"text"] isKindOfClass:[NSString class]] ? props[@"text"] : @"";
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                         attributes:@{
                                                                                      NSFontAttributeName: font,
                                                                                      }];
    CGSize contentSize = [attributedText boundingRectWithSize:([props[@"frame"] isKindOfClass:[NSString class]] ? [UXKProps toMaxSize:props[@"frame"]] : CGSizeZero)
                                                      options:NSStringDrawingUsesDeviceMetrics | NSStringDrawingUsesLineFragmentOrigin
                                                      context:NULL].size;
    contentSize.width = ceilf(contentSize.width) + 2.0;
    contentSize.height = ceilf(contentSize.height) + 2.0;
    return contentSize;
}

@end
