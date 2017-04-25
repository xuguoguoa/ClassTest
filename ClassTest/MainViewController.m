//
//  MainViewController.m
//  ClassTest
//
//  Created by xu cuiping on 2017/4/19.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "MainViewController.h"
#import "AuthorityViewController.h"
#import "AFNViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (IBAction)authorityAction:(id)sender
{
  AuthorityViewController *authorityVC = [[AuthorityViewController alloc]init];
  [self.navigationController pushViewController:authorityVC animated:YES];
}

- (IBAction)afnAction:(id)sender {
  AFNViewController *afnVC = [[AFNViewController alloc]init];
  [self.navigationController pushViewController:afnVC animated:YES];
}
@end
