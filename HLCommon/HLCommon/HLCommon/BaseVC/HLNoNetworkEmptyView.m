//
//  HLNoNetworkEmptyView.m
//  基类控制器
//
//  Created by 中观国学 on 2017/9/7.
//  Copyright © 2017年 中观国学. All rights reserved.
//

#import "HLNoNetworkEmptyView.h"
#import "UIView+Frame.h"


#define kFont(size) [UIFont systemFontOfSize:size]
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height

@interface HLNoNetworkEmptyView ()

@property (nonatomic, weak) UIImageView *topTipImageView;
@property (nonatomic, weak) UIButton *retryBtn;

@end

@implementation HLNoNetworkEmptyView

- (UIImageView *)topTipImageView {
    if (!_topTipImageView) {
        UIImageView *img = [[UIImageView alloc] init];
        [self addSubview:img];
        _topTipImageView = img;
        img.layer.masksToBounds = YES;
        img.backgroundColor = [UIColor colorWithRed:0.86f green:0.85f blue:0.80f alpha:1.00f];
    }
    return _topTipImageView;
}

- (UIButton *)retryBtn {
    if (!_retryBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        _retryBtn = btn;
        
        btn.backgroundColor = [UIColor orangeColor];
        [btn setTitle:@"马上重试" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = kFont(15);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.adjustsImageWhenDisabled = NO;
        btn.adjustsImageWhenHighlighted = NO;
    }
    return _retryBtn;
}

- (void)btnClick:(UIButton *)btn {
    if (self.customNoNetworkEmptyViewDidClickRetryHandle) {
        self.customNoNetworkEmptyViewDidClickRetryHandle(self);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat topTipW = 100;
    CGFloat topTipX = kScreenWidth / 2.0 - topTipW / 2.0;
    CGFloat topTipY = 150;
    CGFloat topTipH = 100;
    self.topTipImageView.frame = CGRectMake(topTipX, topTipY, topTipW, topTipH);
    
    CGFloat retryX = topTipX + 20;
    CGFloat retryY = self.topTipImageView.bottom + 15;
    CGFloat retryW = 60;
    CGFloat retryH = 25;
    self.retryBtn.frame = CGRectMake(retryX, retryY, retryW, retryH);
    [self.retryBtn sizeToFit];
    
}

@end
