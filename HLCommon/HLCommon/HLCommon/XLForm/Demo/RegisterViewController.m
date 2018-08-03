//
//  RegisterViewController.m
//  tokenlender
//
//  Created by Harlan on 2018/8/1.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "XLForm.h"
#import "XLFormValidator.h"
#import "LoginHeaderView.h"
#import "TTTAttributedLabel.h"
#import "WebViewController.h"


@interface RegisterViewController () <TTTAttributedLabelDelegate>

@property (strong, nonatomic) TTTAttributedLabel *attributedLabel;

@end

@implementation RegisterViewController


- (instancetype)init
{
    return [super initWithForm:[self defaultFromDescriptor]];
}

- (XLFormDescriptor *)defaultFromDescriptor
{
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"注册"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    formDescriptor.assignFirstResponderOnShow = NO;
    
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    // Phone
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPhone rowType:XLFormRowDescriptorTypePhone title:@"邮箱地址"];
    [row.cellConfigAtConfigure setObject:@"请输入您的邮箱地址" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@"邮箱地址" forKey:@"titleLabel.text"];
    //    [row.cellConfigAtConfigure setObject:@11 forKey:@"maxTextLength"];
    row.required = YES;
    [row addValidator:[XLFormValidator emailValidatorLong]];
    [section addFormRow:row];
    
    // verification code
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kVerifyCode rowType:XLFormRowDescriptorTypeVerificationCode title:@"验证码"];
    [row.cellConfigAtConfigure setObject:@"请输入验证码" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@"验证码" forKey:@"titleLabel.text"];
    [row.cellConfigAtConfigure setObject:@6 forKey:@"maxTextLength"];
    row.required = YES;
    row.action.formSelector = @selector(didTouchVerifyButton:);
    [row addValidator:[XLFormValidator verificationCodeValidator]];
    [section addFormRow:row];
    
    // Password
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPassword rowType:XLFormRowDescriptorTypePassword title:@"密码"];
    [row.cellConfigAtConfigure setObject:@"请设置8-16位的数字和字母组合" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@"密码" forKey:@"titleLabel.text"];
    [row.cellConfigAtConfigure setObject:@NO forKey:@"rightButton.hidden"];
    [row.cellConfigAtConfigure setObject:@16 forKey:@"maxTextLength"];
    row.required = YES;
    [row addValidator:[XLFormValidator passwordValidator]];
    [section addFormRow:row];
    
    return formDescriptor;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNav];
    [self setupFooterView];
}

- (void)setupFooterView
{
    UIButton *footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    footerBtn.backgroundColor = [UIColor colorWithHexStr:@"#3664ED"];
    [footerBtn setTitle:@"注册" forState:UIControlStateNormal];
    footerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footerBtn];
    [footerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(49);
    }];
    [self.view addSubview:self.attributedLabel];
}

- (void)setupNav
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"登录" target:self action:@selector(loginClick)];
}

- (void)loginClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 获取验证码请求
- (void)didTouchVerifyButton:(XLFormRowDescriptor *)sender
{
    XLFormValidationStatus *status = [[self.form formRowWithTag:kPhone] doValidation];
    if (status && !status.isValid) {
        [self showHintBeforeKeyboard:status.msg];
        return;
    }
    
    [self.view endEditing:YES];
    [self showHudInView:self.view hint:@"验证码发送中"];
}

#pragma 注册请求
- (void)registerAction
{
    
}

#pragma 代理
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [LoginHeaderView headerView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150.f;
}


#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    NSString *urlString = [url absoluteString];
    WebViewController *vc = [[WebViewController alloc] init];
    vc.urlStr = urlString;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma lazy
- (TTTAttributedLabel *)attributedLabel {
    if (!_attributedLabel) {
        _attributedLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-156, self.view.frame.size.width, 40)];
        _attributedLabel.delegate = self;
        _attributedLabel.font = [UIFont systemFontOfSize:10.0];
        _attributedLabel.numberOfLines = 0;
        _attributedLabel.lineSpacing = 2;
        _attributedLabel.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0];
        _attributedLabel.textAlignment = NSTextAlignmentCenter;
        _attributedLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _attributedLabel.linkAttributes = @{(NSString *)kCTForegroundColorAttributeName:kBaseThemeMainColor};
        _attributedLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0]};
        
        NSString *title;
        if (self.view.frame.size.width == 320) {
             title = @"注册即代表您同意《XXX用户服务协议》";
        } else {
            title = @"注册即代表您同意《XXX用户服务协议》";
        }
        
        [_attributedLabel setText:title];
        
        NSURL *url1 = [NSURL URLWithString:@"https://cms.xiaoxinyong.com/index.php?m=content&c=index&a=show&catid=7&id=5"];
        
        [_attributedLabel addLinkToURL:url1 withRange:[title rangeOfString:@"《XXX用户服务协议》"]];
    }
    
    return _attributedLabel;
}
@end
