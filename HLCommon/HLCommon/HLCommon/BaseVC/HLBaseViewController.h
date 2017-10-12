//
//  HLBaseViewController.h
//  基类控制器
//
//  Created by 中观国学 on 2017/9/7.
//  Copyright © 2017年 中观国学. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLBaseViewController : UIViewController

//显示加载动画
- (void)showLoadingAnimation;

//隐藏加载动画
- (void)hideLoadingAnimation;

- (void)showLoadFailView;

- (void)hideLoadFailView;

//点击重试的方法
- (void)retryButtonClick;

- (void)showEmptyViewTitle:(NSString *)title
               secondTitle:(NSString *)secondTitle
                  iconname:(NSString *)iconname;

- (void)hideEmptyView;

@end
