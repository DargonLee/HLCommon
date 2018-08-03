//
//  RightButtonCell.m
//  form
//
//  Created by 杨桂香 on 3/28/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "RightButtonCell.h"
#import "XLFormRowDescriptor.h"
#import "UITableViewCell+Helper.h"
#import "XLFormViewController.h"

@interface RightButtonCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTrailing;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end
@implementation RightButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.buttonTrailing.constant = [[self class] ui_horizontalMargin];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)touchButton:(id)sender {
    [self formDescriptorCellDidSelectedWithFormController:self.formViewController];
}

- (void)update {
    NSString *title = self.rowDescriptor.title;
    if (title) {
        [self.button setTitle:title forState:UIControlStateNormal];
    }
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    return 30;
}

@end
