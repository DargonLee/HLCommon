//
//  HLLoadingAnimationView.m
//  基类控制器
//
//  Created by 中观国学 on 2017/9/7.
//  Copyright © 2017年 中观国学. All rights reserved.
//

#import "HLLoadingAnimationView.h"

@interface HLLoadingAnimationView ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation HLLoadingAnimationView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];;
    }
    return self;
}

- (void)showInView:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [view addSubview:self];
    self.frame = view.bounds;
    self.imageView.frame = CGRectMake(0, 0, 70, 100);
    self.imageView.center = self.center;
    
    [self.imageView startAnimating];
    
}

- (void)dismiss {
    [_imageArray removeAllObjects];
    [_imageView stopAnimating];
    [_imageView removeFromSuperview];
    [self removeFromSuperview];
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray new];
    }
    return _imageArray;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *img = [[UIImageView alloc] init];
        [self addSubview:img];
        _imageView = img;
        
        for (NSInteger i = 0; i < 17; i++) {//refreshjoke_loading_0
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refreshjoke_loading_%ld", i%17]];
            [self.imageArray addObject:image];
        }
        self.imageView.animationDuration = 1.00;
        self.imageView.animationRepeatCount = 0;
        self.imageView.animationImages = self.imageArray;
    }
    return _imageView;
}

@end
