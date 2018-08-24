//
//  HLBannerView.h
//  tokenlender
//
//  Created by Harlan on 2018/7/30.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLBannerView;
@protocol HLBannerViewDelegate <NSObject>

- (void)bannerView:(HLBannerView *)bannerView didSelectedItemAtIndex:(NSInteger)index;

@end

@interface HLBannerView : UIView

/**
 *  用来展示图片的数据源
 */
@property (nonatomic,strong) NSArray *imgUrls;

/**
 *  用于告知外界, 当前滚动到的是哪个广告数据模型
 */
@property (nonatomic,weak) id <HLBannerViewDelegate> delegate;

/**
 *  用于加载图片的代码块, 必须赋值
 */
@property (nonatomic,copy) void(^LoadImageBlock)(UIImageView *imageView,NSURL *url);

@end
