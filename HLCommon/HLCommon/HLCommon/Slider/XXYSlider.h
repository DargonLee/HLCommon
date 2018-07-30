//
//  XXYSlider.h
//  cash_cow
//
//  Created by 稻草人lxh on 2017/6/14.
//  Copyright © 2017年 xiaoxinyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXYSlider;
@protocol XXYSliderDelegate <NSObject>

- (void)XXYSlider:(XXYSlider *)slider value:(NSString *)value;

@end

@interface XXYSlider : UISlider

@property (nonatomic, strong) NSString * valueStr;                  //当前value
@property (nonatomic, strong) NSMutableArray * dataSource;          //分段数组
@property (nonatomic, assign) id <XXYSliderDelegate> delegate;

@end
