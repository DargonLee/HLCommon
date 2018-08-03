//
//  PlainButtonCell.m
//  form
//
//  Created by 杨桂香 on 3/28/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "PlainButtonCell.h"
#import "XLFormRowDescriptor.h"
#import "UITableViewCell+Helper.h"

@interface PlainButtonCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonLeading;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end
@implementation PlainButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.buttonTrailing.constant = [[self class] ui_horizontalMargin];
    self.buttonLeading.constant = [[self class] ui_horizontalMargin];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTouchButton:(id)sender {
    [self formDescriptorCellDidSelectedWithFormController:self.formViewController];
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    [self.button setTitle:buttonTitle forState:UIControlStateNormal];
}

@end
