//
//  LoginViewModel.h
//  ClassTest
//
//  Created by 徐翠苹 on 2018/1/5.
//  Copyright © 2018年 hehehe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "AccountVO.h"

@interface LoginViewModel : NSObject

@property (nonatomic, strong) AccountVO *accountVO;

@property (nonatomic, strong) RACCommand *loginCommand;

@property (nonatomic, strong) RACSignal *btnEnableSignal;

@end
