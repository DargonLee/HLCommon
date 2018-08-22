//
//  HLCommonEmptyView.m
//  基类控制器
//
//  Created by 中观国学 on 2017/9/7.
//  Copyright © 2017年 中观国学. All rights reserved.
//

#import "HLCommonEmptyView.h"
#import "UIView+Frame.h"
#import "NSString+Size.h"

#define kFont(size) [UIFont systemFontOfSize:size]
#define kCommonGrayTextColor [UIColor colorWithRed:0.63f green:0.63f blue:0.63f alpha:1.00f]
#define kCommonBlackColor [UIColor colorWithRed:0.17f green:0.23f blue:0.28f alpha:1.00f]
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height

@interface HLCommonEmptyView ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *secondTitle;
@property (nonatomic, copy) NSString *iconname;

@end

@implementation HLCommonEmptyView

- (instancetype)initWithTitle:(NSString *)title
                  secondTitle:(NSString *)secondTitle
                     iconname:(NSString *)iconname {
    if (self = [super init]) {
        self.title = title;
        self.secondTitle = secondTitle;
        self.iconname = iconname;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if ([title isKindOfClass:[NSString class]]) {
        self.firstLabel.text = title;
    }
}

- (void)setSecondTitle:(NSString *)secondTitle {
    _secondTitle = secondTitle;
    if ([secondTitle isKindOfClass:[NSString class]]) {
        self.secondLabel.text = secondTitle;
    }
}

- (void)setIconname:(NSString *)iconname {
    _iconname = iconname;
    if ([iconname isKindOfClass:[NSString class]]) {
        self.topTipImageView.image = [UIImage imageNamed:iconname];
    }
}

- (void)showInView:(UIView *)view withFrame:(CGRect)frame{
    if (view) {
        self.hidden = NO;
        CGFloat selfH = 0;
        if (self.secondTitle) {
            selfH = 170;
        } else {
            selfH = 140;
        }
        [view addSubview:self];
        if (NSStringFromCGRect(frame)) {
            self.frame = frame;
            self.height = 170;
        }else{
            
        self.frame = CGRectMake(0, 0, view.width, selfH);
            
        }
    }
}

- (void)dismiss
{
    self.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat topTipW = self.topTipImageView.image.size.width;
    CGFloat topTipX = kScreenWidth / 2.0 - topTipW / 2.0;
    CGFloat topTipY = 30;
    CGFloat topTipH = self.topTipImageView.image.size.height;
    self.topTipImageView.frame = CGRectMake(topTipX, topTipY, topTipW, topTipH);
    
    if (self.title) {
        CGFloat firstW = kScreenWidth - 80 * 2;
        CGFloat firstX = (kScreenWidth - firstW) / 2.0;
        CGFloat firstY = self.topTipImageView.bottom;
        CGFloat firstH = [self.title heightWithFont:self.firstLabel.font constrainedToWidth:firstW];
        self.firstLabel.frame = CGRectMake(firstX, firstY, firstW, firstH);
    }else {
        CGFloat firstW = kScreenWidth - 80 * 2;
        CGFloat firstX = (kScreenWidth - firstW) / 2.0;
        CGFloat firstY = self.topTipImageView.bottom + 0;
        CGFloat firstH = 0;
        self.firstLabel.frame = CGRectMake(firstX, firstY, firstW, firstH);
    }
    
    
    if (self.secondTitle) {
        CGFloat secondX = self.firstLabel.x;
        CGFloat secondY = self.firstLabel.bottom + 8;
        CGFloat secondW = self.firstLabel.width;
        CGFloat secondH = [self.secondTitle heightWithFont:self.secondLabel.font constrainedToWidth:secondW];
        self.secondLabel.frame = CGRectMake(secondX, secondY, secondW, secondH);
    }else {
        CGFloat secondX = self.firstLabel.x;
        CGFloat secondY = self.firstLabel.bottom + 8;
        CGFloat secondW = self.firstLabel.width;
        CGFloat secondH = 0;
        self.secondLabel.frame = CGRectMake(secondX, secondY, secondW, secondH);
    }
}



- (UILabel *)firstLabel {
    if (!_firstLabel) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        _firstLabel = label;
        label.font = kFont(16);
        label.textColor = kCommonBlackColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
    }
    return _firstLabel;
}

- (UILabel *)secondLabel {
    if (!_secondLabel) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        _secondLabel = label;
        label.font = kFont(14);
        label.textColor = kCommonGrayTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
    }
    return _secondLabel;
}

- (UIImageView *)topTipImageView {
    if (!_topTipImageView) {
        UIImageView *img = [[UIImageView alloc] init];
        [self addSubview:img];
        _topTipImageView = img;
        img.layer.masksToBounds = YES;
    }
    return _topTipImageView;
}


@end
