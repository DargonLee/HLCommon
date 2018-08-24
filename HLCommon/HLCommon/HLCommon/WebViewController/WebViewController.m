//
//  WebViewController.m
//  tokenlender
//
//  Created by DragonLee on 2018/4/18.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import "WebViewController.h"
#import "UIBarButtonItem+Extension.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>
#import "ScriptMessageHandler.h"
#import "PayViewController.h"
#import "XXYFileCacheManager.h"
#import "ChooseWalletViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "XXYUserInfoManager.h"
#import "ImportWalletViewController.h"


static void *WkwebBrowserContext = &WkwebBrowserContext;

@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate,
                                UINavigationControllerDelegate, UINavigationBarDelegate,
                                ScriptMessageHandlerDelegate,ChooseWalletDelegate,
                                PayViewControllerDelegate>

@property (nonatomic, strong) WKWebView * wkWebView;

@property (nonatomic, strong) UIProgressView * progressView;

@property (nonatomic, strong) UIBarButtonItem * closeButtonItem;

@property (nonatomic, strong) UIBarButtonItem * backButtonItem;

@property (nonatomic, strong) NSMutableArray * snapShotsArray;

@property (nonatomic, copy) NSString * postURLString;

@property (nonatomic, copy) NSString * postData;

@property (nonatomic, assign) BOOL needLoadJSPOST;

@property (nonatomic, strong) ScriptMessageHandler *messageHandler;

@end

@implementation WebViewController

//注意，观察的移除
-(void)dealloc
{
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:TransactionFun];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:ChooseWalletFun];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:GetToekn];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:GetLanguage];
    
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.wkWebView.title) {
        [self roadLoadClicked];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNav];
    
    [self setupViews];
    
}

- (void)setupViews
{
    [self.view addSubview:self.wkWebView];
    
    //添加进度条
    [self.view addSubview:self.progressView];
    
    [self loadWebURLSring:self.urlStr];
}

- (void)setupNav
{
//    self.backButtonItem = [UIBarButtonItem itemWithImage:@"blackBack" highImage:@"" target:self action:@selector(back)];
//    [[UIImage imageNamed:@"blackBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
    self.backButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"blackBack"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //添加右边刷新按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(roadLoadClicked)];;
}

- (void)back
{
    if (self.wkWebView.canGoBack) {
        [self.wkWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)roadLoadClicked
{
    [self clearWbCache];
    [self.wkWebView reload];
}

- (void)closeItemClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateNavigationItems
{
//    if (self.wkWebView.canGoBack) {
    self.navigationItem.leftBarButtonItems = @[self.backButtonItem,self.closeButtonItem];
//    }else{
//        self.navigationItem.leftBarButtonItems = @[self.backButtonItem];
//    }
}

#pragma mark - PublicMethes
- (void)loadWebURLSring:(NSString *)string
{
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:string] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [self.wkWebView loadRequest:request];
}

- (void)loadWebHTMLSring:(NSString *)string
{
    NSString * path = [[NSBundle mainBundle]pathForResource:string ofType:@"html"];
    NSString * html = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.wkWebView loadHTMLString:html baseURL:[[NSBundle mainBundle]bundleURL]];
}

- (void)POSTWebURLSring:(NSString *)string postData:(NSString *)postData
{
    self.postURLString = string;
    self.postData = postData;
    self.needLoadJSPOST = YES;
    [self loadWebHTMLSring:string];
}

