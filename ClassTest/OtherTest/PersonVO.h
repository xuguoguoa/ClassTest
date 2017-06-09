//
//  PersonVO.h
//  ClassTest
//
//  Created by xu cuiping on 2017/4/1.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonVO : NSObject<NSCopying>

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) int number;

@end
