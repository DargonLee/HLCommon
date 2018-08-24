//
//  UIWebViewController.m
//  tokenlender
//
//  Created by BoyLee on 2018/5/18.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import "UIWebViewController.h"

@interface UIWebViewController ()<UIWebViewDelegate,UINavigationControllerDelegate,JSConnected>

@property (nonatomic,strong) UIWebView *webView;
@property (strong, nonatomic) UIBarButtonItem *backButtonItem;
@property (strong, nonatomic) UIBarButtonItem *closeButton;
@property (nonatomic, strong) UIProgressView * progressView;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, weak) JSContext *context;

@end

@implementation UIWebViewController

- (void)dealloc
{
    NSLog(@"UIWebViewController-----dealloc");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self cleanCacheAndCookie];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //替换系统的滑动返回事件
    [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(back)];
    
    [self setupNav];
    
    [self setupViews];
    
}

- (void)setupViews
{
    [self.view addSubview:self.webView];
    
    //添加进度条
    [self.view addSubview:self.progressView];
    
    [self loadWebURLSring:self.urlStr];
}

- (void)setupNav
{
    self.backButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"blackBack"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.closeButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.leftBarButtonItems = @[self.backButtonItem, self.closeButton];
    
}
- (void)popBack
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
    [self.webView removeFromSuperview];
    self.webView = nil;
    [self.timer invalidate];
    self.timer = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
       [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)back
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self popBack];
    }
}

- (void)closeItemClicked
{
    [self popBack];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    [_context setObject:self forKeyedSubscript:@"obj"];
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //添加定时器
    self.progressView.progress = 0;
    self.progressView.hidden = false;
    self.isLoading = YES;
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    }
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setTitle];
    
    self.isLoading = NO;
}

#pragma mark - PublicMethes

- (void)loadWebURLSring:(NSString *)string
{
    NSURL *url = [[NSURL alloc] initWithString:string];
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)loadWebHTMLSring:(NSString *)string
{
    NSLog(@"%@",string);
    NSString * path = [[NSBundle mainBundle]pathForResource:string ofType:@"html"];
    NSString * html = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle]bundleURL]];
}

#pragma mark - CurrentMethes
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"等会吧" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"立即设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:true completion:nil];
}

- (void)timerCallback
{
    if (!self.isLoading) {
        if (self.progressView.progress >= 1) {
            self.progressView.hidden = true;
            [self.timer invalidate];
            self.timer = nil;
        }
        else {
            self.progressView.progress += 0.5;
        }
    }
    else {
        self.progressView.progress += 0.05;
        if (self.progressView.progress >= 0.9) {
            self.progressView.progress = 0.9;
        }
    }
}

- (void)setTitle
{
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title && [title length] > 0) {
        self.title = title;
    }else {
        self.title = @"";
    }
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie
{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

#pragma mark -
#pragma mark - 交互方法

//返回首页
- (void)close
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)launchImportWallet
{
//    ImportWalletViewController * vc = [[ImportWalletViewController alloc]init];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationController pushViewController:vc animated:YES];
//    });
}

//获取token
- (NSString *)getToken
{
    NSString *token = [XXYFileCacheManager readUserDataForKey:kToken];
    return token;
}

//显示提示信息
-(void)showToast:(NSString *)msg
{
    CGFloat y = 0;
    if (kIsIphoneX) {
        y = -(65+44+20);
    }else{
        y = -(65+20);
    }
    UIView *tipView = [[UIView alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, 75)];
    UILabel *label = [[UILabel alloc]initWithFrame:tipView.bounds];;
    label.text = msg;
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [tipView addSubview:label];
    tipView.backgroundColor = [UIColor colorWithHexStr:@"#3664ED"];
    [self.navigationController.navigationBar addSubview:tipView];
    [UIView animateWithDuration:0.25 animations:^{
        tipView.frame = CGRectMake(0, -20, kScreenWidth, 75);
    }];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            tipView.frame = CGRectMake(0, y, kScreenWidth, 75);
        }completion:^(BOOL finished) {
            [tipView removeFromSuperview];
        }];
    });
}

#pragma mark - lazy
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.contentMode = UIViewContentModeScaleAspectFit;
        _webView.backgroundColor = [UIColor colorWithHexStr:@"0xEFEFF4"];
        _webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        _webView.keyboardDisplayRequiresUserAction = false;
        _webView.delegate = self;
        _webView.scalesPageToFit = true;
    }
    return _webView;
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



@end
