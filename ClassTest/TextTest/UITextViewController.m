//
//  UITextViewController.m
//  ClassTest
//
//  Created by cuipingxu on 2017/4/13.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "UITextViewController.h"

@interface UITextViewController ()

@end

@implementation UITextViewController

-(instancetype)init
{
  self = [super initWithNibName:@"UITextViewController" bundle:nil];
  if(self)
  {
    
  }
  return self;
}
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.label.backgroundColor = [UIColor grayColor];
  NSString *str = @"哈哈哈哈哈哈哈哈哈编号差不多吧触宝电话VB和你几点记不记得不得不独到的凤飞飞飞的凤飞飞事实上还是说说看书看书看书看书看书看哈哈哈哈哈哈哈哈哈编号差不多吧触宝电话VB和你几点记不记得不得不独到的凤飞飞飞的凤飞飞事实上还是说说看书看书看书看书看书看";
  
  self.label.numberOfLines = 0;//label的高度会由字数多少决定
  self.label.text = str;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
