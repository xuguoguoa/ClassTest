//
//  WATableViewCell.m
//  ClassTest
//
//  Created by xu cuiping on 2017/4/26.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "WATableViewCell.h"
#import "myLabel.h"

@implementation WATableViewCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  self.label.numberOfLines = 0;
  self.label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
  ((myLabel *)self.label).verticalAlignment = VerticalAlignmentTop;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
}

@end
