//
//  BannerViewCell.h
//  tokenlender
//
//  Created by Harlan on 2018/7/30.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerViewCell : UICollectionViewCell

@property (nonatomic,copy) NSString *imgUrl;

@property (nonatomic,copy) void(^LoadImageBlock)(UIImageView *imageView,NSURL *url);

@end
