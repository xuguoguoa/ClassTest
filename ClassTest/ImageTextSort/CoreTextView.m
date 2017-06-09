//
//  CoreTextView.m
//  ClassTest
//
//  Created by xu cuiping on 2017/5/8.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "CoreTextView.h"
#import <CoreText/CoreText.h>

@implementation CoreTextView

-(void)drawRect:(CGRect)rect
{
  [super drawRect:rect];
  ///////////////1.以下三句是翻转画布的固定写法
  
  CGContextRef context = UIGraphicsGetCurrentContext();//获取当前绘制上下文
  CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置字形的变换矩阵为不做图形变换
  CGContextTranslateCTM(context, 0, self.bounds.size.height);//平移方法，将画布向上平移一个屏幕高
  CGContextScaleCTM(context, 1.0, -1.0);//缩放方法，x轴缩放系数为1，则不变，y轴缩放系数为-1，则相当于以x轴为轴旋转180度
  
  //  coreText 起初是为OSX设计的，而OSX得坐标原点是左下角，y轴正方向朝上。iOS中坐标原点是左上角，y轴正方向向下。
  //  若不进行坐标转换，则文字从下开始，还是倒着的
  
  
  /////////////2.插入图片
  
  NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:@"这里在测试图文混排，\n我是一个富文本"];
  /*
   设置一个回调结构体，告诉代理该回调那些方法
   */
  CTRunDelegateCallbacks callBacks;//创建一个回调结构体，设置相关参数
  memset(&callBacks,0,sizeof(CTRunDelegateCallbacks));//memset将已开辟内存空间 callbacks 的首 n 个字节的值设为值 0, 相当于对CTRunDelegateCallbacks内存空间初始化
  callBacks.version = kCTRunDelegateVersion1;//设置回调版本，默认这个
  callBacks.getAscent = ascentCallBacks;//设置图片顶部距离基线的距离
  callBacks.getDescent = descentCallBacks;//设置图片底部距离基线的距离
  callBacks.getWidth = widthCallBacks;//设置图片宽度
  /*
   创建一个代理
   */
  NSDictionary * dicPic = @{@"height":@129,@"width":@200};//创建一个图片尺寸的字典，初始化代理对象需要
  CTRunDelegateRef delegate = CTRunDelegateCreate(& callBacks, (__bridge void *)dicPic);//创建代理
  unichar placeHolder = 0xFFFC;//创建空白字符
  NSString * placeHolderStr = [NSString stringWithCharacters:&placeHolder length:1];//已空白字符生成字符串
  NSMutableAttributedString * placeHolderAttrStr = [[NSMutableAttributedString alloc] initWithString:placeHolderStr];//用字符串初始化占位符的富文本
  CFAttributedStringSetAttribute((CFMutableAttributedStringRef)placeHolderAttrStr, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);//给字符串中的范围中字符串设置代理
  CFRelease(delegate);//释放（__bridge进行C与OC数据类型的转换，C为非ARC，需要手动管理）
  [attributeStr insertAttributedString:placeHolderAttrStr atIndex:14];//将占位符插入原富文本
  CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeStr);//一个frame的工厂，负责生成frame
  CGMutablePathRef path = CGPathCreateMutable();//创建绘制区域
  CGPathAddRect(path, NULL, self.bounds);//添加绘制矩形尺寸
  NSInteger length = attributeStr.length;
  CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0,length), path, NULL);//工厂根据绘制区域及富文本（可选范围，多次设置）设置frame
  CTFrameDraw(frame, context);//根据frame绘制这段富文本字符串
  
  UIImage * image = [UIImage imageNamed:@"1.png"];
  CGRect imgFrm = [self calculateImageRectWithFrame:frame];
  CGContextDrawImage(context,imgFrm, image.CGImage);
  CFRelease(frame);
  CFRelease(path);
  CFRelease(frameSetter);
  
}

-(CGRect)calculateImageRectWithFrame:(CTFrameRef)frame
{
  //根据frame获取需要绘制的线的数组
  NSArray * arrLines = (NSArray *)CTFrameGetLines(frame);
  //获取线的数量
  NSInteger count = [arrLines count];
  //建立起点的数组（cgpoint类型为结构体，故用C语言的数组）
  CGPoint points[count];
  //获取起点
  CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points);
  for (int i = 0; i < count; i ++) {//遍历线的数组
    CTLineRef line = (__bridge CTLineRef)arrLines[i];
    NSArray * arrGlyphRun = (NSArray *)CTLineGetGlyphRuns(line);//获取GlyphRun数组（GlyphRun：高效的字符绘制方案）
    for (int j = 0; j < arrGlyphRun.count; j ++) {//遍历CTRun数组
      CTRunRef run = (__bridge CTRunRef)arrGlyphRun[j];//获取CTRun
      NSDictionary * attributes = (NSDictionary *)CTRunGetAttributes(run);//获取CTRun的属性
      CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];//获取代理
      if (delegate == nil) {//非空
        continue;
      }
      NSDictionary * dic = CTRunDelegateGetRefCon(delegate);//判断代理字典
      if (![dic isKindOfClass:[NSDictionary class]]) {
        continue;
      }
      CGPoint point = points[i];//获取一个起点
      CGFloat ascent;//获取上距
      CGFloat descent;//获取下距
      CGRect boundsRun;//创建一个frame
      boundsRun.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
      boundsRun.size.height = ascent + descent;//取得高
      CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);//获取x偏移量
      boundsRun.origin.x = point.x + xOffset;//point是行起点位置，加上每个字的偏移量得到每个字的x
      boundsRun.origin.y = point.y - descent;//计算原点(osx坐标，原点在左下角)
      CGPathRef path = CTFrameGetPath(frame);//获取绘制区域
      CGRect colRect = CGPathGetBoundingBox(path);//获取剪裁区域边框
      CGRect imageBounds = CGRectOffset(boundsRun, colRect.origin.x, colRect.origin.y);
      self.imageRect = imageBounds;
      return imageBounds;
    }
  }
    return CGRectZero;
}

