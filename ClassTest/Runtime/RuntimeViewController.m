//
//  RuntimeViewController.m
//  ClassTest
//
//  Created by cuipingxu on 2017/5/11.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "RuntimeViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface RuntimeViewController ()

@end

@implementation RuntimeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setOSProps];
  
  //运行时创建类
  [self createClass];
  
  [self imp_implementationWithBlock];
  [self classTest];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setOSProps
{
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = @"Runtime Meta Learn";
  self.navigationController.navigationBar.translucent = YES;
}
- (void)createClass
{
  //1. 创建一个Class
  Class MyClass = objc_allocateClassPair([UILabel class],
                                         "myclass",
                                         0);
  
  //2. 添加一个NSString的变量，第四个参数是对其方式，第五个参数是参数类型
  if (class_addIvar(MyClass, "itest", sizeof(NSString *), 0, "@")) {
    NSLog(@"add ivar success");
  }
  
  //3. 添加一个函数
  class_addMethod(MyClass,
                  @selector(report),
                  (IMP)ReportFunction,
                  "v@:");
  
  //4. 注册这个类到runtime系统中就可以使用他了
  objc_registerClassPair(MyClass);
  
  //5. 测试创建的类
  [self test:MyClass];
}
- (void)report {
  //什么都不做，只是为了OC对象能够调用到c函数
}
- (void)test:(Class)class {
  
  //1.
  id obj = [[class alloc] init];
  
  //2.
  [obj report];
}
void ReportFunction(id self, SEL _cmd)
{
  //1. 对象
  NSLog(@"This object is %p.", self);
  
  //2. 对象所属的类
  NSLog(@"Class is %@", [self class]);
  
  //3. 所属类的父类
  NSLog(@"super is %@.",[self superclass]);
  
  //4. 每一个类都有两部分
  //类的第一部分、类本身
  //类的第二部分、元类
  Class currentClass = [self class];
  for (int i = 1; i < 10; i++)//i的次数随便改都可以
  {
    NSLog(@"Following the isa pointer times = %d, ClassValue = %@, ClassAddress = %p", i, currentClass, currentClass);
    
    //通过Class的 isa指针 找到 MetaClass
    currentClass = object_getClass(currentClass);
  }
  
  //5. NSObject类本身
  NSLog(@"NSObject's class is %p", [NSObject class]);
  
  //6. NSObject类的元类
  NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));
}

/**
 方法object_getClass(id obj)会根据 Class的私有成员变量isa指针 找到一个类，有两种情况:
 对象的isa >>> 所属类
 类的isa >>> Meta 类
 Meta类的isa >>> Meta NSObject
 Meta NSObject的isa >>> 永远指向自己，形成环路
 times = 2时、根据myclass->isa指针，找到其对应的 Meta myclass
 times = 3时、根据 Meta myclass->isa 指针，找到了 Meta NSObject
 times = 4，5，6，7，8…、根据 元类NSObject 的 isa指针，最后都是指向自己
 **/
- (void)imp_implementationWithBlock
{
  ///创建一个类
  Class People = objc_allocateClassPair([NSObject class], "People", 0);
  
  ///添加两个变量
  if (class_addIvar(People, "name", sizeof(NSString *), 0, @encode(NSString *))) {
    NSLog(@"add ivar name success");
  }
  if (class_addIvar(People, "age", sizeof(int), 0, @encode(int))) {
    NSLog(@"add ivar age success");
  }
  
  ///创建方法的SEL
  SEL selector = sel_registerName("talk:");
  
  ///创建方法的IMP指针，并指向Block给出的代码
  IMP impl = imp_implementationWithBlock(^(id self, NSString *arg1){
    
    //age变量值
    //通过KVC
    //int age = (int)[[self valueForKey:@"age"] integerValue];
    
    //通过Ivar
    Ivar ageIvar = class_getInstanceVariable([self class], "age");
    int age  = (int)[object_getIvar(self, ageIvar) integerValue];
    
    
    //name变量值
    //通过KVC
    //NSString *name = [self valueForKey:@"name"];
    
    //通过Ivar
    Ivar nameIvar = class_getInstanceVariable([self class], "name");
    NSString *name = object_getIvar(self, nameIvar);
    
    NSLog(@"age = %d, name = %@, msgSay = %@", age, name, arg1);
  });
  
  ///添加一个方法, 将SEL与IMP组装成一个Method结构体实例，添加到Class中的 method_list数组
  class_addMethod(People, selector, impl, "v@:@");
  ///注册这个类到系统
  objc_registerClassPair(People);
  
  ///生成一个实例
  id instanceP = [[People alloc] init];
  
  ///给Ivar赋值
  //通过KVC赋值
  [instanceP setValue:@"变量字符串值" forKey:@"name"];
  //[instanceP setValue:@19 forKey:@"age"];
  
  //通知Ivar赋值
  Ivar ageIvar = class_getInstanceVariable(People, "age");
  object_setIvar(instanceP, ageIvar, @19);
  
  ///发送消息
  ((void (*)(id, SEL, NSString *))(void *) objc_msgSend)(instanceP, selector, @"参数值");
  ///释放对象、销毁类
  instanceP = nil;
  objc_disposeClassPair(People);
}
/**
 方法的编码格式:
 v@: >>> 返回值void，参数1:self,参数2:SEL >>> - (void)funcName;
 v@:@ >>> 返回值void，参数1:self,参数2:SEL, 参数3:NSString >>> - (void)funcName:(NSSring )name;
 对应的Objective-C方法的SEL也应该是 >>> talk:带一个参数
 imp_implementationWithBlock()接收一个添加方法被调用时的回调Block
 其格式为: method_return_type ^(id self, method_args …)
 **/
-(void)classTest
{
  //Class是 objc_class结构体实例的指针变量类型
  //那么+[NSObject class]返回就是一个 objc_class结构体实例
  //而 self 一般是 一个指向对象地址的指针
  //而此时的 self 所代表的就是 NSObject类本身
  NSLog(@"%@", [RuntimeViewController class]);
  //多次输出其地址
  NSLog(@"%p", [self class]);
  NSLog(@"%p", [self class]);
  NSLog(@"%p", [RuntimeViewController class]);
}
@end
