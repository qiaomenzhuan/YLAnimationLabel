//
//  YLAnimationLabel.m
//  YLAnimationLabel
//
//  Created by 杨磊 on 2018/4/11.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import "YLAnimationLabel.h"
#define SECOND 0.3

@interface YLAnimationLabel()<CAAnimationDelegate>

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *centerView;
@property (strong, nonatomic) UIView *bottomView;

@property (nonatomic, strong) UIFont *ylfont;
@property (nonatomic, strong) UIColor *ylTextcolor;
@property (nonatomic, assign) NSTextAlignment ylAlignment;

@property (nonatomic,assign) BOOL ylIfTopToB;
@property (nonatomic,assign) BOOL ylIfAllMove;

@end

@implementation YLAnimationLabel

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        [self loadSubViews:frame];
    }
    return self;
}

- (void)loadSubViews:(CGRect)frame
{
    self.centerView = [UIView new];
    CGRect frameCenter = CGRectMake(0, frame.size.height/3.f, frame.size.width, frame.size.height/3.f);
    self.centerView.frame = frameCenter;
    self.centerView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.centerView];
    
    self.topView = [UIView new];
    CGRect frameTop = CGRectMake(0, 0, frame.size.width, frame.size.height/3.f);
    self.topView.frame = frameTop;
    self.topView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.topView];
    
    self.bottomView = [UIView new];
    CGRect frameBot = CGRectMake(0, 2*frame.size.height/3.f, frame.size.width, frame.size.height/3.f);
    self.bottomView.frame = frameBot;
    self.bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bottomView];
    
    self.lastText = @"";
    self.currText = @"";
    self.bottomView.hidden = YES;
    self.topView.hidden = YES;
    [self setSomeLabels:self.currText backView:self.topView];
    [self setSomeLabels:self.lastText backView:self.centerView];
    [self setSomeLabels:self.currText backView:self.bottomView];
}

#pragma mark - 开始动画
- (void)beginAllAnimaiton
{
    [self setSomeLabels:self.currText backView:self.topView];
    [self setSomeLabels:self.lastText backView:self.centerView];
    [self setSomeLabels:self.currText backView:self.bottomView];
    [self animationLabel];
}
#pragma mark - 设置
- (void)animationLabel
{
    if ([self.lastText isEqualToString:self.currText] && !self.ylIfAllMove)return;
    
    NSMutableArray *array = [NSMutableArray array];//现在显示的字符数组
    for (int i = 0; i<self.currText.length; i++)
    {
        NSString *str = [self.currText substringWithRange:NSMakeRange(i,1)];
        [array addObject:str];
    }
    
    NSMutableArray *arrayLast = [NSMutableArray array];//上一次显示的字符数组
    for (int i = 0; i<self.lastText.length; i++)
    {
        NSString *str = [self.lastText substringWithRange:NSMakeRange(i,1)];
        [arrayLast addObject:str];
    }
    
    NSMutableArray *animationArr = [NSMutableArray array];//中间view上的labels动画数组
    NSMutableArray *botAnimationArr = [NSMutableArray array];//上边 下边view上的labels动画数组
    
    if (self.ylIfAllMove)
    {
        for (int i = 0; i < arrayLast.count; i++)
        {
            [animationArr addObject:[NSNumber numberWithInt:i]];
        }
        for (int i = 0; i < array.count; i++)
        {
            [botAnimationArr addObject:[NSNumber numberWithInt:i]];
        }
    }else
    {
        if (array.count != arrayLast.count)
        {//上次显示的label全部动画
            for (int i = 0; i < arrayLast.count; i++)
            {
                [animationArr addObject:[NSNumber numberWithInt:i]];
            }
            for (int i = 0; i < array.count; i++)
            {
                [botAnimationArr addObject:[NSNumber numberWithInt:i]];
            }
            
        }else
        {
            for (int i = 0; i< arrayLast.count; i++)
            {
                NSString *strLast = [arrayLast objectAtIndex:i];
                NSString *strCurr = [array objectAtIndex:i];
                if (![strLast isEqualToString:strCurr])
                {//需要动画的字符位置
                    [animationArr addObject:[NSNumber numberWithInt:i]];
                    [botAnimationArr addObject:[NSNumber numberWithInt:i]];
                }
            }
        }
    }
    
    if (self.ylIfTopToB)
    {//从上到下
        self.bottomView.hidden = YES;
        //中间的往下面走
        for (NSNumber *index in animationArr)
        {
            int i = [index intValue];
            UILabel *label = [self.centerView viewWithTag:i+20000];
            [self centerTobottomAnimation:label];
        }
        //上面的往中间走
        for (UILabel *label in self.topView.subviews) {
            label.hidden = YES;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.topView.hidden = NO;
            for (NSNumber *index in botAnimationArr)
            {
                int i = [index intValue];
                UILabel *label = [self.topView viewWithTag:i+10000];
                label.hidden = NO;
                [self topToCenterAnimation:label];
            }
        });
        
    }else
    {//从下到上
        self.topView.hidden = YES;
        //中间的往上走
        for (NSNumber *index in animationArr)
        {
            int i = [index intValue];
            UILabel *label = [self.centerView viewWithTag:i+20000];
            [self beganDismissAnimation:label];
        }
        //下面的往中间走
        for (UILabel *label in self.bottomView.subviews) {
            label.hidden = YES;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.bottomView.hidden = NO;
            for (NSNumber *index in botAnimationArr)
            {
                int i = [index intValue];
                UILabel *label = [self.bottomView viewWithTag:i+30000];
                label.hidden = NO;
                [self beganAppearAnimation:label];
            }
        });
    }
}

