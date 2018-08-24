//
//  UIImage+Theme.h
//  tokenlender
//
//  Created by BoyLee on 2018/4/23.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Theme)

- (UIImage *)imageForThemeColor:(UIColor *)color;

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
