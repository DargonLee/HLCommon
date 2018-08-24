//
//  UIImage+AddForRoundedCorner.m
//  tokenlender
//
//  Created by DragonLee on 2018/4/18.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import "UIImage+AddForRoundedCorner.h"

@implementation UIImage (AddForRoundedCorner)

- (UIImage *)circleImage
{
    
    //1.开启图片图形上下文:注意设置透明度为非透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    //2.开启图形上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    //3.绘制圆形区域(此处根据宽度来设置)
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.width);
    CGContextAddEllipseInRect(ref, rect);
    //4.裁剪绘图区域
    CGContextClip(ref);
    
    //5.绘制图片
    [self drawInRect:rect];
    
    //6.获取图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //7.关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

/**提供一个在一个指定的size中绘制图片的便捷方法*/
+ (UIImage *)imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock
{
    if (!drawBlock) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return nil;
    drawBlock(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**绘制方法的具体逻辑，遮罩图片的逻辑是绘制一个矩形，然后在绘制一个相应的圆角矩形，然后填充矩形和圆角矩形的中间部分为父视图的背景色*/
+ (UIImage *)maskRoundCornerRadiusImageWithColor:(UIColor *)color
                                     cornerRadii:(CGSize)cornerRadii
                                            size:(CGSize)size
                                         corners:(UIRectCorner)corners
                                     borderColor:(UIColor *)borderColor
                                     borderWidth:(CGFloat)borderWidth
{
    return [UIImage imageWithSize:size drawBlock:^(CGContextRef  _Nonnull context) {
        CGContextSetLineWidth(context, 0);
        [color set];
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        //绘制一个矩形，这里发-0.3是为了防止边缘的锯齿，
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:CGRectInset(rect, -0.3, -0.3)];
        //绘制圆角矩形，这里的0.3是为了防止内边框的锯齿
        UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 0.3, 0.3) byRoundingCorners:corners cornerRadii:cornerRadii];
        [rectPath appendPath:roundPath];
        CGContextAddPath(context, rectPath.CGPath);
        //注意要用EOFill方式进行填充而非Fill方式
        CGContextEOFillPath(context);
        //如下是绘制边框，原理依旧是绘制一个外边框然后根据边框宽度绘制一个内边框同样采取EOFill的方式进行填充即可
        if (!borderColor || !borderWidth) return;
        [borderColor set];
        UIBezierPath *borderOutterPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:cornerRadii];
        UIBezierPath *borderInnerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:cornerRadii];
        [borderOutterPath appendPath:borderInnerPath];
        CGContextAddPath(context, borderOutterPath.CGPath);
        CGContextEOFillPath(context);
    }];
}

@end
