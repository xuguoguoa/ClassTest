//
//  ViewController1.m
//  ClassTest
//
//  Created by xu cuiping on 2017/4/26.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "ViewController1.h"
#import "Masonry.h"
#import "WATableViewCell.h"

@interface ViewController1 ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *array1;

@property (nonatomic, strong) NSMutableArray *array2;

@end

@implementation ViewController1

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  UINavigationBar *bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 44.0f)];
  [self.view addSubview:bar];
  [self.view addSubview:self.tableview];
  [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.bottom.mas_equalTo(self.view);
    make.top.mas_equalTo(self.view).offset(64.f);
  }];
  self.array2 = [[NSMutableArray alloc]initWithObjects:@"寻寻觅觅，冷冷清清。凄凄惨惨戚戚，乍暖还寒时候，最难将息，三杯两盏淡酒，怎敌他，晚来风急，雁过也，正伤心，却是旧时相识，满地黄花堆积，憔悴损,寻寻觅觅，冷冷清清。凄凄惨惨戚戚，乍暖还寒时候，最难将息，三杯两盏淡酒，怎敌他，晚来风急，雁过也，正伤心，却是旧时相识，满地黄花堆积，憔悴损如今有谁堪摘，守着窗儿，独自怎生得黑，梧桐更兼细雨，到黄昏，点点滴滴，这次第，怎一个愁字了得", @"李清照",@"如今有谁堪摘，守着窗儿，独自怎生得黑，梧桐更兼细雨，到黄昏，点点滴滴，这次第，怎一个愁字了得",@"薄雾浓云愁永昼，瑞脑消金兽，佳节又重阳，玉枕纱橱，半夜凉初透",@"东篱把酒黄昏，有暗香盈袖",@"莫道不消魂",@"帘卷西风",@"人比黄花瘦",@"临高阁，乱山平野烟光薄",@"烟光薄，栖鸦归后",nil];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

-(UITableView *)tableview
{
  if(!_tableview)
  {
    _tableview = [[UITableView alloc]init];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [_tableview registerNib:[UINib nibWithNibName:@"WATableViewCell" bundle:nil] forCellReuseIdentifier:@"reusecell"];
    _tableview.estimatedRowHeight = 44.0;
    _tableview.rowHeight = UITableViewAutomaticDimension;
  }
  return _tableview;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reusecell"];
  WATableViewCell *tableViewCell = (WATableViewCell *)cell;
  tableViewCell.iImageView.image = [UIImage imageNamed:@"1.png"];
  tableViewCell.label.text = self.array2[indexPath.row];
  return cell;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    
  }];
  UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    
  }];
  UITableViewRowAction *action3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"回复" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    
  }];
  return @[action1, action2, action3];
}
@end
