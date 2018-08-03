//
//  VerifyCodeTableViewCell.m
//  xiaoxinyong
//
//  Created by 杨桂香 on 3/22/16.
//  Copyright © 2016 xiaoxinyong. All rights reserved.
//

#import "VerifyCodeTableViewCell.h"
#import "XLFormViewController.h"
#import "UITableViewCell+Helper.h"
#import "UIColor+hexColor.h"
#define TIME 60
@interface VerifyCodeTableViewCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTrailing;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger timeCount;
@end
@implementation VerifyCodeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.textField.delegate = self;
    [self.textField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
//    CGFloat margin = [[self class] ui_horizontalMargin];
//    self.textFieldLeading.constant = margin;
//    self.buttonTrailing.constant = -margin;
    [self.button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithHexStr:@"#3664ED"] forState:UIControlStateNormal];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)update {
    if (self.maxTextLength <=6 ) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        self.textField.keyboardType = UIKeyboardTypePhonePad;
    }
}

- (void)beginCountDown {
    self.button.enabled = NO;
    self.button.alpha = 0.6;
    self.timeCount = 59;
    [self.button setTitle:@"60秒后重发" forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}

-(void)timeFireMethod{

    if (self.timeCount <= 0) {
        
        self.button.alpha = 1.0;
        self.button.enabled = YES;
//        self.button.titleLabel.text = @"获取验证码";
        [self.button setTitle:@"获取验证码" forState:UIControlStateNormal];
//        [self.button setTitleColor:[UIColor colorWithHexStr:@"#9876FF"] forState:UIControlStateNormal];
//        [self.button.titleLabel sizeToFit];
        [self.timer invalidate];
        
    } else {
        
        NSString *str = [NSString stringWithFormat:@"%ld秒后重发",(long)self.timeCount];
//        self.button.titleLabel.text = str;
        [self.button setTitle:str forState:UIControlStateNormal];
//        self.button.enabled = NO;
//        [self.button setTitleColor:[UIColor colorWithRGBA:0x999999 alpha:1.0] forState:UIControlStateNormal];
        
    }
    
    self.timeCount--;
}

- (void)getSpeechCode
{
    self.button.userInteractionEnabled = NO;
    self.timeCount = TIME - 1;
    [self.button setTitleColor:[UIColor colorWithHexStr:@"#999999"] forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeSpeechFireMethod) userInfo:nil repeats:YES];
}

-(void)timeSpeechFireMethod{
    
    if (self.timeCount <= 0) {
        
        self.button.alpha = 1.0;
//        [self.button setTitleColor:[UIColor colorWithRGBA:0x27BC80 alpha:0.8] forState:UIControlStateNormal];
        self.button.userInteractionEnabled = YES;
        [self.button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        
    } else {
        self.button.userInteractionEnabled = NO;
        [self.button setTitleColor:[UIColor colorWithHexStr:@"#999999"] forState:UIControlStateNormal];
    }
    
    self.timeCount--;
}


- (IBAction)didTouchButton:(id)sender {
    [self formDescriptorCellDidSelectedWithFormController:self.formViewController];
    
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return YES;
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self.textField becomeFirstResponder];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return [self.formViewController textFieldShouldClear:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self.formViewController textFieldShouldReturn:textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [self.formViewController textFieldShouldBeginEditing:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return [self.formViewController textFieldShouldEndEditing:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self.formViewController textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.formViewController textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldDidChange:textField];
    [self.formViewController textFieldDidEndEditing:textField];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.textField == textField) {
        if ([self.textField.text length] > 0) {
            self.rowDescriptor.value = self.textField.text;
        } else {
            self.rowDescriptor.value = nil;
        }
    }
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
//    if (self.textField.secureTextEntry) {
    
//    }
    if (self.rowDescriptor.action.formBlock){
        self.rowDescriptor.action.formBlock(self.rowDescriptor);
    } else if (self.rowDescriptor.action.formSelector){
        [controller performFormSelector:self.rowDescriptor.action.formSelector withObject:self.rowDescriptor];
    }
    else if ([self.rowDescriptor.action.formSegueIdenfifier length] != 0){
        [controller performSegueWithIdentifier:self.rowDescriptor.action.formSegueIdenfifier sender:self.rowDescriptor];
    }
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    return [self ui_textFieldCellHeight];
}

@end
