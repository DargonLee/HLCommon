//
//  SpeechCodeCell.h
//  xiaodai
//
//  Created by 稻草人lxh on 2017/6/26.
//  Copyright © 2017年 xiaoxinyong. All rights reserved.
//

#import "XLFormBaseCell.h"

@interface SpeechCodeCell : XLFormBaseCell

- (void)beginCountDown;             //短信验证码
- (void)beginSpeechCountDown;       //语音验证码
- (void)timeStop;                   //停止计时器

@end
