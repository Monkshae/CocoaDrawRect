//
//  MyView.m
//  CocoaDrawRect
//
//  Created by Mabye on 13-12-17.
//  Copyright (c) 2013年 Maybe. All rights reserved.
//




#import "MyView.h"
#import <CoreText/CoreText.h>
#define pi 3.14159265359
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)



//#import <QuartzCore/QuartzCore.h>
//#define SquareWithNoFrame          1
//#define SquareWithFrame            2
//#define line                       3
//#define word                       4
//#define SquareWithBackgroundColor  5
//#define oval                       6   //椭圆
//#define Arcs                       7   //画弧
//#define dash                       8   //虚线
//#define Curves                      9   //曲线
#define Shadow                      10   //曲线


//贝塞尔曲线
//#define BezierPath                      11   //五角星
//#define PathWithRect                    12   //矩形
//#define PathWithArcCenter               13 //圆弧
//#define QuadCurve                       14//二次曲线
#define ThirdCurve                      15//三次曲线
@implementation MyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //[self drawline];
    //[self drawSimpleGraph];
    [self drawBezierPath];
}

- (void)drawSimpleGraph
{
    CGContextRef context = UIGraphicsGetCurrentContext();
#ifdef SquareWithNoFrame
    CGContextSetRGBFillColor(context, 0, 0.25, 0.25, 1);
    CGContextFillRect(context, CGRectMake(2, 2, 270, 270));
    CGContextStrokePath(context);
#elif SquareWithFrame
    CGContextSetRGBStrokeColor(context, 1, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextAddRect(context, CGRectMake(2, 2, 270, 270));
    CGContextStrokePath(context);
#elif  line
    CGContextSetRGBStrokeColor(context, 0.2, 0.8, 0.8, 1);//线条颜色
    CGContextMoveToPoint(context, 20, 20);
    CGContextAddLineToPoint(context, 200,20);
    CGContextStrokePath(context);
#elif  word
    
//    CGContextSetLineWidth(context, 320); //这句对于绘制文字似乎没有用
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    UIFont *font = [UIFont boldSystemFontOfSize:20];
    [@"冰美人" drawInRect:CGRectMake(40, 40, 80, 40) withFont:font];//width和height没有用，方法废弃了
    //ios7用的方法
    NSString *fontName = [[UIFont familyNames] objectAtIndex:1];
    NSMutableDictionary *fontAttributes = [[NSMutableDictionary alloc] init];
    [fontAttributes setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    [fontAttributes setObject:[UIFont fontWithName:fontName size:20] forKey:NSFontAttributeName];
    [@"美人鱼" drawWithRect:CGRectMake(40, 150, 80, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontAttributes context:nil];
//画矩形的背景色
#elif  SquareWithBackgroundColor
    //三种矩阵坐标变换
    /*①*/
   #if 0
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0.0f, -self.bounds.size.height);
    /*②*/
    CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
   #else
    /*③*/
    CGContextConcatCTM(context, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1, -1));
   #endif
    UIGraphicsPushContext(context);
    CGContextSetLineWidth(context, 20);
    CGContextSetRGBStrokeColor(context, 1, 1, 0.8, 1);
    CGContextStrokeRect(context, CGRectMake(20, 20, 20, 40));
    UIGraphicsPopContext();
    
#elif oval
    CGRect aRect = CGRectMake(80,80,160,100);
    CGContextSetRGBStrokeColor(context, 0.6, .9, 0, 1);
    CGContextSetRGBFillColor(context, .3, .5, .8, 1);
    CGContextSetLineWidth(context, 3);
    CGContextAddEllipseInRect(context, aRect); //椭圆
    CGContextDrawPath(context, kCGPathFillStroke);
    
#elif Arcs

    //实现逐变颜色填充方法
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        204.0/255.0, 224.0/255.0, 244.0/255.0, 1.00,
        29.0/255.0, 156.0/255.0, 215.0/255.0, 1.00,
        0.0/255.0,  50.0/255.0, 126.0/255.0, 1.00,
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents
    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient,CGPointMake
                                (0.0,0.0) ,CGPointMake(0.0,self.frame.size.height),
                                kCGGradientDrawsBeforeStartLocation);
    
    
    
    
    //弧线
    /* void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)
     x,y为圆心坐标，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针
     */
    CGContextSetRGBStrokeColor(context, .3, .6, .4, 1);
    CGContextAddArc(context, 100, 100, 50, M_PI, M_PI_2, 0);
    CGContextStrokePath(context);
    
    /*
     首先使用该函数绘制圆弧前，首先要确定一个start point.
     CGContextMoveToPoint(context, 100, 100);
     然后设置CGContextAddArcToPoint(context, 50, 100, 50, 150, 50);
     这里是从起始点100,100开始到第一个点50,100画一条线段，然后再从第一个点50,100到第二点150,50画另一条线段（这是两条相交切线），然后设置半径为50.通过相交的两条线段和半径就可以确定圆弧了
     CGContextAddArcToPoint(<#CGContextRef c#>, <#CGFloat x1#>, <#CGFloat y1#>, <#CGFloat x2#>, <#CGFloat y2#>, <#CGFloat radius#>)
     */

    // CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);
    CGContextMoveToPoint(context,100,100);
    CGContextAddLineToPoint(context,50,100);
    CGContextAddLineToPoint(context,50,150);
    CGContextMoveToPoint(context, 100, 100);
    CGContextAddArcToPoint(context, 50, 100, 50, 150, 50); //要算好半径，不然会多出一条线
    // CGContextClosePath(context);
    CGContextStrokePath(context);
    
#elif dash
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    float lengths[]={10,10};
    CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context, 100, 100);
    CGContextAddLineToPoint(context, 200,200);
    CGContextSetLineDash (context,0,lengths,2);
   // CGContextClosePath(context);
    CGContextStrokePath(context);
