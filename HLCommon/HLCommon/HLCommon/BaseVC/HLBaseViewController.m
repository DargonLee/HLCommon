//
//  HLBaseViewController.m
//  基类控制器
//
//  Created by 中观国学 on 2017/9/7.
//  Copyright © 2017年 中观国学. All rights reserved.
//

#import "HLBaseViewController.h"
#import "HLCommonEmptyView.h"
#import "HLLoadingAnimationView.h"
#import "HLNoNetworkEmptyView.h"

@interface HLBaseViewController ()

@property (nonatomic, strong) HLCommonEmptyView * emptyView;

@property (nonatomic, strong) HLLoadingAnimationView * animationView;

@property (nonatomic, strong) HLNoNetworkEmptyView *noNetworkEmptyView;

@end

@implementation HLBaseViewController


- (HLCommonEmptyView *)emptyView
{
    if (!_emptyView) {
        HLCommonEmptyView *empty = [[HLCommonEmptyView alloc]initWithTitle:@"好友很靠谱，黑名单暂无" secondTitle:@"这里可以看到被你加入黑名单的用户并解除黑名单" iconname:@"calculate_icon_zeji"];
        empty.backgroundColor = [UIColor redColor];
        [self.view addSubview:_emptyView];
        _emptyView = empty;
    }
    return _emptyView;
}

- (void)showEmptyViewTitle:(NSString *)title secondTitle:(NSString *)secondTitle iconname:(NSString *)iconname
{
    self.emptyView.hidden = NO;
    self.emptyView.firstLabel.text = title;
    self.emptyView.secondLabel.text = secondTitle;
    self.emptyView.topTipImageView.image = [UIImage imageNamed:iconname];
}

- (void)hideEmptyView
{
    self.emptyView.hidden = YES;
}

- (HLNoNetworkEmptyView *)noNetworkEmptyView
{
    if (!_noNetworkEmptyView) {
        _noNetworkEmptyView = [[HLNoNetworkEmptyView alloc]init];
        _noNetworkEmptyView.frame = self.view.bounds;
        _noNetworkEmptyView.hidden = YES;
        [self.view addSubview:_noNetworkEmptyView];
    }
    return _noNetworkEmptyView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 空视图的用法
    CGRect rect = CGRectMake(0, 64, self.view.frame.size.width, 370);
    [self.emptyView showInView:self.view withFrame:rect];


    
    __weak typeof(self) weakSelf = self;
    [self.noNetworkEmptyView  setCustomNoNetworkEmptyViewDidClickRetryHandle:^(HLNoNetworkEmptyView *emptyView){
        NSLog(@"点击了重试");
        [weakSelf retryButtonClick];
    }];
}


- (void)retryButtonClick
{
    NSLog(@"点击了重试%s",__func__);
}

- (void)showLoadingAnimation
{
    HLLoadingAnimationView * animationView = [[HLLoadingAnimationView alloc]init];
    [animationView showInView:self.view];
    _animationView = animationView;
    [self.view bringSubviewToFront:animationView];
}

- (void)hideLoadingAnimation
{
    [_animationView dismiss];
    _animationView = nil;
}


-(void)showLoadFailView
{
    self.noNetworkEmptyView.hidden = NO;
}

-(void)hideLoadFailView
{
    self.noNetworkEmptyView.hidden = YES;
}

@end
