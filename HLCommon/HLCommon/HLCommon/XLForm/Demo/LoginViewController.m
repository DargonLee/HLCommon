//
//  LoginViewController.m
//  tokenlender
//
//  Created by Harlan on 2018/8/1.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//

#import "LoginViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "RegisterViewController.h"
#import "ForgetPwdViewController.h"
#import "XLForm.h"
#import "XLFormValidator.h"
#import "LoginHeaderView.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (instancetype)init
{
    return [super initWithForm:[self defaultFromDescriptor]];
}

- (XLFormDescriptor *)defaultFromDescriptor
{
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"登录"];
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
    
    // Password
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPassword rowType:XLFormRowDescriptorTypePassword title:@"密码"];
    [row.cellConfigAtConfigure setObject:@"请输入8-16位密码" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@"密码" forKey:@"titleLabel.text"];
    [row.cellConfigAtConfigure setObject:@NO forKey:@"rightButton.hidden"];
    [row.cellConfigAtConfigure setObject:@16 forKey:@"maxTextLength"];
    row.required = YES;
    [row addValidator:[XLFormValidator passwordValidator]];
    [section addFormRow:row];
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"forgetpassword" rowType:XLFormRowDescriptorTypeRightButton title:@"忘记密码？"];
    row.action.formSelector = @selector(didTouchPasswordButton:);
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
    [footerBtn setTitle:@"登录" forState:UIControlStateNormal];
    footerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footerBtn];
    [footerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(49);
    }];
}

- (void)setupNav
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"没有账号" style:UIBarButtonItemStylePlain target:self action:@selector(noAccountClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma Public Methods
- (void)noAccountClick
{
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)didTouchPasswordButton:(XLFormRowDescriptor *)sender
{
    ForgetPwdViewController *vc = [[ForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma 登录请求
- (void)loginAction
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kLogin];
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

@end
