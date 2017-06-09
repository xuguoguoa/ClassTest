//
//  ViewController.m
//  ClassTest
//
//  Created by xu cuiping on 2017/3/1.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "PersonVO.h"


@interface ViewController ()
@property(nonatomic, strong) NSString *ihehe;

@property (nonatomic, strong) CALayer *mylayer;

@property (nonatomic, strong) NSMutableArray *colorArray;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //测试synchronized
  [NSThread detachNewThreadSelector:@selector(testSynchronized:) toTarget:self withObject:@"线程1"];
  [NSThread detachNewThreadSelector:@selector(testSynchronized1:) toTarget:self withObject:@"线程2"];
  [self testSynchronized:@"1"];
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    @synchronized (self)
    {
      sleep(5.0);
      NSLog(@"%@", @"1");
    };
  });
  [self testSynchronized1:@"2"];
//  测试NSTimer
  NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
  [formatter setDateFormat:@"yyyy-MM-dd HH:ss:mm"];
  NSString *currentTime = [formatter stringFromDate:[NSDate date]];
  NSLog(@"%@", [NSString stringWithFormat:@"当前时间%@",currentTime]);
  [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
    NSString *otherTime = [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@", otherTime);
  }];
  //测试动画
  [self testAnimated];
  
  ///测试排序
  [self sortArray];
  [self sortDictionary];
}

-(void)sortArray
{
  PersonVO *person1 = [[PersonVO alloc]init];
  person1.name = @"apple";
  person1.number = 3;
  PersonVO *person2 = [[PersonVO alloc]init];
  person2.name = @"orange";
  person2.number = 2;
  PersonVO *person3 = [[PersonVO alloc]init];
  person3.name = @"pear";
  person3.number = 1;
  NSArray *array = @[person1, person2,person3];
  [array sortedArrayUsingComparator:^NSComparisonResult(PersonVO* obj1, PersonVO* obj2) {
    if(obj1.number > obj2.number)
    {
      return NSOrderedDescending;
    }
    else if(obj1.number < obj2.number)
    {
      return NSOrderedAscending;
    }
    else
    {
      return NSOrderedSame;
    }
  }];
  [array enumerateObjectsUsingBlock:^(PersonVO *person, NSUInteger idx, BOOL * _Nonnull stop) {
    NSLog(@"%@",person.name);
  }];
}

-(void)sortDictionary
{
  NSDictionary *dic = @{@"wple":@"3",@"orange":@"2",@"asear":@"1"};
  [dic keysSortedByValueUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
    //return [obj1 localizedCompare:obj2];
    if([obj1 intValue] > [obj2 intValue])
    {
      return NSOrderedDescending;
    }
    else if([obj1 intValue] < [obj2 intValue])
    {
      return NSOrderedAscending;
    }
    else
    {
      return NSOrderedSame;
    }
  }];
  [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    NSLog(@"%@",obj);
  }];
}
-(void)testSynchronized:(NSString *)str
{
  NSLog(@"进入testSynchronized");
  @synchronized (self)
  {
    //[self testSynchronized1:@"2"];
    sleep(5.0);
    NSLog(@"%@", str);
  };
}
-(void)testSynchronized1:(NSString *)str
{
  NSLog(@"进入testSynchronized1");
  @synchronized (self)
  {
    sleep(3.0);
    NSLog(@"%@", str);
  };
}
-(void)testAnimated
{
  CALayer *myLayer = [CALayer layer];
  self.mylayer = myLayer;
  //设置大小
  [myLayer setBounds:CGRectMake(0, 0, 100, 100)];
  //设置背景颜色
  [myLayer setBackgroundColor:[UIColor redColor].CGColor];
  [myLayer setPosition:CGPointMake(50, 50)];
  [self.view.layer addSublayer:myLayer];
  self.colorArray = [NSMutableArray arrayWithObjects:[UIColor redColor],[UIColor blackColor],[UIColor orangeColor], nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = touches.anyObject;
  CGPoint location = [touch locationInView:self.view];
  //关闭动画
      [CATransaction begin];
  //关闭隐式动画，也一定要写在改变layer属性钱
      //[CATransaction setDisableActions:YES];
  //这句话一定要写在改变layer属性前
  [CATransaction setAnimationDuration:5.0f];
  //也是一定要写在layer属性前面
  [CATransaction setCompletionBlock:^{
    //rotate the layer 90 degrees
    CGAffineTransform transform = self.mylayer.affineTransform;
    transform = CGAffineTransformRotate(transform, M_PI_2);
    self.mylayer.affineTransform = transform;
  }];
  //位置
  [self.mylayer setPosition:location];
  //颜色
  NSInteger r1 = arc4random_uniform(self.colorArray.count);
  [self.mylayer setBackgroundColor:[self.colorArray[r1] CGColor]];
  //透明度
  CGFloat alpha = (arc4random_uniform(5) + 1.0) / 10.0 + 0.5;
  [self.mylayer setOpacity:alpha];
  //尺寸
  NSInteger size = arc4random_uniform(50) + 51;
  [self.mylayer setBounds:CGRectMake(0, 0, size, size)];
  //圆角
  NSInteger r2 = arc4random_uniform(30);
  [self.mylayer setCornerRadius:r2];
  //旋转角度
  CGFloat angle = arc4random_uniform(180) /180.0 * M_PI;
  [self.mylayer setTransform:CATransform3DMakeRotation(angle, 0, 0, 1)];
  
[CATransaction commit];
  //设置content
  //NSInteger r3 = arc4random_uniform(self.imageArray.count);
  //UIImage *image = self.imageArray[r3];
  //[self.mylayer setContents:(id)image.CGImage];
}
-(void)touchBtn
{
  CALayer *myLayer = [CALayer layer];
  //设置大小
  [myLayer setBounds:CGRectMake(0, 0, 100, 100)];
  //设置背景颜色
  [myLayer setBackgroundColor:[UIColor redColor].CGColor];
  [myLayer setPosition:CGPointMake(200, 200)];
  [self.view.layer addSublayer:myLayer];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

+(void)classMethod2
{
  
}

+(void)classMethod1
{
  [self classMethod2];
}

//在串行队列里，同步添加任务，造成死锁
-(void)testBlock
{
  dispatch_queue_t q = dispatch_queue_create("cn.gcd.gcddemo", DISPATCH_QUEUE_SERIAL);
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    dispatch_async(q, ^{
      NSLog(@"1");
      dispatch_sync(q, ^{
        NSLog(@"2");
      });
      NSLog(@"3");
    });
    NSLog(@"4");
  });
}


