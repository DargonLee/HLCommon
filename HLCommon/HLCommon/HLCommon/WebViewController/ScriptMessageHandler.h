//
//  ScriptMessageHandler.h
//  tokenlender
//
//  Created by DragonLee on 2018/4/20.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>

static NSString *TransactionFun = @"transaction";//交易方法
static NSString *ChooseWalletFun = @"chooseWallet";//选择钱包
static NSString *GetToekn = @"getToekn";//获取token
static NSString *GetLanguage = @"getLanguage";//获取token
static NSString *GetClose = @"close";//获取token


@class ScriptMessageHandler;
@protocol ScriptMessageHandlerDelegate <NSObject>

- (void)ethersScriptHandler:(ScriptMessageHandler*)ethersScriptHandler evaluateJavaScript: (NSString*)script;

- (void)pushPayViewControllerWithParams:(NSDictionary *)params;

- (void)presentChooseWalletViewController;

@end

@interface ScriptMessageHandler : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) NSObject<ScriptMessageHandlerDelegate> *delegate;

@end
