//
//  LoginViewController.m
//  ClassTest
//
//  Created by 徐翠苹 on 2018/1/5.
//  Copyright © 2018年 hehehe. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
#import "Masonry.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *accountField;

@property (nonatomic, strong) UITextField *passwordField;

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) LoginViewModel *loginViewModel;

@end

@implementation LoginViewController
- (instancetype)init
{
    if (self = [super init]) {
        _loginViewModel = [[LoginViewModel alloc] init];
        [self bindModel];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)addSubviews
{
    [self.view addSubview:self.accountField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.loginBtn];
    
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(100.0);
        make.width.mas_equalTo(200.0);
        make.height.mas_equalTo(50.0);
    }];
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view);
        make.size.mas_equalTo(self.accountField);
        make.top.mas_equalTo(self.accountField.mas_bottom).offset(20.0);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordField.mas_bottom).offset(20.0);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
}

- (void)bindModel
{
    RAC(self.loginViewModel.accountVO, account) = self.accountField.rac_textSignal;
    RAC(self.loginViewModel.accountVO, password) = self.passwordField.rac_textSignal;
    RAC(self.loginBtn, enabled) = self.loginViewModel.btnEnableSignal;
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.loginViewModel.loginCommand execute:nil];
    }];
}

- (UITextField *)accountField
{
    if (!_accountField) {
        _accountField = [[UITextField alloc] init];
        _accountField.placeholder = @"账号";
    }
    return _accountField;
}

- (UITextField *)passwordField
{
    if (!_passwordField) {
        _passwordField = [[UITextField alloc] init];
        _passwordField.placeholder = @"密码";
    }
    return _passwordField;
}

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
    return _loginBtn;
}
@end
