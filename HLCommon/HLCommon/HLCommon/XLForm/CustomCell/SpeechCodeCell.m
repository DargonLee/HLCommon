//
//  SpeechCodeCell.m
//  xiaodai
//
//  Created by 稻草人lxh on 2017/6/26.
//  Copyright © 2017年 xiaoxinyong. All rights reserved.
//

/**
 *  语音验证码Cell
 */

#import "SpeechCodeCell.h"
#import "XLFormRowDescriptor.h"
#import "XLFormViewController.h"
#import "UIColor+hexColor.h"
#define TIME 60

@interface SpeechCodeCell ()

@property (nonatomic, strong) UIView * layoutView;          //布局View
@property (nonatomic, strong) UILabel * oneLb;              //label不可点击
@property (nonatomic, strong) UILabel * clickLb;            //label可点击
@property (nonatomic) NSInteger timeCount;
@property (strong, nonatomic) NSTimer *timer;

@end

NSString * const SPEECHCODECELL = @"SPEECHCODECELL";

@implementation SpeechCodeCell

- (UIView *)layoutView
{
    if (!_layoutView) {
        _layoutView = [[UIView alloc] init];
        [self.contentView addSubview:_layoutView];
    }
    return _layoutView;
}

- (UILabel *)oneLb
{
    if (!_oneLb) {
        _oneLb = [[UILabel alloc] init];
        [self.layoutView addSubview:_oneLb];
    }
    return _oneLb;
}

- (UILabel *)clickLb
{
    if (!_clickLb) {
        _clickLb = [[UILabel alloc] init];
        [self.layoutView addSubview:_clickLb];
    }
    return _clickLb;
}

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[SpeechCodeCell class] forKey:SPEECHCODECELL];
}

- (void)configure
{
    [super configure];
}

- (void)update
{
    [super update];
    [self setUpUI];
}

- (void)setUpUI
{
    self.selectionStyle = UITableViewCellEditingStyleNone;
    self.userInteractionEnabled = YES;
    self.layoutView.userInteractionEnabled = YES;
    self.oneLb.text = @"收不到短信？60秒后尝试";
    _oneLb.font = [UIFont systemFontOfSize:14];
    _oneLb.textColor = [UIColor colorWithHexStr:@"#999999"];
    
    self.clickLb.text = @"语音验证码";
    _clickLb.font = [UIFont systemFontOfSize:14];
    _clickLb.textColor = [UIColor colorWithHexStr:@"#999999"];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGetCode)];
    [_clickLb addGestureRecognizer:tap];
    
    [_layoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(self.contentView.mas_height);
    }];
    
    [_oneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_layoutView.mas_left);
        make.right.mas_equalTo(_clickLb.mas_left);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [_clickLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(_layoutView.mas_right);
    }];
}

- (void)beginCountDown {
    self.clickLb.userInteractionEnabled = NO;
    self.clickLb.textColor = [UIColor colorWithHexStr:@"#999999"];
    self.timeCount = TIME - 1;
    NSString * timeStr = [NSString stringWithFormat:@"收不到短信？%d秒后尝试",TIME];
    self.oneLb.text = timeStr;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}

-(void)timeFireMethod{
    
    if (self.timeCount <= 0) {
        
        self.clickLb.userInteractionEnabled = YES;
        self.clickLb.textColor = [UIColor redColor];
        self.oneLb.text = @"收不到验证码？试试";
        self.clickLb.text = @"语音验证码";
        [self.timer invalidate];
        
    } else {
        self.clickLb.userInteractionEnabled = NO;
        self.oneLb.text = [NSString stringWithFormat:@"收不到短信？%ld秒后尝试",self.timeCount];
        self.clickLb.text = @"语音验证码";
    }
    
    self.timeCount--;
}

- (void)beginSpeechCountDown
{
    self.clickLb.userInteractionEnabled = NO;
    self.clickLb.textColor = [UIColor colorWithHexStr:@"#999999"];
    self.clickLb.text = @"";
    self.timeCount = TIME - 1;
    NSString * timeStr = [NSString stringWithFormat:@"请注意接听电话，%d秒后重试",TIME];
    self.oneLb.text = timeStr;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeSpeechFireMethod) userInfo:nil repeats:YES];
}

-(void)timeSpeechFireMethod{
    
    if (self.timeCount <= 0) {
        
        self.clickLb.userInteractionEnabled = YES;
        self.clickLb.textColor = [UIColor redColor];
        self.oneLb.text = @"收不到验证码？试试";
        self.clickLb.text = @"语音验证码";
        [self.timer invalidate];
        
    } else {
        self.oneLb.text = @"请注意接听电话,";
        self.clickLb.text = [NSString stringWithFormat:@"%ld秒后重试",self.timeCount];
    }
    
    self.timeCount--;
}

- (void)timeStop
{
    [self.timer invalidate];
}

- (void)clickGetCode
{
    [self formDescriptorCellDidSelectedWithFormController:self.formViewController];
}


-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    //    if (self.textField.secureTextEntry) {
    
    //    }
    if (self.rowDescriptor.action.formBlock){
        self.rowDescriptor.action.formBlock(self.rowDescriptor);
    } else if (self.rowDescriptor.action.formSelector){
        [controller performFormSelector:self.rowDescriptor.action.formSelector withObject:self.rowDescriptor];
    }
    else if ([self.rowDescriptor.action.formSegueIdenfifier length] != 0){
        [controller performSegueWithIdentifier:self.rowDescriptor.action.formSegueIdenfifier sender:self.rowDescriptor];
    }
}


@end
