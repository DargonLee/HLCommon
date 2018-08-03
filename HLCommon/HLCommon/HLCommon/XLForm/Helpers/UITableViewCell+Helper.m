//
//  ButtonCell_Helper.m
//  form
//
//  Created by 杨桂香 on 3/24/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "UITableViewCell+Helper.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

@implementation UITableViewCell (Helper)

+ (CGFloat)ui_horizontalMargin {
    if (SCREEN_WIDTH == 320) {
        return 10;
    }
    return 33;
}

+ (CGFloat)ui_textFieldCellHeight {
    if (SCREEN_WIDTH == 320) {
        return 44;
    }
    return 64;
}

+ (CGFloat)ui_buttonCellHeight {
    if (SCREEN_WIDTH == 320) {
        return 62;
    }
    
    return 72;
}

+ (CGFloat)ui_buttonHeight {
    if (SCREEN_WIDTH == 320) {
        return 38;
    }
    return 42;
}

@end
