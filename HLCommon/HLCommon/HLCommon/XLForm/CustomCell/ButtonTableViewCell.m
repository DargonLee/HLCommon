//
//  ButtonTableViewCell.m
//  xiaoxinyong
//
//  Created by 杨桂香 on 3/22/16.
//  Copyright © 2016 xiaoxinyong. All rights reserved.
//

#import "ButtonTableViewCell.h"
#import "XLFormRowDescriptor.h"
#import "UITableViewCell+Helper.h"

//static NSInteger const kButtonHeight = 42;
//static NSInteger const kCellHeight = 82;

@interface ButtonTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonLeading;

@end
@implementation ButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.buttonHeight.constant = [[self class] ui_buttonHeight];
    self.buttonTrailing.constant = [[self class] ui_horizontalMargin];
    self.buttonLeading.constant = [[self class] ui_horizontalMargin];
    
    self.button.layer.cornerRadius = [[self class] ui_buttonHeight]/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
//    self.button.selected = selected;
    // Configure the view for the selected state
}

- (void)update {
    if (self.rowDescriptor) {
        [self.button setTitle:self.rowDescriptor.title forState:UIControlStateNormal];
    }
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    return [self ui_buttonCellHeight];
}

- (IBAction)didTouchButton:(id)sender {
    [self formDescriptorCellDidSelectedWithFormController:self.formViewController];
//    [self formDescriptorCellDidSelectedWithFormController:self.formViewController];
}

@end
