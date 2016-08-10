//
//  ViewController.m
//  CircleProgress
//
//  Created by yachaocn on 16/8/8.
//  Copyright © 2016年 yachaocn. All rights reserved.
//

#import "ViewController.h"
#import "CircleProgressView.h"

@interface ViewController () <YCProgressDelegate>
@property(nonatomic,strong) CircleProgressView *progressView;
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    imageView.image = [UIImage imageNamed:@"dog.jpg"];
    imageView.layer.cornerRadius = 4.0f;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    // Do any additional setup after loading the view, typically from a nib.
    self.progressView = [[CircleProgressView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:self.progressView];
    self.progressView.delegate = self;
   _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(change:) userInfo:self.progressView repeats:YES];
    self.progressView.viewTimer = _timer;
    
}
-(void)pause:(CGFloat)progress
{
    _timer.fireDate = [NSDate distantFuture];
}
-(void)active:(CGFloat)progress
{
    _timer.fireDate = [NSDate date];
    [_timer fire];
}

-(void)change:(NSTimer *)sender
{
    CircleProgressView *progressView = sender.userInfo;
    progressView.progress +=0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
