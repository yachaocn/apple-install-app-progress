//
//  CircleProgressView.m
//  CircleProgress
//
//  Created by yachaocn on 16/8/8.
//  Copyright © 2016年 yachaocn. All rights reserved.
//
#define YCColorMaker(r, g, b, a) [UIColor colorWithRed:((r)/255) green:((g)/255) blue:((b)/255) alpha:(a)]
#import <Foundation/Foundation.h>
#import "CircleProgressView.h"
@interface CircleProgressView ()

@property(nonatomic) BOOL beginCompletedAnimation;
@property(nonatomic) CGFloat margin;//两个圆半径差
@property(nonatomic) CGFloat R1;//大圆半径
@property(nonatomic) CGFloat R2;//小圆半径
@property(nonatomic)CGFloat pauseR;//暂停时添加的小圆半径
@property(nonatomic) CGFloat MaxR;//进度完成后最大的扩散半径（斜对角线的一半）
//扩散动画的定时器
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation CircleProgressView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
      
        _pauseR = 18;
        self.progress = 0.0001;
        _margin = 4.0f;
        _R2 = 25;
        _R1 = _R2 + _margin;
        
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        CGFloat MaxR = sqrt(pow(width, 2) + pow(height, 2));
        _MaxR = MaxR;
        
        self.userInteractionEnabled = YES;
        [self addTarget:self action:@selector(clickedProgressView:) forControlEvents:UIControlEventTouchUpInside];
        self.selected = NO;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
    }
    return self;
}
//点击暂停－开始
-(void)clickedProgressView:(UIControl *)control
{
    if (!self.delegate) {
        return;
    }
    self.selected = !control.selected;
    if (self.selected) {
        [self.delegate pause:self.progress];
    }else{
        [self.delegate active:self.progress];
    }
     [self setNeedsDisplay];
    
}
//Progress set modth
-(void)setProgress:(CGFloat)progress
{
    if (_progress != progress) {
        _progress = MIN(1.0, fabs(progress));
        [self setNeedsDisplay];
    }
//    开始扩散动画
    if (_progress == 1.0) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
          
            [self performAnimation];

        });
    }
}
//启动定时器，绘制扩散动画。
-(void)performAnimation
{
    if (_R1 > _MaxR) {
        return;
    }
     _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animate:) userInfo:nil repeats:YES];
}
-(void)animate:(NSTimer *)sender
{
    if (_R1 <= _MaxR) {
        [self setNeedsDisplay];
    }else{
        [_timer invalidate];
        _timer =nil;
    }
}

-(void)drawRect:(CGRect)rect
{
//    得到视图的宽度
    CGFloat width = rect.size.width;
//    得到视图的高度
    CGFloat height = rect.size.height;
//    计算圆心
    CGFloat centerX = width/2;
    CGFloat centerY = height/2;
//    得到绘图上下文
    CGContextRef context =  UIGraphicsGetCurrentContext();
//    设置颜色
    CGContextSetRGBFillColor(context, 0, 0, 0, 0.5);
    
//    绘制矩形
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddRect(context, rect);
//    绘制大圆
    CGContextMoveToPoint(context, centerX, centerY);
    if (self.progress < 1.0) {
        CGContextAddArc(context, centerX, centerY, _R1, -M_PI_2, -M_PI_2 + M_PI*2, 0);
    }else{
        _R1 +=1;
        CGContextAddArc(context, centerX, centerY, _R1, -M_PI_2, -M_PI_2 + M_PI*2, 0);
    }
//    绘制小圆
    CGContextMoveToPoint(context, centerX, centerY);
//    参数一：绘图上下文；参数二：绘图圆心；参数三：起始角度；参数四，结束角度；参数五：绘制方向（1:顺时针，0:逆时针）
    CGContextAddArc(context, centerX, centerY, _R2, -M_PI_2, -M_PI_2 + M_PI*2*self.progress, 1);

    //暂停
    if (self.isSelected) {
    
         CGContextMoveToPoint(context, centerX, centerY);
        CGContextAddArc(context, centerX, centerY, _pauseR, -M_PI_2 +self.progress *M_PI*2, -M_PI_2, 1);
//        暂停开始点1
        CGFloat pasueX1 = centerX - _pauseR/4 - 2;
        CGFloat pasueY1 = centerY - _pauseR/4;
        CGRect pasueFrame1 = CGRectMake(pasueX1, pasueY1, 4, 12);
//        暂停开始点2
        CGFloat pasueX2 = centerX + _pauseR/4 - 2;
        CGFloat pasueY2 = pasueY1;
        CGRect pasueFrame2 = CGRectMake(pasueX2, pasueY2, 4, 12);
        
        CGContextMoveToPoint(context, pasueX1 , pasueY1);
        CGContextAddRect(context, pasueFrame1);
        CGContextMoveToPoint(context, pasueX2, pasueY2);
        CGContextAddRect(context, pasueFrame2);
    }
//    填充样式：奇偶填充（默认为非零绕束规则填充，）
     CGContextEOFillPath(context);

}

@end
