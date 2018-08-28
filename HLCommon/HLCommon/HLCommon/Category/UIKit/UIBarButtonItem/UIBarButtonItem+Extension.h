//
//  UIBarButtonItem+Extension.h
//  tokenlender
//
//  Created by DragonLee on 2018/4/17.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
