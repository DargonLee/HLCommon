//
//  UIImage+Theme.m
//  tokenlender
//
//  Created by BoyLee on 2018/4/23.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import "UIImage+Theme.h"

@implementation UIImage (Theme)

- (UIImage *)imageForThemeColor:(UIColor *)color
{
    return [self imageForThemeColor:color blendModel:kCGBlendModeDestinationIn];
}

- (UIImage *)imageForThemeColor:(UIColor *)color blendModel:(CGBlendMode)blendModel
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    [color setFill];
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(rect);
    [self drawInRect:rect blendMode:blendModel alpha:1.0f];
    if (blendModel != kCGBlendModeDestinationIn) {
        [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  image;
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)color
{
    return [self imageForThemeColor:color blendModel:kCGBlendModeOverlay];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 2.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}


@end
