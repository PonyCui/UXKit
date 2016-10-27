//
//  UXKLabel.m
//  uxkit
//
//  Created by 崔 明辉 on 16/9/25.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKLabel.h"
#import "UXKProps.h"
#import "UXKBridge.h"

@interface UXKLabel ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat lineHeight;

@end

@implementation UXKLabel

+ (void)load {
    [UXKBridge addClass:[self class] nodeName:@"Label"];
}

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

- (void)setProps:(NSDictionary *)props updatePropsOnly:(BOOL)updatePropsOnly {
    [super setProps:props updatePropsOnly:updatePropsOnly];
    if ([props[@"textcolor"] isKindOfClass:[NSString class]]) {
        self.label.textColor = [UXKProps toColor:props[@"textcolor"]];
    }
    if ([props[@"font"] isKindOfClass:[NSString class]]) {
        self.label.font = [UXKProps toFont:props[@"font"]];
    }
    if ([props[@"lines"] isKindOfClass:[NSString class]]) {
        self.label.numberOfLines = [props[@"lines"] integerValue];
    }
    if ([props[@"align"] isKindOfClass:[NSString class]]) {
        self.label.textAlignment = [UXKProps toTextAlignment:props[@"align"]];
    }
    if ([props[@"lineheight"] isKindOfClass:[NSString class]]) {
        self.lineHeight = [UXKProps toCGFloat:props[@"lineheight"]];
    }
    if ([props[@"text"] isKindOfClass:[NSString class]]) {
        if (self.lineHeight > 0) {
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.minimumLineHeight = self.lineHeight;
            paragraphStyle.maximumLineHeight = self.lineHeight;
            paragraphStyle.alignment = self.label.textAlignment;
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:props[@"text"]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName: self.label.font,
                                                                                              NSParagraphStyleAttributeName: paragraphStyle,
                                                                                              }];
            self.label.attributedText = attributedText;
        }
        else {
            self.label.text = props[@"text"];
        }
    }
}

- (CGSize)intrinsicContentSizeWithProps:(NSDictionary *)props {
    UIFont *font = [props[@"font"] isKindOfClass:[NSString class]] ? [UXKProps toFont:props[@"font"]] : self.label.font;
    NSString *text = [props[@"text"] isKindOfClass:[NSString class]] ? props[@"text"] : @"";
    CGFloat lineHeight = [props[@"lineheight"] isKindOfClass:[NSString class]] ? [UXKProps toCGFloat:props[@"lineheight"]] : 0;
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    if (lineHeight > 0) {
        paragraphStyle.minimumLineHeight = lineHeight;
        paragraphStyle.maximumLineHeight = lineHeight;
    }
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                         attributes:@{
                                                                                      NSFontAttributeName: font,
                                                                                      NSParagraphStyleAttributeName: paragraphStyle,
                                                                                      }];
    CGSize contentSize = [attributedText boundingRectWithSize:([props[@"frame"] isKindOfClass:[NSString class]] ? [UXKProps toMaxSize:props[@"frame"]] : CGSizeZero)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                      context:NULL].size;
    contentSize.width = ceilf(contentSize.width) + 1.0;
    contentSize.height = ceilf(contentSize.height) + 1.0;
    return contentSize;
}

@end
