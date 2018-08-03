//
//  XXYYiduInputCell.m
//  xxyDemo
//
//  Created by 杨桂香 on 6/16/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "XXYYiduInputCell.h"
#import "XLForm.h"
#import "XLFormOptionsObject.h"

@interface XXYYiduInputCell() <UITextFieldDelegate>
@property (nonatomic) NSInteger maxLength;
@end

@implementation XXYYiduInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    self.maxLength = 7;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)update {
    [super update];
    
    if (self.rowDescriptor) {
        
        self.titleLabel.textColor = self.titleColor;
        self.titleLabel.text = self.rowDescriptor.title;
//        self.textLabel.text = self.rowDescriptor.title;
        //        self.textLabel.text = self.rowDescriptor.title;
        //        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //        self.editingAccessoryType = self.accessoryType;
        //        self.detailTextLabel.text = [self valueDisplayText];
    }
}

- (void)textFieldDidChange
{
    if (self.rowDescriptor.selectorOptions) {
        for (XLFormOptionsObject *object in self.rowDescriptor.selectorOptions) {
            //        NSLog(@"%@ %@",object.formValue,object.formDisplayText);
            NSInteger value = object.formDisplayText.integerValue;
            NSInteger thisValue = self.textField.text.integerValue;
            if (thisValue > value) {
                self.rowDescriptor.value = [XLFormOptionsObject formOptionsObjectWithValue:object.formValue displayText:self.textField.text];
            }
        }
    } else {
        if ([self.unitLabel.text isEqualToString:@"%"]) {
            NSInteger value = self.textField.text.integerValue;
            CGFloat floatValue = 0.01*value;
            self.rowDescriptor.value = @(floatValue);//[NSString stringWithFormat:@"%.2f",floatValue];
            
        } else {
            self.rowDescriptor.value = self.textField.text;
        }
       
    }
    
    if ([self.textField.text length] > 0) {
        self.titleColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
        self.titleLabel.textColor = self.titleColor;
    }
    
//    NSLog(@"%@ %@",self.textField.text,self.rowDescriptor.value);
}

# pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger length = textField.text.length - range.length + string.length;
    if (length > self.maxLength) {
        return NO;
    }
    
    return YES;
}

@end
