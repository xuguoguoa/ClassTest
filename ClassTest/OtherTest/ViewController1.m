//
//  ViewController1.m
//  ClassTest
//
//  Created by xu cuiping on 2017/4/26.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "ViewController1.h"

@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self testIsEqual];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

-(void)testIsEqual
{
  NSString *str1 = [[NSString alloc]init];
  str1 = @"skyming";
  NSString *str2 = [NSString stringWithFormat:@"skyming"];
  NSLog(@"str1的地址--%p--str2的地址--%p",str1,str2);
  NSLog(@"== %d",str1 == str2);//0false
  NSLog(@"isEqual--%d",[str1 isEqual:str2]);//1true
  NSLog(@"isEqualToString--%d",[str1 isEqualToString:str2]);//1true
  
  NSObject *objc1 = [[NSObject alloc]init];
  NSObject *objc2 = [[NSObject alloc]init];
  
  NSLog(@"== %d",objc1 == objc2);//0false
  NSLog(@"isEqual%d",[objc1 isEqual:objc2]);//0false
  
}

@end
