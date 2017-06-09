//
//  childVO.h
//  ClassTest
//
//  Created by cuipingxu on 2017/6/5.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonVO.h"

@interface childVO : PersonVO<NSCopying>

@property(nonatomic, copy) NSString *school;

@property (nonatomic, assign) float  englishScore;

@end