#elif Curves
    
  #if 0
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
    CGContextMoveToPoint(context, 10, 10);
    CGContextAddCurveToPoint(context, 300, 50, 50, 250, 300, 300);
    CGContextStrokePath(context);
  #else
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor magentaColor].CGColor);
    CGContextMoveToPoint(context, 10, 200);
    CGContextAddQuadCurveToPoint(context, 150, 10, 300, 200);
    CGContextStrokePath(context);
  #endif
    
#elif Shadow
    
   //画阴影
    UIImage *image =[UIImage imageNamed:@"1.png"];
    CGRect  imageRect = CGRectMake(50, 50, 66, 66);
    CGSize  myShadowOffset = CGSizeMake (-15,  20);
//    UIColor * aColor = [UIColor colorWithRed:0.2 green:.0 blue:.5 alpha:1];
//    CGContextSetFillColorWithColor(context, aColor.CGColor);
//    CGContextFillRect(context, imageRect);
    /* x偏移值，用于指定阴影相对于图片在水平方向上的偏移值。
       y偏移值，用于指定阴影相对于图片在竖直方向上的偏移值。
       模糊(blur)值，用于指定图像是有一个硬边(hard edge)，还是一个漫射边(diffuse edge)
    */
    CGContextSetShadow (context, myShadowOffset, 5);
    CGContextSetShadowWithColor(context, myShadowOffset, 10, [UIColor blackColor].CGColor);
    //设置阴影
    [image drawInRect:imageRect blendMode:kCGBlendModeSourceAtop alpha:1.0f];
    
#endif
}



