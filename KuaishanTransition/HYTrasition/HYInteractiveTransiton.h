//
//  HYInteractiveTransiton.h
//  hooya
//
//  Created by wangfubin on 2018/1/17.
//  Copyright © 2018年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BottomView;

// 手势的方向
typedef NS_ENUM(NSUInteger, HYInteractiveTransitionGestureDirection)
{
    HYInteractiveTransitionGestureDirctionNone = 0,
    HYInteractiveTransitionGestureDirectionLeft,
    HYInteractiveTransitionGestureDirectionRight,
    HYInteractiveTransitionGestureDirectionUp,
    HYInteractiveTransitionGestureDirectionDown
};

// 手势控制哪种转场
typedef NS_ENUM(NSUInteger, HYInteractiveTransitionType)
{
    HYInteractiveTransitionTypePresent = 0,
    HYInteractiveTransitionTypeDismiss,
    HYInteractiveTransitionTypePush,
    HYInteractiveTransitionTypePop,
};

typedef void(^GestureConifg)(HYInteractiveTransitionGestureDirection direction);

@interface HYInteractiveTransiton : UIPercentDrivenInteractiveTransition

/*
 * 记录是否开始手势，判断pop操作是手势触发还是返回键触发
 */
@property (nonatomic, assign) BOOL interation;

/*
 * 促发手势present的时候的config，config中初始化并present需要弹出的控制器
 */
@property (nonatomic, copy) GestureConifg presentConifg;

/*
 * 促发手势push的时候的config，config中初始化并push需要弹出的控制器
 */
@property (nonatomic, copy) GestureConifg pushConifg;

/*
 * 是否是第一次进入手势
 */
@property (nonatomic, assign) BOOL isFirst;

/*
 * 根据滑动操作判断收拾方向
 */
@property (nonatomic, assign) HYInteractiveTransitionGestureDirection directionOut;

/*
 * 手势方向
 */
@property (nonatomic, assign) HYInteractiveTransitionGestureDirection direction;

/*
 * 下拉的view
 */
@property (nonatomic, weak) BottomView *bottomView;

/*
 * 初始化方法
 */
+ (instancetype)interactiveTransitionWithTransitionType:(HYInteractiveTransitionType)type
                                       GestureDirection:(HYInteractiveTransitionGestureDirection)direction;

- (instancetype)initWithTransitionType:(HYInteractiveTransitionType)type
                      GestureDirection:(HYInteractiveTransitionGestureDirection)direction;

/*
 * 给传入的控制器添加手势
 */
- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end
