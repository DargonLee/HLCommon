//
//  TextViewCell.m
//  tokenlender
//
//  Created by DragonLee on 2018/4/19.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//
@import ethers;
#import "TextViewCell.h"
#import "XXYTextView.h"
#import "XLFormRowDescriptor.h"
#import "XLFormViewController.h"
#import "XLFormOptionsObject.h"

@interface TextViewCell()<UITextViewDelegate>

@end

@implementation TextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return Real(120);
}

+ (void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[TextViewCell class] forKey:kTextView];
}

- (void)configure
{
    [super configure];
}

- (void)update
{
    [super update];
    [self setUpUI];
}

- (void)setUpUI
{
    XXYTextView * textView = [[XXYTextView alloc]init];
    textView.delegate = self;
    textView.placeholder = _placeholder;
    [self.contentView addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(Real(10));
        make.top.mas_equalTo(self.contentView).offset(Real(10));
        make.right.mas_equalTo(self.contentView).offset(Real(-30));
        make.bottom.mas_equalTo(self.contentView).offset(Real(-5));
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textField
{
//    if (textField.text.length && ![Account isValidMnemonicWord:textField.text]) {
//        textField.textColor = [UIColor redColor];
//    } else {
//        textField.textColor = [UIColor whiteColor];
//    }
    self.rowDescriptor.value = textField.text;
}

@end
