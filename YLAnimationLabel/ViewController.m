//
//  ViewController.m
//  YLAnimationLabel
//
//  Created by 杨磊 on 2018/4/11.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import "ViewController.h"
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

#import "YLAnimationLabel.h"

@interface ViewController ()

@property (nonatomic, strong) YLAnimationLabel *aniTimeLabel;
@property (nonatomic, strong) YLAnimationLabel *aniTimeLabelr;
@property (nonatomic, strong) YLAnimationLabel *aniTimeLabell;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger countr;
@property (nonatomic, assign) NSInteger countl;

@property (nonatomic,   copy) NSMutableArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 0;
    self.countr = 7200;
    self.countl = 0;
    self.array = [NSMutableArray arrayWithArray:@[@"哈哈就的",@"你哈不就",@"我哈就的",@"你狗不的"]];
    [self loadTimer];
}
- (void)loadTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer  forMode:NSRunLoopCommonModes];
}

- (void)timeFireMethod
{
    self.count ++;
    self.aniTimeLabel.lastText = self.aniTimeLabel.currText  ? self.aniTimeLabel.currText : @"00:00";
    self.aniTimeLabel.currText = [self timeFormatted:self.count];
    [self.aniTimeLabel beginAllAnimaiton];
    
    self.countr --;
    self.aniTimeLabelr.lastText = self.aniTimeLabelr.currText  ? self.aniTimeLabelr.currText : @"2:00:00";
    self.aniTimeLabelr.currText = [self timeFormatted:self.countr];
    [self.aniTimeLabelr beginAllAnimaiton];
    
    self.countl ++;
    self.countl = MIN(self.countl, 3);
    self.aniTimeLabell.lastText = self.aniTimeLabell.currText  ? self.aniTimeLabell.currText : @"哈哈就的";
    self.aniTimeLabell.currText = self.array[self.countl];
    [self.aniTimeLabell beginAllAnimaiton];
    
    if (self.countl == 3) {
        self.countl = 0;
    }
}


- (YLAnimationLabel *)aniTimeLabel
{
    if (!_aniTimeLabel) {
        _aniTimeLabel = [[YLAnimationLabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, 100, 150, 75)];
        [self.view addSubview:_aniTimeLabel];
        _aniTimeLabel
        .YLTextColor([UIColor whiteColor])
        .YLFont([UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:28.f])
        .YlMove(NO)
        .YLTextAlign(NSTextAlignmentCenter)
        .YlIfTop(NO);
    }
    return _aniTimeLabel;
}

- (YLAnimationLabel *)aniTimeLabelr
{
    if (!_aniTimeLabelr) {
        _aniTimeLabelr = [[YLAnimationLabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, 200, 150, 75)];
        [self.view addSubview:_aniTimeLabelr];
        _aniTimeLabelr
        .YLTextColor([UIColor redColor])
        .YLFont([UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:28.f])
        .YlMove(NO)
        .YLTextAlign(NSTextAlignmentCenter)
        .YlIfTop(YES);
    }
    return _aniTimeLabelr;
}

- (YLAnimationLabel *)aniTimeLabell
{
    if (!_aniTimeLabell) {
        _aniTimeLabell = [[YLAnimationLabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, 300, 150, 75)];
        [self.view addSubview:_aniTimeLabell];
        _aniTimeLabell
        .YLTextColor([UIColor purpleColor])
        .YLFont([UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:28.f])
        .YlMove(NO)
        .YLTextAlign(NSTextAlignmentCenter)
        .YlIfTop(NO);
    }
    return _aniTimeLabell;
}

- (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    if (hours == 0)
    {
        return [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
    }else
    {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hours, minutes, seconds];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
