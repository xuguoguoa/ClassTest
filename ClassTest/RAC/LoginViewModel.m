//
//  LoginViewModel.m
//  ClassTest
//
//  Created by 徐翠苹 on 2018/1/5.
//  Copyright © 2018年 hehehe. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)initBind
{
    self.btnEnableSignal = [RACSignal combineLatest:@[RACObserve(self.accountVO, account), RACObserve(self.accountVO, password)] reduce:^id(NSString *account, NSString *pwd){
        return @(account.length && pwd.length);
    }];
    
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"登录成功"];
                [subscriber sendCompleted];
            });
            return nil;
        }];
    }];
}

- (AccountVO *)accountVO
{
    if (!_accountVO) {
        _accountVO = [[AccountVO alloc] init];
    }
    return _accountVO;
}

@end
