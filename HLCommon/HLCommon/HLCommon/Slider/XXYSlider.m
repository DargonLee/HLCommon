//
//  XXYSlider.m
//  cash_cow
//
//  Created by 稻草人lxh on 2017/6/14.
//  Copyright © 2017年 xiaoxinyong. All rights reserved.
//

#import "XXYSlider.h"

@interface XXYSlider ()

@property (nonatomic, strong) UIImageView * popView;
@property (nonatomic, strong) UILabel * popLb;
@property (nonatomic, assign) NSInteger lastValue;

@end

@implementation XXYSlider

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    if (dataSource.count == 0 || dataSource == nil) {
        return;
    }
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
//    [self addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.continuous = NO;
    self.popView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"滑动金额"]];
    _popView.frame = CGRectMake(-10, -40, 50, 30);
    _popView.userInteractionEnabled = YES;
    [self addSubview:_popView];
    self.popLb = [[UILabel alloc] init];
    [_popView addSubview:_popLb];
    _popLb.frame = CGRectMake(0, 0, 50, 30);
//    _popLb.textColor = SYSTEM_COLOR;
    _popLb.text = [NSString stringWithFormat:@"%ld",(long)self.minimumValue];
    _popLb.textAlignment = NSTextAlignmentCenter;
    NSMutableArray * imgViews = [NSMutableArray array];
    NSArray * arr = [self subviews];
    for (UIView * view in arr) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [imgViews addObject:view];
        }
    }
}

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, CGRectGetWidth(self.frame), 7);
}

- (void)setValue:(float)value animated:(BOOL)animated
{
    [super setValue:value animated:animated];
    NSInteger valueSum = (NSInteger)self.minimumValue;
    for (int i = 0 ; i < self.dataSource.count; i++) {
        NSString * valueStr = self.dataSource[i];
        if (value >= [valueStr integerValue]) {
            valueSum = [valueStr integerValue];
        }
    }
    _popLb.text = [NSString stringWithFormat:@"%ld",(long)valueSum];
    self.valueStr = _popLb.text;
}

- (void)sliderValueChanged:(UISlider *)sender
{
    NSInteger valueSum = (NSInteger)self.minimumValue;
    for (int i = 0 ; i < self.dataSource.count; i++) {
        NSString * valueStr = self.dataSource[i];
        if (sender.value >= [valueStr integerValue]) {
            valueSum = [valueStr integerValue];
        }
    }
    if (self.delegate && self.lastValue != valueSum) {
        [self.delegate XXYSlider:self value:[NSString stringWithFormat:@"%ld",(long)valueSum]];
    }
    self.lastValue = valueSum;
}




- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    bounds = [super thumbRectForBounds:bounds trackRect:rect value:value];
    rect.origin.y = rect.origin.y - 20;
    rect.size.height = rect.size.height + 40;
    CGRect insetRect = CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 10 ,10);
    CGFloat x = bounds.origin.x - ((50 - 29)/2);
    _popView.frame = CGRectMake(x, -43, 50, 30);
    return insetRect;
}

@end
