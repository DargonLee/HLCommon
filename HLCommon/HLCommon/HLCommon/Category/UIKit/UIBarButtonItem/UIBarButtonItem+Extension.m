//
//  UIBarButtonItem+Extension.m
//  tokenlender
//
//  Created by DragonLee on 2018/4/17.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    if(highImage){[btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];}
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.size = CGSizeMake(40, 40);
    
    return [[self alloc]initWithCustomView:btn];
}

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [btn setTitleColor:[UIColor colorWithHexStr:@"#8E9AB5"] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}


@end
