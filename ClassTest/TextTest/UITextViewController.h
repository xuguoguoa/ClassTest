//
//  UITextViewController.h
//  ClassTest
//
//  Created by cuipingxu on 2017/4/13.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textfield;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UITextView *textview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@end
