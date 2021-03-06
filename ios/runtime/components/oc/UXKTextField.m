//
//  UXKTextField.m
//  uxkit
//
//  Created by 崔 明辉 on 16/9/25.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "UXKTextField.h"
#import "UXKProps.h"
#import "UXKBridge.h"

@interface UXKTextField ()<UITextFieldDelegate, UITextInputDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) UXKViewValueBlock onBeginEditing;
@property (nonatomic, copy) UXKViewValueBlock onChange;
@property (nonatomic, copy) UXKViewValueBlock onReturn;
@property (nonatomic, copy) UXKViewValueBlock onEndEditing;

@end

@implementation UXKTextField

+ (void)load {
    [UXKBridge addClass:[self class] nodeName:@"TextField"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textField = [[UITextField alloc] initWithFrame:self.bounds];
        self.textField.delegate = self;
        self.textField.inputDelegate = self;
        self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.textField];
    }
    return self;
}

- (BOOL)staticLayouts {
    return YES;
}

- (void)requestValueWithKey:(NSString *)aKey valueBlock:(UXKViewValueBlock)valueBlock {
    [super requestValueWithKey:aKey valueBlock:valueBlock];
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
    [super listenValueWithKey:aKey valueBlock:valueBlock];
    if ([aKey isEqualToString:@"onBeginEditing"]) {
        self.onBeginEditing = valueBlock;
    }
    else if ([aKey isEqualToString:@"text"] || [aKey isEqualToString:@"onChange"]) {
        self.onChange = valueBlock;
    }
    else if ([aKey isEqualToString:@"onReturn"]) {
        self.onReturn = valueBlock;
    }
    else if ([aKey isEqualToString:@"onEndEditing"]) {
        self.onEndEditing = valueBlock;
    }
}

- (void)setProps:(NSDictionary *)props updatePropsOnly:(BOOL)updatePropsOnly {
    [super setProps:props updatePropsOnly:updatePropsOnly];
    if ([props[@"text"] isKindOfClass:[NSString class]]) {
        self.textField.text = props[@"text"];
    }
    if ([props[@"font"] isKindOfClass:[NSString class]]) {
        self.textField.font = [UXKProps toFont:props[@"font"]];
    }
    if ([props[@"textcolor"] isKindOfClass:[NSString class]]) {
        self.textField.textColor = [UXKProps toColor:props[@"textcolor"]];
    }
    if ([props[@"placeholder"] isKindOfClass:[NSString class]]) {
        self.textField.placeholder = props[@"placeholder"];
    }
    if ([props[@"returnkey"] isKindOfClass:[NSString class]]) {
        self.textField.returnKeyType = [UXKProps toReturnKeyType:props[@"returnkey"]];
    }
    if ([props[@"clearMode"] isKindOfClass:[NSString class]]) {
        self.textField.clearButtonMode = [UXKProps toTextFieldViewMode:props[@"clearMode"]];
    }
    if ([props[@"secure"] isKindOfClass:[NSString class]]) {
        self.textField.secureTextEntry = [UXKProps toBool:props[@"secure"]];
    }
    if ([props[@"keyboardType"] isKindOfClass:[NSString class]]) {
        self.textField.keyboardType = [UXKProps toKeyboardType:props[@"keyboardType"]];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.onBeginEditing) {
        self.onBeginEditing(textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.onReturn) {
        self.onReturn(textField.text);
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.onEndEditing) {
        self.onEndEditing(textField.text);
    }
}

#pragma mark - UITextInputDelegate

- (void)textWillChange:(id<UITextInput>)textInput {
    
}

- (void)textDidChange:(id<UITextInput>)textInput {
    if (self.onChange) {
        self.onChange(self.textField.text);
    }
}

- (void)selectionDidChange:(id<UITextInput>)textInput {
    
}

- (void)selectionWillChange:(id<UITextInput>)textInput {
    
}

@end
