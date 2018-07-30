//
//  BannerViewCell.m
//  tokenlender
//
//  Created by Harlan on 2018/7/30.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import "BannerViewCell.h"


@interface BannerViewCell()

@property (nonatomic,weak) UIImageView *imageView;

@end

@implementation BannerViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

- (void)setImgUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
    //[self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"placeHolder"]];

}

@end
