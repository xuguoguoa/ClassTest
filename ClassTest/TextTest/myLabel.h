//
//  myLabel.h
//  ClassTest
//
//  Created by cuipingxu on 2017/5/5.
//  Copyright © 2017年 yonyou. All rights reserved.
//

//自定义UILable，实现垂直方向上向上，居中，向下对齐，默认是居中对齐
#import <UIKit/UIKit.h>

typedef enum
{
  VerticalAlignmentTop = 0, // default
  VerticalAlignmentMiddle,
  VerticalAlignmentBottom,
} VerticalAlignment;
@interface myLabel : UILabel

@property (nonatomic,assign) VerticalAlignment verticalAlignment;

@end
