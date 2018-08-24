//
//  ScriptMessageHandler.m
//  tokenlender
//
//  Created by DragonLee on 2018/4/20.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import "ScriptMessageHandler.h"
#import "XXYFileCacheManager.h"

@interface ScriptMessageHandler ()

@property (nonatomic, weak) WKWebView * webView;

@end

@implementation ScriptMessageHandler

- (instancetype)initWithWebView:(WKWebView *)webView
{
    if (self == [super init]) {
        self.webView = webView;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"%@",message.body);
    if ([message.name isEqualToString:TransactionFun]) {
        if ([self.delegate respondsToSelector:@selector(pushPayViewControllerWithParams:)]) {
            [self.delegate pushPayViewControllerWithParams:[self stringToDict:message.body]];
        }
    }else if ([message.name isEqualToString:ChooseWalletFun]) {
        if ([self.delegate respondsToSelector:@selector(presentChooseWalletViewController)]) {
            [self.delegate presentChooseWalletViewController];
        }
    }else if ([message.name isEqualToString:GetToekn]) {
        [XXYFileCacheManager saveUserData:message.body forKey:kToken];
    }else if ([message.name isEqualToString:GetLanguage]) {
        [self returnJsValue];
    }
    
}

- (NSDictionary *)stringToDict:(NSString *)string
{
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    return dic;
}

- (NSString *)returnJsValue
{
    return @"en";
}

@end
