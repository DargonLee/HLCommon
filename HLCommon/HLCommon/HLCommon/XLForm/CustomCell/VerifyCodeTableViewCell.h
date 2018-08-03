//
//  VerifyCodeTableViewCell.h
//  xiaoxinyong
//
//  Created by 杨桂香 on 3/22/16.
//  Copyright © 2016 xiaoxinyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFormBaseCell.h"

@interface VerifyCodeTableViewCell : XLFormBaseCell
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic) NSInteger maxTextLength;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)beginCountDown;
- (void)getSpeechCode;      //语音验证码 置灰

@end
