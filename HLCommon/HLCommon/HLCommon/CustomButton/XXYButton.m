//
//  XXYButton.m
//  tokenlender
//
//  Created by Harlan on 2018/8/2.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import "XXYButton.h"

@implementation XXYButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0,contentRect.size.height*0.7, contentRect.size.width, contentRect.size.height*0.3);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.height*0.7);
}

@end