- (void)postRequestWithJS
{
    // 拼装成调用JavaScript的字符串
    NSString *jscript = [NSString stringWithFormat:@"post('%@',{%@});", self.postURLString, self.postData];
    // 调用JS代码
    [self.wkWebView evaluateJavaScript:jscript completionHandler:^(id object, NSError * _Nullable error) {
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    //开始加载的时候，让加载进度条显示
    self.progressView.hidden = NO;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (self.needLoadJSPOST) {
        // 调用使用JS发送POST请求的方法
        [self postRequestWithJS];
        // 将Flag置为NO（后面就不需要加载了）
        self.needLoadJSPOST = NO;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateNavigationItems];
    
    //设置token
    NSString * str = [XXYFileCacheManager readUserDataForKey:kToken];
    NSString * jsCode = [NSString stringWithFormat:@"window.getToken('%@')",str];
    [self.wkWebView evaluateJavaScript:jsCode completionHandler:^(id result, NSError *error) {
        if (error) {
            NSLog(@"JavaScript Error: %@", error);
        }
    }];
}

//当 WKWebView 总体内存占用过大，页面即将白屏的时候，系统会调用上面的回调函数
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    [self roadLoadClicked];
}

//服务器开始请求的时候调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeFormSubmitted: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeBackForward: {
            break;
        }
        case WKNavigationTypeReload: {
            break;
        }
        case WKNavigationTypeFormResubmitted: {
            break;
        }
        case WKNavigationTypeOther: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        default: {
            break;
        }
    }
    [self updateNavigationItems];
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)clearWbCache
{
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    [[NSURLCache sharedURLCache] setDiskCapacity:0];
//    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}

- (void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request
{
    //    NSLog(@"push with request %@",request);
    NSURLRequest* lastRequest = (NSURLRequest*)[[self.snapShotsArray lastObject] objectForKey:@"request"];
    
    //如果url是很奇怪的就不push
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        //        NSLog(@"about blank!! return");
        return;
    }
    //如果url一样就不进行push
    if ([lastRequest.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
        return;
    }
    UIView* currentSnapShotView = [self.wkWebView snapshotViewAfterScreenUpdates:YES];
    [self.snapShotsArray addObject:
     @{@"request":request,@"snapShotView":currentSnapShotView}];
}
// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"页面加载超时");
}

//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{}

//KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] &&
        object == self.wkWebView)
    {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }else if ([keyPath isEqualToString:@"title"]){
        if (object == self.wkWebView){
            self.navigationItem.title = self.wkWebView.title;
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    // 判断服务器采用的验证方法
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        // 如果没有错误的情况下 创建一个凭证，并使用证书
        if (challenge.previousFailureCount == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }else {
            // 验证失败，取消本次验证
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        
    }
}

#pragma mark WKUIDelegate

// 获取js 里面的提示
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

// js 信息的交流
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 交互。可输入的文本。
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    
    NSData *jsonData = [prompt dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    NSLog(@"%@",dic);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    
}

#pragma mark - ScriptMessageHandlerDelegate
- (void)ethersScriptHandler:(ScriptMessageHandler*)ethersScriptHandler evaluateJavaScript: (NSString*)script
{
    [self.wkWebView evaluateJavaScript:script completionHandler:^(id result, NSError *error) {
        if (error) {
            NSLog(@"JavaScript Error: %@ (%@)", error, script);
        }
    }];
}

#pragma mark - ChooseWalletDelegate
- (void)pushHtmlBorrowPageWithjsCode:(NSString *)jsCode
{
    [self.wkWebView evaluateJavaScript:jsCode completionHandler:^(id result, NSError *error) {
        if (error) {
            NSLog(@"JavaScript Error: %@", error);
        }
    }];
    
}

- (void)pushPayViewControllerWithParams:(NSDictionary *)params
{
    PayViewController * payVC = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
    payVC.dict = params;
    payVC.delegate = self;
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)presentChooseWalletViewController
{
    NSArray *wallets = [[XXYUserInfoManager sharedManager]allUserInfo];
    if (!wallets.count) {
        ImportWalletViewController *vc = [[ImportWalletViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    ChooseWalletViewController * vc = [[ChooseWalletViewController alloc]init];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    vc.delegate = self;
    [self.navigationController presentViewController:vc animated:NO completion:nil];
}

- (void)payViewControllerDissmissWithType:(NSString *)type
{
    NSString * jsCode = @"";
    if ([type isEqualToString:@"1"]) {
        jsCode = [NSString stringWithFormat:@"window.goBorrowLoading('%@')",type];
    }else{
        jsCode = [NSString stringWithFormat:@"window.goIndex('%@')",type];
    }
    [self.wkWebView evaluateJavaScript:jsCode completionHandler:^(id result, NSError *error) {
        if (error) {
            NSLog(@"JavaScript Error: %@", error);
        }
    }];
}

#pragma mark - lazy
- (WKWebView *)wkWebView
{
    if (!_wkWebView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        config.allowsAirPlayForMediaPlayback = YES;
        config.allowsInlineMediaPlayback = YES;
        config.selectionGranularity = YES;
        
        ScriptMessageHandler *messageHandler = [[ScriptMessageHandler alloc] init];
        messageHandler.delegate = self;
        self.messageHandler = messageHandler;
        WKUserContentController *userVC = [[WKUserContentController alloc]init];
        [userVC addScriptMessageHandler:messageHandler name:TransactionFun];
        [userVC addScriptMessageHandler:messageHandler name:ChooseWalletFun];
        [userVC addScriptMessageHandler:messageHandler name:GetToekn];
        [userVC addScriptMessageHandler:messageHandler name:GetLanguage];
        config.suppressesIncrementalRendering = YES;
        config.userContentController = userVC;
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) configuration:config];
        _wkWebView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        [_wkWebView sizeToFit];
        [_wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:WkwebBrowserContext];
        [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _wkWebView;
}
- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 2);
        // 设置进度条的色彩
//        [_progressView setTrackTintColor:];
        _progressView.progressTintColor = [UIColor colorWithHexStr:@"#4C7BFE"];
    }
    return _progressView;
}

- (UIBarButtonItem*)closeButtonItem
{
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClicked)];
    }
    return _closeButtonItem;
}

- (NSMutableArray*)snapShotsArray
{
    if (!_snapShotsArray) {
        _snapShotsArray = [NSMutableArray array];
    }
    return _snapShotsArray;
}


- (NSString *)getLanguage
{
    return [XXYFileCacheManager readUserDataForKey:kLanguage];
}

@end
