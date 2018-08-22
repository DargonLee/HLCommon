//
//  HLCommonEmptyView.h
//  基类控制器
//
//  Created by 中观国学 on 2017/9/7.
//  Copyright © 2017年 中观国学. All rights reserved.
//  公共空界面显示视图

#import <UIKit/UIKit.h>

@interface HLCommonEmptyView : UIView
/**
 提示 图片
 */
@property (nonatomic, weak) UIImageView *topTipImageView;
/**
 第一行label
 */
@property (nonatomic, weak) UILabel *firstLabel;
/**
 第二行label
 */
@property (nonatomic, weak) UILabel *secondLabel;


- (instancetype)initWithTitle:(NSString *)title
                  secondTitle:(NSString *)secondTitle
                     iconname:(NSString *)iconname;

/**
 显示在哪个视图上

 @param view 父视图
 @param frame 在父视图上的位置 （可以不传会有默认位置）
 */
- (void)showInView:(UIView *)view withFrame:(CGRect)frame;
- (void)dismiss;

@end
