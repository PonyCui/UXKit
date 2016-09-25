//
//  UXKTextField.m
//  uxkit
//
//  Created by 崔 明辉 on 16/9/25.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKTextField.h"

@interface UXKTextField ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation UXKTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textField = [[UITextField alloc] initWithFrame:self.bounds];
        self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.textField];
    }
    return self;
}

- (BOOL)staticLayouts {
    return YES;
}

- (void)setProps:(NSDictionary *)props {
    [super setProps:props];
    
}

@end
