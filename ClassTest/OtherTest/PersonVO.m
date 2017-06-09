//
//  PersonVO.m
//  ClassTest
//
//  Created by xu cuiping on 2017/4/1.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "PersonVO.h"

@implementation PersonVO

-(id)copyWithZone:(NSZone *)zone
{
  PersonVO *person = [[[self class] allocWithZone:zone]init];
   person.address = self.address;
  person.name = self.name;
  return person;
}
@end
