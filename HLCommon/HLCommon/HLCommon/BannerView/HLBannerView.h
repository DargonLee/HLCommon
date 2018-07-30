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

@property (nonatomic,copy) NSArray *imgUrls;

@property (nonatomic,weak) id <HLBannerViewDelegate> delegate;

@end
