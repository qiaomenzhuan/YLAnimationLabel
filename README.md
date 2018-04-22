# YLAnimationLabel
项目中有倒计时，各方代表墙裂要求动感效果，如下：
![ezgif.com-resize.gif](https://upload-images.jianshu.io/upload_images/6206716-3ff68ebe61113cd5.gif?imageMogr2/auto-orient/strip)

没错，细心的你会发现我这个label碉堡了有木有。不光会让数字动起来，任何字符串都支持！还支持动画的方向！！！

实现部分，主要是用了三个label即上中下三个label来控制动画，而每个label又由字符串长度个label组成。

上边和下边的label内容是相同的，都是上一次显示的内容，只是方便做往上走或往下动画，中间的label显示的是最新的内容，每次只需拿上边或下边的label和中间的比较即可。
![屏幕快照 2018-04-15 23.34.42.png](https://upload-images.jianshu.io/upload_images/6206716-8838b7911914ce46.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

创建view部分
```
    NSMutableArray *array = [NSMutableArray array];//将字符串拆分成字符数组
    for (int i = 0; i<str.length; i++)
    {
        NSString *strSon = [str substringWithRange:NSMakeRange(i,1)];
        [array addObject:strSon];
    }
    for (int i = 0; i< array.count; i++)
    {//将每一个字符显示到view上
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
```
动画部分是简单的基础动画 位移+透明度
```
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
```
以上。