//自定义字符串绘制
 - (void)drawCustomString
{
    NSString *fontName = @"";
    fontName = [[UIFont familyNames] objectAtIndex:0];
    NSString *string = @"Core Graphics Core Graphics Core Graphics Core Graphics Core GraphicsCore Graphics Core Graphics Core Graphics Core Graphics Core Graphics Core Graphics Core Graphics Core Graphics Core Graphics Core Graphics";
    NSMutableDictionary *fontAttributes = [[NSMutableDictionary alloc] init];
    [fontAttributes setObject:[UIFont fontWithName:fontName size:20] forKey:NSFontAttributeName];
    [fontAttributes setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    
    //设置字体间距
    long number = 4;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
    //[string addAttribute:(id)kCTKernAttributeName value:(id)num range:NSMakeRange(0, [string length])];
    [fontAttributes setObject:(__bridge id)num forKey:NSKernAttributeName];
    CFRelease(num);
    
    NSMutableParagraphStyle *ps = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [ps setLineBreakMode:NSLineBreakByWordWrapping];
    [ps setAlignment:NSTextAlignmentJustified];
    [ps setFirstLineHeadIndent:40];//首行缩进
    [ps setParagraphSpacing:20];  //端
    [ps setLineSpacing:10];
    [fontAttributes setObject: (id)ps forKey:NSParagraphStyleAttributeName];
    //可以绘制多行
    [string drawWithRect:self.bounds options:NSStringDrawingUsesLineFragmentOrigin attributes:fontAttributes context:nil];
    //只是绘制一行
    [string drawAtPoint:CGPointMake(30.0f, 400.0f) withAttributes:fontAttributes];

}




//2种划线的方法
- (void)drawline
{
#if 0
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 20, 20);
    CGPoint aPoints[5];
    aPoints[0] =CGPointMake(60, 60);
    aPoints[1] =CGPointMake(260, 60);
    aPoints[2] =CGPointMake(260, 300);
    aPoints[3] =CGPointMake(60, 300);
    aPoints[4] =CGPointMake(60, 60);
    CGContextAddLines(context, aPoints, 5);
    //设置画笔线条粗细
    CGContextSetLineWidth(context, 1.0);
    //设置设置线条终点形状
    CGContextSetLineCap(context, kCGLineCapSquare);
    //4种设置画笔颜色和填充色
  #if 1
    /*①*/
    CGContextSetRGBStrokeColor(context, .8f, .8f, .8f, 1);
    CGContextSetRGBFillColor(context, .3, .4, .5, 1);
  #else
    /*②*///这是UIKit，使用UIKit不需要获取上下文
    [[UIColor redColor] setFill];
    [[UIColor purpleColor] setStroke];
    /*③*/
    CGContextSetStrokeColorWithColor(context, [UIColor magentaColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor  redColor].CGColor);
    /*④*/
    UIColor * aColor = [UIColor colorWithRed:0.2 green:1.0 blue:0 alpha:1];
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);
    UIColor * bColor = [UIColor colorWithRed:0.8 green:1.0 blue:0.3 alpha:1];
    CGContextSetFillColorWithColor(context, bColor.CGColor);
#endif
    //画点连线
    CGContextAddLines(context, aPoints, 5);
    //取消防锯齿
    CGContextSetAllowsAntialiasing(context, NO);
    CGContextClosePath(context);
    //执行绘画
    CGContextDrawPath(context, kCGPathFillStroke);


#else
    CGFloat xOffset=self.bounds.size.width/10;
    CGFloat yOffset=self.bounds.size.height/3;
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, self.bounds.size.height);
    CGContextAddLineToPoint(context, xOffset*1,yOffset*1);
    CGContextAddLineToPoint(context, xOffset*2,yOffset*2);
    CGContextAddLineToPoint(context, xOffset*3,yOffset*1);
    CGContextAddLineToPoint(context, xOffset*4,yOffset*2);
    CGContextAddLineToPoint(context, xOffset*5,yOffset*1);
    CGContextAddLineToPoint(context, xOffset*6,yOffset*2);
    CGContextAddLineToPoint(context, xOffset*7,yOffset*1);
    CGContextAddLineToPoint(context, xOffset*8,yOffset*2);
    CGContextAddLineToPoint(context, xOffset*9,yOffset*1);
    [[UIColor greenColor] setStroke];
    //CGContextDrawPath(context, kCGPathStroke);//画矩形
    CGContextDrawPath(context, kCGPathFillStroke);//画带了填充色的矩形

    
    CGContextSetStrokeColorWithColor(context, [UIColor magentaColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor  redColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, 10, 10);
    CGContextAddLineToPoint(context, 10, 100);
    CGContextAddLineToPoint(context, 100, 100);
    CGContextAddLineToPoint(context, 100, 10);
    CGContextAddLineToPoint(context, 10, 10);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    //CGContextDrawPath(context, kCGPathFillStroke);
    
    
#endif

}