- (void)setSomeLabels:(NSString *)str backView:(UIView *)backView
{
    for (id view in backView.subviews) {
        [view removeFromSuperview];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<str.length; i++)
    {
        NSString *strSon = [str substringWithRange:NSMakeRange(i,1)];
        [array addObject:strSon];
    }
    CGFloat x = 0;
    int addInt = 10000;
    if ([backView isEqual:self.centerView]) {
        addInt = 20000;
    }else if ([backView isEqual:self.bottomView])
    {
        addInt = 30000;
    }
    //求总长度
    CGFloat w = [self getStringWidth:str andFont:self.ylfont ? self.ylfont : [UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:self.frame.size.height/3.f]] + str.length - 1;
    x = w;
    if (self.ylAlignment)
    {
        x = (self.frame.size.width - x)/2.f;
        x = MAX(0, x);
    }else
    {
        x = 0;
    }
    for (int i = 0; i< array.count; i++)
    {
        NSString *str1 = [array objectAtIndex:i];
        UILabel *label = [UILabel new];
        label.tag = addInt+i;
        label.font = self.ylfont ? self.ylfont : [UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:self.frame.size.height/3.f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.ylTextcolor ? self.ylTextcolor : [UIColor whiteColor];
        label.text = str1;
        CGFloat w = [self getStringWidth:str1 andFont:label.font];
        label.frame =CGRectMake(x, 0, w, self.frame.size.height/3.f);
        x += w;
        [backView addSubview:label];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if([[anim valueForKey:@"animType"] isEqualToString:@"beganAppearAnimation"])
    {//从下面到中间
        self.bottomView.hidden = YES;
        self.topView.hidden = YES;
        [self setSomeLabels:self.currText backView:self.centerView];
        
        if (self.YlClick) {
            self.YlClick();
        }
    }else if([[anim valueForKey:@"animType"] isEqualToString:@"beganDismissAnimation"])
    {//往中间到上面
        
    }else if([[anim valueForKey:@"animType"] isEqualToString:@"topToCenterAnimation"])
    {//从上面往中间走
        self.bottomView.hidden = YES;
        self.topView.hidden = YES;
        [self setSomeLabels:self.currText backView:self.centerView];
        if (self.YlClick) {
            self.YlClick();
        }
    }else if([[anim valueForKey:@"animType"] isEqualToString:@"centerTobottomAnimation"])
    {//从中间往下面走
        
    }
}
#pragma mark - 从上面往中间走
- (void)topToCenterAnimation:(UILabel *)label
{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.repeatCount = 1;
    group.duration = SECOND;
    group.delegate = self;
    
    CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position.y"];
    positionAnima.duration = SECOND;
    positionAnima.fromValue = @(label.center.y);
    positionAnima.toValue = @(label.center.y + self.frame.size.height/3.f);
    positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    positionAnima.repeatCount = 1;
    positionAnima.removedOnCompletion = NO;
    positionAnima.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = SECOND;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    opacityAnimation.fromValue = @(0.f);
    opacityAnimation.toValue = @(1.f);
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    group.animations = @[positionAnima,opacityAnimation];
    [group setValue:@"topToCenterAnimation" forKey:@"animType"];
    [label.layer addAnimation:group forKey:@"labela"];
}

#pragma mark - 从中间往下面走
- (void)centerTobottomAnimation:(UILabel *)label
{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.repeatCount = 1;
    group.duration = SECOND;
    group.delegate = self;
    
    CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position.y"];
    positionAnima.duration = SECOND;
    positionAnima.fromValue = @(label.center.y);
    positionAnima.toValue = @(label.center.y + self.frame.size.height/3.f);
    positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    positionAnima.repeatCount = 1;
    positionAnima.removedOnCompletion = NO;
    positionAnima.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = SECOND;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    opacityAnimation.fromValue = @(1.f);
    opacityAnimation.toValue = @(0.f);
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    group.animations = @[positionAnima,opacityAnimation];
    if (self.ylIfAllMove)
    {
        group.animations = @[opacityAnimation];
    }
    [group setValue:@"centerTobottomAnimation" forKey:@"animType"];
    [label.layer addAnimation:group forKey:@"labela"];
}
#pragma mark - 往中间到上面
- (void)beganDismissAnimation:(UILabel *)label
{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.repeatCount = 1;
    group.duration = SECOND;
    group.delegate = self;
    
    CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position.y"];
    positionAnima.duration = SECOND;
    positionAnima.fromValue = @(label.center.y);
    positionAnima.toValue = @(label.center.y- self.frame.size.height/3.f);
    positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    positionAnima.repeatCount = 1;
    positionAnima.removedOnCompletion = NO;
    positionAnima.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = SECOND;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0);
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    group.animations = @[positionAnima,opacityAnimation];
    [group setValue:@"beganDismissAnimation" forKey:@"animType"];
    [label.layer addAnimation:group forKey:@"labela"];
}
#pragma mark - 从下面到中间
- (void)beganAppearAnimation:(UILabel *)label
{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.repeatCount = 1;
    group.duration = SECOND;
    group.delegate = self;
    
    CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position.y"];
    positionAnima.duration = SECOND;
    positionAnima.fromValue = @(label.center.y);
    positionAnima.toValue = @(label.center.y- self.frame.size.height/3.f);
    positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    positionAnima.repeatCount = 1;
    positionAnima.removedOnCompletion = NO;
    positionAnima.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = SECOND;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    opacityAnimation.fromValue = @(0.0);
    opacityAnimation.toValue = @(1.0);
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    group.animations = @[positionAnima,opacityAnimation];
    [group setValue:@"beganAppearAnimation" forKey:@"animType"];
    [label.layer addAnimation:group forKey:@"labela"];
}

- (float)getStringWidth:(NSString *)text andFont:(UIFont *)font{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.width+1;
}

- (YLLabelFont)YLFont
{
    __weak typeof(self) weakSelf = self;
    return ^(UIFont *value)
    {
        self.ylfont  = value;
        return weakSelf;
    };
}

- (YLLabelTextColor)YLTextColor
{
    __weak typeof(self) weakSelf = self;
    return ^(UIColor *value)
    {
        self.ylTextcolor  = value;
        return weakSelf;
    };
}

- (YLLabelTextAlign)YLTextAlign
{
    __weak typeof(self) weakSelf = self;
    return ^(NSTextAlignment value)
    {
        self.ylAlignment  = value;
        return weakSelf;
    };
}

- (YLLabelIfAllMove)YlMove
{
    __weak typeof(self) weakSelf = self;
    return ^(BOOL value)
    {
        self.ylIfAllMove = value;
        return weakSelf;
    };
}


- (YLLabelIfAllMove)YlIfTop
{
    __weak typeof(self) weakSelf = self;
    return ^(BOOL value)
    {
        self.ylIfTopToB = value;
        return weakSelf;
    };
}

@end
