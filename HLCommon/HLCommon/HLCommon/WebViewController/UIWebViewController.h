//
//  UIWebViewController.h
//  tokenlender
//
//  Created by BoyLee on 2018/5/18.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>


@protocol JSConnected <JSExport>

//返回js语言
- (NSString *)getLanguage;
//交易方法
- (void)transactionData:(NSString *)dictStr;
//选择钱包 1xx 2出借
- (void)chooseWallet;
//返回首页
- (void)close;
//获取token
- (NSString *)getToken;
//显示弹屏
- (void)showToast:(NSString *)msg;
//退出登录
- (void)launchLogin;
//返回邮箱地址给H5
- (NSString *)getEmail;
//检测是否有当前钱包
- (NSString *)checkHasCurrentWallet:(NSString *)walletAddress;
//跳转导入钱包
- (void)launchImportWallet;

@end

@interface UIWebViewController : UIViewController


@property (nonatomic, copy) NSString * urlStr;

/**
 加载纯外部链接
 
 @param string URL地址
 */
- (void)loadWebURLSring:(NSString *)string;

/**
 加载本地网页
 
 @param string 本地HTML文件名
 */
- (void)loadWebHTMLSring:(NSString *)string;


@end