- (void)drawBezierPath
{
#if BezierPath
    UIColor *color = [UIColor redColor];
    [color set]; //设置线条颜色
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    // Set the starting point of the shape.
    [aPath moveToPoint:CGPointMake(100.0+10, 0.0+10)];
    
    // Draw the lines
    [aPath addLineToPoint:CGPointMake(200.0+10, 40.0+10)];
    [aPath addLineToPoint:CGPointMake(160+10, 140+10)];
    [aPath addLineToPoint:CGPointMake(40.0+10, 140+10)];
    [aPath addLineToPoint:CGPointMake(0.0+10, 40.0+10)];
    [aPath closePath];//第五条线通过调用closePath方法得到的
    
    [aPath stroke];//Draws line 根据坐标点连线
    //[aPath fill];
#elif PathWithRect
    
    UIColor *color = [UIColor redColor];
    [color set]; //设置线条颜色
    UIBezierPath* aPath = [UIBezierPath bezierPathWithRect:CGRectMake(20, 20, 100, 50)];
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [aPath stroke];
#elif PathWithArcCenter
    
    UIColor *color = [UIColor redColor];
    [color set]; //设置线条颜色
    //其中的参数分别指定：这段圆弧的中心，半径，开始角度，结束角度，是否顺时针方向
    UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 150)
                                                         radius:75
                                                     startAngle:0
                                                       endAngle:DEGREES_TO_RADIANS(135)
                                                      clockwise:YES];
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [aPath stroke];
#elif QuadCurve
    UIColor *color = [UIColor redColor];
    [color set]; //设置线条颜色
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [aPath moveToPoint:CGPointMake(20, 100)];
    
    [aPath addQuadCurveToPoint:CGPointMake(120, 100) controlPoint:CGPointMake(70, 0)];
    [aPath stroke];
  
#elif ThirdCurve
//    UIColor *color = [UIColor redColor];
//    [color set]; //设置线条颜色
//    
//    UIBezierPath* aPath = [UIBezierPath bezierPath];
//    
//    aPath.lineWidth = 5.0;
//    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
//    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
//    
//    [aPath moveToPoint:CGPointMake(20, 50)];
//    
//    [aPath addCurveToPoint:CGPointMake(200, 50) controlPoint1:CGPointMake(110, 0) controlPoint2:CGPointMake(110, 100)];
//    
//    [aPath stroke];
    
    
 //椭圆绘制
    // Create an oval shape to draw.
    UIBezierPath* aPath = [UIBezierPath bezierPathWithOvalInRect:
                           CGRectMake(0, 0, 200, 100)];
    
    // Set the render colors
    [[UIColor blackColor] setStroke];
    [[UIColor redColor] setFill];
    
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    
    // If you have content to draw after the shape,
    // save the current state before changing the transform
    //CGContextSaveGState(aRef);
    
    // Adjust the view's origin temporarily. The oval is
    // now drawn relative to the new origin point.
    CGContextTranslateCTM(aRef, 50, 50);
    
    // Adjust the drawing options as needed.
    aPath.lineWidth = 5;
    
    // Fill the path before stroking it so that the fill
    // color does not obscure the stroked line.
    [aPath fill];
    [aPath stroke];
    
    // Restore the graphics state before drawing any other content.
    //CGContextRestoreGState(aRef);
    
    
    
    
#endif
}

@end
