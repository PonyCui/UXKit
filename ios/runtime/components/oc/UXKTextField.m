//
//  UXKTextField.m
//  uxkit
//
//  Created by 崔 明辉 on 16/9/25.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKTextField.h"
#import "UXKProps.h"

@interface UXKTextField ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) UXKViewValueBlock onBeginEditing;
@property (nonatomic, copy) UXKViewValueBlock onChange;
@property (nonatomic, copy) UXKViewValueBlock onEndEditing;

@end

@implementation UXKTextField

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:self.textField];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textField = [[UITextField alloc] initWithFrame:self.bounds];
        self.textField.delegate = self;
        self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.textField];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidChangedText)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:self.textField];
    }
    return self;
}

- (BOOL)staticLayouts {
    return YES;
}

- (void)requestValueWithKey:(NSString *)aKey valueBlock:(UXKViewValueBlock)valueBlock {
    if ([aKey isEqualToString:@"text"]) {
        valueBlock(self.textField.text);
    }
    else if ([aKey isEqualToString:@"focus"]) {
        [self.textField becomeFirstResponder];
    }
    else if ([aKey isEqualToString:@"blur"]) {
        [self.textField resignFirstResponder];
    }
}

- (void)listenValueWithKey:(NSString *)aKey valueBlock:(UXKViewValueBlock)valueBlock {
    if ([aKey isEqualToString:@"onBeginEditing"]) {
        self.onBeginEditing = valueBlock;
    }
    else if ([aKey isEqualToString:@"text"] || [aKey isEqualToString:@"onChange"]) {
        self.onChange = valueBlock;
    }
    else if ([aKey isEqualToString:@"onEndEditing"]) {
        self.onEndEditing = valueBlock;
    }
}

- (void)setProps:(NSDictionary *)props {
    [super setProps:props];
    if ([props[@"text"] isKindOfClass:[NSString class]]) {
        self.textField.text = props[@"text"];
    }
    else if ([props[@"font"] isKindOfClass:[NSString class]]) {
        self.textField.font = [UXKProps toFont:props[@"font"]];
    }
    else if ([props[@"textColor"] isKindOfClass:[NSString class]]) {
        self.textField.textColor = [UXKProps toColor:props[@"textColor"]];
    }
    else if ([props[@"placeholder"] isKindOfClass:[NSString class]]) {
        self.textField.placeholder = props[@"placeholder"];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.onBeginEditing) {
        self.onBeginEditing(textField.text);
    }
}

- (void)textFieldDidChangedText {
    if (self.onChange) {
        self.onChange(self.textField.text);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.onEndEditing) {
        self.onEndEditing(textField.text);
    }
}

@end
