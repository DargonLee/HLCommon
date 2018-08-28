/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

static MBProgressHUD * instance_hud;

@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD {
    return instance_hud;
    //    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD {
    
    instance_hud = HUD;
    //    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.removeFromSuperViewOnHide = YES;
    HUD.label.text = hint;
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    [self setHUD:HUD];
}

- (void)showHint:(NSString *)hint
{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = hint;
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    hud.margin = 10.f;
    hud.offset = CGPointMake(0, view.center.y - 90);
    [hud hideAnimated:YES afterDelay:3.0f];
}

- (void)showHintBeforeKeyboard:(NSString *)hint {
    UIView *tempKeyboardWindow = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:tempKeyboardWindow animated:YES];
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    //    hud.yOffset = 200.f;
    //    hud.yOffset = tempKeyboardWindow.center.y - 90;
    
    [hud hideAnimated:YES afterDelay:2.0f];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset
{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    hud.offset = CGPointMake(0, yOffset);
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES afterDelay:2.0f];
}

- (void)showHint:(NSString *)hint hideDelay:(float)delay
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    //    hud.yOffset = view.center.y - 90;
    //    hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    [hud hideAnimated:YES afterDelay:delay];
}

- (void)showLoadingWithText:(NSString *)hint
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    view.userInteractionEnabled = NO;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = hint;
    hud.margin = 10.f;
    //    hud.yOffset = view.center.y - 90;
    //    hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    [self setHUD:hud];
}

- (void)hideHud
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view = [[UIApplication sharedApplication].delegate window];
        view.userInteractionEnabled = YES;
        [[self HUD] hideAnimated:YES];
        [[self HUD] removeFromSuperViewOnHide];
        [[self HUD] removeFromSuperview];
        [[self HUD] setHidden:YES];
    });
}

@end
