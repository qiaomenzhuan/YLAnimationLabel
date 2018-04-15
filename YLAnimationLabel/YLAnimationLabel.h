//
//  YLAnimationLabel.h
//  YLAnimationLabel
//
//  Created by 杨磊 on 2018/4/11.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLAnimationLabel;
typedef void(^YLclick)(void);

typedef YLAnimationLabel *(^YLLabelFont     )(UIFont *value);
typedef YLAnimationLabel *(^YLLabelTextColor)(UIColor *value);
typedef YLAnimationLabel *(^YLLabelTextAlign)(NSTextAlignment value);

typedef YLAnimationLabel *(^YLLabelIfAllMove)(BOOL value);//是否整体移动
typedef YLAnimationLabel *(^YLLabelIfTopToCenter)(BOOL value);//1从上到下 0从下到上

@interface YLAnimationLabel : UIView

@property (nonatomic,  copy)YLLabelFont           YLFont;
@property (nonatomic,  copy)YLLabelTextColor      YLTextColor;
@property (nonatomic,  copy)YLLabelTextAlign      YLTextAlign;

@property (nonatomic,  copy)YLclick               YlClick;
@property (nonatomic,  copy)YLLabelIfAllMove      YlMove;
@property (nonatomic,  copy)YLLabelIfTopToCenter  YlIfTop;

@property (nonatomic,  copy)NSString *currText;

@property (nonatomic,  copy)NSString *lastText;

- (void)beginAllAnimaiton;

@end
