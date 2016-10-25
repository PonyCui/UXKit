//
//  UXKImageView.m
//  uxkit
//
//  Created by 崔 明辉 on 16/9/25.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKImageView.h"
#import "UXKProps.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface _UXKImageView : UIImageView

@property (nonatomic, assign) UIImageRenderingMode renderingMode;

@end

@interface UXKImageView ()

@property (nonatomic, strong) _UXKImageView *imageView;

@end

@implementation UXKImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[_UXKImageView alloc] initWithFrame:self.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.imageView];
    }
    return self;
}

- (BOOL)staticLayouts {
    return YES;
}

- (void)setProps:(NSDictionary *)props updatePropsOnly:(BOOL)updatePropsOnly {
    [super setProps:props updatePropsOnly:updatePropsOnly];
    if ([props[@"url"] isKindOfClass:[NSString class]]) {
        NSURL *URL = [NSURL URLWithString:props[@"url"]];
        [self.imageView sd_setImageWithURL:URL];
    }
    else if ([props[@"base64"] isKindOfClass:[NSString class]]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:props[@"base64"]
                                                                    options:kNilOptions];
            if (imageData == nil) {
                return;
            }
            UIImage *image = [UIImage imageWithData:imageData];
            if (image == nil) {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
            });
        });
    }
    if ([props[@"renderingmode"] isKindOfClass:[NSString class]]) {
        if ([props[@"renderingmode"] isEqualToString:@"template"]) {
            self.imageView.renderingMode = UIImageRenderingModeAlwaysTemplate;
        }
        else {
            self.imageView.renderingMode = UIImageRenderingModeAlwaysOriginal;
        }
    }
    if ([props[@"color"] isKindOfClass:[NSString class]]) {
        self.imageView.tintColor = [UXKProps toColor:props[@"color"]];
    }
}

@end

@implementation _UXKImageView

- (void)setImage:(UIImage *)image {
    image = [image imageWithRenderingMode:self.renderingMode];
    [super setImage:image];
}

@end
