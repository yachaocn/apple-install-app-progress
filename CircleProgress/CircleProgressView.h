//
//  CircleProgressView.h
//  CircleProgress
//
//  Created by yachaocn on 16/8/8.
//  Copyright © 2016年 yachaocn. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol YCProgressDelegate <NSObject>
@required
-(void)pause:(CGFloat)progress;
-(void)active:(CGFloat)progress;
@end
@interface CircleProgressView : UIControl
@property(nonatomic,strong) NSTimer *viewTimer;

/**  Progress values go from 0.0 to 1.0  */
@property(nonatomic) CGFloat progress;

/* progress delegate*/
@property(nonatomic,weak) id <YCProgressDelegate> delegate;

/* init */
-(instancetype)initWithFrame:(CGRect)frame;
@end
