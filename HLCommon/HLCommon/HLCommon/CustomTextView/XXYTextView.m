//
//  XXYTextView.m
//  tokenlender
//
//  Created by DragonLee on 2018/4/19.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import "XXYTextView.h"

@implementation XXYTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    if ([super init]) {
        self.alwaysBounceVertical = YES;
        self.font = [UIFont systemFontOfSize:15];
        self.placeholderColor = [UIColor colorWithHexStr:@"#B2B2B2"];
        self.layer.borderColor = [UIColor colorWithHexStr:@"#D6D6D6"].CGColor;
        self.layer.borderWidth = 1;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textDidChange
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if(self.hasText) return;
    NSMutableDictionary * atts = [NSMutableDictionary dictionary];
    atts[NSForegroundColorAttributeName] = self.placeholderColor;
    atts[NSFontAttributeName] = self.font;
    [self.placeholder drawInRect:CGRectMake(5, 7, self.width - 14, self.height) withAttributes:atts];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}
@end