#pragma mark ---CTRUN代理---
static CGFloat ascentCallBacks(void * ref)
{
  //基线为过原点的x轴，ascent即为CTRun顶线距基线的距离，descent即为底线距基线的距离。
  return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"height"] floatValue];
}
static CGFloat descentCallBacks(void * ref)
{
  return 50;
}
static CGFloat widthCallBacks(void * ref)
{
  return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"width"] floatValue];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  UITouch * touch = [touches anyObject];
  CGPoint location = [self systemPointFromScreenPoint:[touch locationInView:self]];
  if ([self checkIsClickOnImgWithPoint:location]) {
    return;
  }
  //[self ClickOnStrWithPoint:location];
}

-(BOOL)checkIsClickOnImgWithPoint:(CGPoint)location
{
  if ([self isFrame:self.imageRect containsPoint:location]) {
    NSLog(@"您点击到了图片");
    return YES;
  }
  return NO;
}

//-(void)ClickOnStrWithPoint:(CGPoint)location
//{
//  NSArray * lines = (NSArray *)CTFrameGetLines(self.data.ctFrame);
//  CFRange ranges[lines.count];
//  CGPoint origins[lines.count];
//  CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), origins);
//  for (int i = 0; i < lines.count; i ++) {
//    CTLineRef line = (__bridge CTLineRef)lines[i];
//    CFRange range = CTLineGetStringRange(line);
//    ranges[i] = range;
//  }
//  for (int i = 0; i < _length; i ++) {
//    long maxLoc;
//    int lineNum;
//    for (int j = 0; j < lines.count; j ++) {
//      CFRange range = ranges[j];
//      maxLoc = range.location + range.length - 1;
//      if (i <= maxLoc) {
//        lineNum = j;
//        break;
//      }
//    }
//    CTLineRef line = (__bridge CTLineRef)lines[lineNum];        CGPoint origin = origins[lineNum];
//    CGRect CTRunFrame = [self frameForCTRunWithIndex:i CTLine:line origin:origin];
//    if ([self isFrame:CTRunFrame containsPoint:location]) {
//      NSLog(@"您点击到了第 %d 个字符，位于第 %d 行，然而他没有响应事件。",i,lineNum + 1);//点击到文字，然而没有响应的处理。可以做其他处理
//      return;
//    }
//  }
//  NSLog(@"您没有点击到文字");
//}

-(BOOL)isIndex:(NSInteger)index inRange:(NSRange)range
{
  if ((index <= range.location + range.length - 1) && (index >= range.location)) {
    return YES;
  }
  return NO;
}

-(CGPoint)systemPointFromScreenPoint:(CGPoint)origin
{
  return CGPointMake(origin.x, self.bounds.size.height - origin.y);
}

-(BOOL)isFrame:(CGRect)frame containsPoint:(CGPoint)point
{
  return CGRectContainsPoint(frame, point);
}

-(CGRect)frameForCTRunWithIndex:(NSInteger)index
                         CTLine:(CTLineRef)line
                         origin:(CGPoint)origin
{
  CGFloat offsetX = CTLineGetOffsetForStringIndex(line, index, NULL);
  CGFloat offsexX2 = CTLineGetOffsetForStringIndex(line, index + 1, NULL);
  offsetX += origin.x;
  offsexX2 += origin.x;
  CGFloat offsetY = origin.y;
  CGFloat lineAscent;
  CGFloat lineDescent;
  NSArray * runs = (__bridge NSArray *)CTLineGetGlyphRuns(line);
  CTRunRef runCurrent;
  for (int k = 0; k < runs.count; k ++) {
    CTRunRef run = (__bridge CTRunRef)runs[k];
    CFRange range = CTRunGetStringRange(run);
    NSRange rangeOC = NSMakeRange(range.location, range.length);
    if ([self isIndex:index inRange:rangeOC]) {
      runCurrent = run;
      break;
    }
  }
  CTRunGetTypographicBounds(runCurrent, CFRangeMake(0, 0), &lineAscent, &lineDescent, NULL);
  CGFloat height = lineAscent + lineDescent;
  return CGRectMake(offsetX, offsetY, offsexX2 - offsetX, height);
}

@end
