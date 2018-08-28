//
//  UIButton+EnlargeEdge.h
//  tokenlender
//
//  Created by Harlan on 2018/8/28.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeEdge)

/** 设置可点击范围到按钮边缘的距离 */
- (void)setEnlargeEdge:(CGFloat)size;

/** 设置可点击范围到按钮上、右、下、左的距离 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

- (void)setEnlargeEdgeWithTop:(CGFloat)top;

- (void)setEnlargeEdgeWithRight:(CGFloat)right;

- (void)setEnlargeEdgeWithBottom:(CGFloat)bottom;

- (void)setEnlargeEdgeWithLeft:(CGFloat)left;

@end
