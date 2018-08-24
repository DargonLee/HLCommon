//
//  UIColor+hexColor.h
//  iWater
//
//  Created by Xudong.ma on 16/5/16.
//  Copyright © 2016年 Xudong.ma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (hexColor)

/**
 *  hex值转换颜色
 *
 *  @param hexStr hex value
 *
 *  @return UIColor
 */
+ (__kindof UIColor *)colorWithHexStr:(NSString *)hexStr;

/**
 *  UIColor转换hex值
 *
 *  @param color UIColor
 *
 *  @return hexStr
 */
+ (__kindof NSString *)hexFromUIColor:(UIColor*)color;

+ (UIColor *)colorWithRGB:(NSInteger)rgb alpha:(CGFloat)alpha;

@end
