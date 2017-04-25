//
//  AFNViewController.m
//  ClassTest
//
//  Created by xu cuiping on 2017/4/5.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "AFNViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"

@interface AFNViewController ()

@property(nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation AFNViewController

-(instancetype)init
{
  if(self = [super init])
  {
    self.manager = [[AFHTTPSessionManager alloc]init];
  }
  return self;
}
- (void)viewDidLoad
{
  [super viewDidLoad];
  UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 30)];
  label.font = [UIFont systemFontOfSize:10];
  label.text = @"如果某一个页面有多个网络请求，假设有三个请求，A、B、C，而且UI里的数据必须等到A、B、C全部完成后刷新后才正确";
  label.numberOfLines = 0;
  [self.view addSubview:label];
  self.view.backgroundColor = [UIColor whiteColor];
  UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, 100, 20)];
  [btn1 setTitle:@"测试" forState:UIControlStateNormal];
  [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [btn1 addTarget:self action:@selector(testSyncRequest) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btn1];
  
  UIButton *btn2 = [[UIButton alloc]init];
  btn2.backgroundColor = [UIColor whiteColor];
  [btn2 setTitle:@"上传" forState:UIControlStateNormal];
  [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [btn2 addTarget:self action:@selector(uploadImage) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btn2];
  [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view).offset(120.f);
    make.top.equalTo(self.view).offset(200.f);
    make.width.mas_equalTo(btn1.frame.size.width/2);
    //make.width.equalTo(btn1).multipliedBy(1/2);
    make.height.equalTo(btn1);
  }];
  
}

-(void)uploadImage
{
  
}

//////////////////////////////////////////////////////////////////
-(void)testSyncRequest
{
  dispatch_group_t group = dispatch_group_create();
  dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self requestA];
  });
  dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self requestB];
  });
  dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self requestC];
  });
  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    //刷新界面
    NSLog(@"三个请求都回来了，阔以刷新了");
  });
}

- (void)requestA
{
  dispatch_semaphore_t sema = dispatch_semaphore_create(0);
  NSString *str = @"http://www.baidu.com";
   [self.manager POST:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    dispatch_semaphore_signal(sema);
     NSLog(@"A请求回来了");
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    dispatch_semaphore_signal(sema);
    NSLog(@"A请求回来了");
  }];
  NSLog(@"A请求发出");
  dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)requestB
{
  dispatch_semaphore_t sema = dispatch_semaphore_create(0);
  NSString *str = @"http://www.baidu.com";
  [self.manager POST:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    dispatch_semaphore_signal(sema);
    NSLog(@"B请求回来了");
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    dispatch_semaphore_signal(sema);
    NSLog(@"B请求回来了");
  }];
  NSLog(@"B请求发出");
  dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)requestC
{
  dispatch_semaphore_t sema = dispatch_semaphore_create(0);
  NSString *str = @"http://www.baidu.com";
  [self.manager POST:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    dispatch_semaphore_signal(sema);
    NSLog(@"C请求回来了");
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    dispatch_semaphore_signal(sema);
    NSLog(@"C请求回来了");
  }];
  NSLog(@"C请求发出");
  dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
