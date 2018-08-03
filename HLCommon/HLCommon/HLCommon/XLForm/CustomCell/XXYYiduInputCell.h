//
//  XXYYiduInputCell.h
//  xxyDemo
//
//  Created by 杨桂香 on 6/16/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFormBaseCell.h"

@interface XXYYiduInputCell : XLFormBaseCell
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@end
