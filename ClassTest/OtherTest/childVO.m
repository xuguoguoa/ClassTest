//
//  childVO.m
//  ClassTest
//
//  Created by cuipingxu on 2017/6/5.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "childVO.h"

@implementation childVO

-(id)copyWithZone:(NSZone *)zone
{
  childVO *childvo = [super copyWithZone:zone];
  childvo.school = self.school;
  childvo.englishScore = self.englishScore;
  return childvo;
}
@end
