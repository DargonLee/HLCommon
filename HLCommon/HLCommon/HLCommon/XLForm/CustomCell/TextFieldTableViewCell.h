//
//  PasswordTableViewCell.h
//  xiaoxinyong
//
//  Created by 杨桂香 on 3/22/16.
//  Copyright © 2016 xiaoxinyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFormBaseCell.h"

@interface TextFieldTableViewCell : XLFormBaseCell

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) NSInteger maxTextLength;

@end
