//
//  UIImage+AddForRoundedCorner.h
//  tokenlender
//
//  Created by DragonLee on 2018/4/18.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AddForRoundedCorner)

- (UIImage *)circleImage;

+ (UIImage *)maskRoundCornerRadiusImageWithColor:(UIColor *)color
                                     cornerRadii:(CGSize)cornerRadii
                                            size:(CGSize)size
                                         corners:(UIRectCorner)corners
                                     borderColor:(UIColor *)borderColor
                                     borderWidth:(CGFloat)borderWidth;
@end