//向一个已存在的类中添加属性变量
-(void)testAddPropertyAndIVar
{
  //添加属性
  objc_property_attribute_t type = {"T", "@\"NSString\"" };
  objc_property_attribute_t ownership = {"C", ""}; // C = copy &:retain strong W:weak 默认为assign
  objc_property_attribute_t nonatomic = {"N", ""};//N:nonatomic 默认为atomic
  objc_property_attribute_t backingivar  = {"V", "_Name"};//属性对应的实例变量
  objc_property_attribute_t attrs[] = { type, ownership, nonatomic,backingivar };
  class_addProperty([self class], "name", attrs, 3);
  //添加实例变量nonatomic
  class_addIvar(self.class, "address", sizeof(NSString *), 0, "@");
  
  //打印属性
  unsigned int count;
  objc_property_t *propertys = class_copyPropertyList(self.class, &count);
  for (int i = 0; i < count; i++)
  {
    objc_property_t property = propertys[i];
    fprintf(stdout, "property: %s %s\n", property_getName(property), property_getAttributes(property));
  }
  free(propertys);
  
  //打印实例变量
  unsigned int ivarCount;
  Ivar *ivars = class_copyIvarList(self.class, &ivarCount);
  for(int i=0; i<ivarCount; i++)
  {
    Ivar ivar = ivars[i];
    fprintf(stdout, "ivar: %s\n", ivar_getName(ivar));
  }
  free(ivars);
}

-(void)testIsEqual
{
  NSString *str1 = [[NSString alloc]init];
  str1 = @"skyming";
  NSString *str2 = [NSString stringWithFormat:@"skyming"];
  NSLog(@"str1的地址--%p--str2的地址--%p",str1,str2);
  NSLog(@"== %d",str1 == str2);//0false
  NSLog(@"isEqual--%d",[str1 isEqual:str2]);//1true
  NSLog(@"isEqualToString--%d",[str1 isEqualToString:str2]);//1true
  
  NSObject *objc1 = [[NSObject alloc]init];
  NSObject *objc2 = [[NSObject alloc]init];
  
  NSLog(@"== %d",objc1 == objc2);//0false
  NSLog(@"isEqual%d",[objc1 isEqual:objc2]);//0false
  
}

-(void)testJson
{
  NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
  [dic setObject:@"xucp" forKey:@"name"];
  [dic setObject:@"haha" forKey:@"happy"];
  [dic setObject:@"jj" forKey:@"ll"];
  [dic setObject:@[@1,@2,@3] forKey:@"kkk"];
  NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
  NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
  //str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  NSLog(str);
}

@end
