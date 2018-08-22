//
//  XXYTabBar.m
//  HLNeiHanDuanZI
//
//  Created by DragonLee on 2017/11/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "XXYTabBar.h"

@interface XXYTabBar ()

@property (nonatomic, weak) UIButton * publish;

@end

@implementation XXYTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
        UIButton * publish = [UIButton buttonWithType:UIButtonTypeCustom];
        [publish setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publish setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        [publish addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publish];
        self.publish = publish;
        
    }
    return self;
}

- (void)publishClick
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.publish.bounds = CGRectMake(0, 0, self.publish.currentBackgroundImage.size.width, self.publish.currentBackgroundImage.size.height);
    self.publish.center = CGPointMake(0.5*width, 0.5*height);
    
    CGFloat buttonY = 0;
    CGFloat buttonW = width/5;
    CGFloat buttoXXY = height;
    NSInteger index = 0;
    
    //设置其他Button的frame
    for (UIView * button in self.subviews) {
        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        
        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttoXXY);
        
        index++;
    }
}

@end
