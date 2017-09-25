//
//  HLNoNetworkEmptyView.h
//  基类控制器
//
//  Created by 中观国学 on 2017/9/7.
//  Copyright © 2017年 中观国学. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLNoNetworkEmptyView : UIView

/** 没有网络，重试*/
@property (nonatomic, copy) void(^customNoNetworkEmptyViewDidClickRetryHandle)(HLNoNetworkEmptyView *view);

@end
