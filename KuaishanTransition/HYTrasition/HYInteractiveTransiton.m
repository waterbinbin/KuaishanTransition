//
//  HYInteractiveTransiton.m
//  hooya
//
//  Created by wangfubin on 2018/1/17.
//  Copyright © 2018年 YY Inc. All rights reserved.
//

// 参考里边的2篇博客进行简单修改：https://www.jianshu.com/p/45434f73019e

#import "HYInteractiveTransiton.h"

#import "ViewController.h"
#import "BottomView.h"

@interface HYInteractiveTransiton ()

@property (nonatomic, weak) UIViewController *vc;

/*
 * 手势类型
 */
@property (nonatomic, assign) HYInteractiveTransitionType type;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (assign, nonatomic) BOOL isBeginSlid;
@property (assign, nonatomic) CGFloat originY;
@property (assign, nonatomic) HYInteractiveTransitionGestureDirection originDirection;

@end

@implementation HYInteractiveTransiton

+ (instancetype)interactiveTransitionWithTransitionType:(HYInteractiveTransitionType)type
                                       GestureDirection:(HYInteractiveTransitionGestureDirection)direction
{
    return [[self alloc] initWithTransitionType:type GestureDirection:direction];
}

- (instancetype)initWithTransitionType:(HYInteractiveTransitionType)type
                      GestureDirection:(HYInteractiveTransitionGestureDirection)direction
{
    self = [super init];
    if (self) {
        _direction = direction;
        _type = type;
    }
    return self;
}

- (void)addPanGestureForViewController:(UIViewController *)viewController
{
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.vc = viewController;
    [viewController.view addGestureRecognizer:_pan];

    if([self.vc isKindOfClass:[ViewController class]])
    {
        BottomView *tmp = [[BottomView alloc] initWithFrame:CGRectMake(0, 0-self.vc.view.frame.size.height, self.vc.view.frame.size.width, self.vc.view.frame.size.height)];
        [self.vc.view addSubview:tmp];
        tmp.isHiddenView = YES;
        self.bottomView = tmp;
    }
    
}

/*
 *  手势过渡的过程
 */
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture
{
    //手势百分比
    CGFloat persent = 0;
    self.directionOut = HYInteractiveTransitionGestureDirctionNone;
    if([panGesture translationInView:panGesture.view].x < 0)
    {
        if(-[panGesture translationInView:panGesture.view].x > ([panGesture translationInView:panGesture.view].y > 0 ? [panGesture translationInView:panGesture.view].y : -[panGesture translationInView:panGesture.view].y) )
        {
            self.directionOut = HYInteractiveTransitionGestureDirectionLeft;
        }
        
    }
    else if([panGesture translationInView:panGesture.view].x > 0)
    {
        if([panGesture translationInView:panGesture.view].x > ([panGesture translationInView:panGesture.view].y > 0 ? [panGesture translationInView:panGesture.view].y : -[panGesture translationInView:panGesture.view].y) )
        {
            self.directionOut = HYInteractiveTransitionGestureDirectionRight;
        }
    }

    switch (_direction)
    {
        case HYInteractiveTransitionGestureDirctionNone:
            break;
        case HYInteractiveTransitionGestureDirectionLeft:
        {
            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case HYInteractiveTransitionGestureDirectionRight:
        {
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case HYInteractiveTransitionGestureDirectionUp:
        {
            CGFloat transitionY = -[panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
        case HYInteractiveTransitionGestureDirectionDown:
        {
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
    }
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            //手势开始的时候标记手势状态，并开始相应的事件
            self.interation = YES;
            [self startGesture];
            
            // 这里添加测试代码
            // 首次触摸进入
            self.isBeginSlid = YES;
            self.originY = [panGesture translationInView:panGesture.view].y;
            
            self.originDirection = HYInteractiveTransitionGestureDirctionNone;
            if([panGesture translationInView:panGesture.view].x < 0)
            {
                if(-[panGesture translationInView:panGesture.view].x > ([panGesture translationInView:panGesture.view].y > 0 ? [panGesture translationInView:panGesture.view].y : -[panGesture translationInView:panGesture.view].y) )
                {
                    self.originDirection = HYInteractiveTransitionGestureDirectionLeft;
                }
                
            }
            else if([panGesture translationInView:panGesture.view].x > 0)
            {
                if([panGesture translationInView:panGesture.view].x > ([panGesture translationInView:panGesture.view].y > 0 ? [panGesture translationInView:panGesture.view].y : -[panGesture translationInView:panGesture.view].y) )
                {
                    self.originDirection = HYInteractiveTransitionGestureDirectionRight;
                }
            }
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //手势过程中，通过updateInteractiveTransition设置pop过程进行的百分比
            if(_direction != HYInteractiveTransitionGestureDirctionNone)
            {
            }
            else if(!self.isFirst && self.bottomView.isHiddenView)
            {
                _type = HYInteractiveTransitionTypePush;
                _direction = self.directionOut;
                [self startGesture:self.directionOut];
                self.isFirst = YES;
            }
            [self updateInteractiveTransition:persent];
            
            // 这里添加测试代码
            if(!self.bottomView)
            {
                return;
            }
            
            
            if(self.bottomView.isHiddenView)
            {
                // 获取偏移位置
                CGPoint tempCenter;
                // 首次触摸进入
                if(self.isBeginSlid)
                {
                    if(self.originDirection != HYInteractiveTransitionGestureDirctionNone)
                    {
                        return;
                    }
                    
                    // 判断是左右滑动还是上下滑动
                    if(ABS([panGesture translationInView:panGesture.view].x) > ABS([panGesture translationInView:panGesture.view].y))
                    {
                        
                    }
                    else
                    {
                        tempCenter = self.bottomView.center;
                        tempCenter.y += ([panGesture translationInView:panGesture.view].y - self.originY);//上下滑动
                        self.originY = [panGesture translationInView:panGesture.view].y;
                        // 禁止向下划
                        if (self.bottomView.frame.origin.y == 0 && [panGesture translationInView:panGesture.view].y > 0)
                        {
                            //滑动开始是从0点开始的，并且是向下滑动
                            self.bottomView.center = tempCenter;
                        }
                    }
                }
                // 滑动开始后进入，滑动方向要么水平要么垂直
                else
                {
                    if (self.bottomView.frame.origin.y != 0)
                    {
                        tempCenter = self.bottomView.center;
                        
                        tempCenter.y += ([panGesture translationInView:panGesture.view].y - self.originY);//上下滑动
                        self.originY = [panGesture translationInView:panGesture.view].y;
                        //禁止向下划
                        if (self.bottomView.frame.origin.y == 0 && [panGesture translationInView:panGesture.view].y > 0)
                        {
                            //滑动开始是从0点开始的，并且是向下滑动
                            self.bottomView.center = tempCenter;
                        }
                        else if(self.bottomView.frame.origin.y < 0)
                        {
                            self.bottomView.center = tempCenter;
                        }
                        
                    }
                }
                self.isBeginSlid = NO;
            }
            else    // view显示了需要向上滑动
            {
                // 获取偏移位置
                CGPoint tempCenter;
                // 首次触摸进入
                if(self.isBeginSlid)
                {
                    if(self.originDirection != HYInteractiveTransitionGestureDirctionNone)
                    {
                        return;
                    }
                    
                    // 判断是左右滑动还是上下滑动
                    if(ABS([panGesture translationInView:panGesture.view].x) > ABS([panGesture translationInView:panGesture.view].y))
                    {
                        
                    }
                    else
                    {
                        tempCenter = self.bottomView.center;
                        tempCenter.y += ([panGesture translationInView:panGesture.view].y - self.originY);//上下滑动
                        self.originY = [panGesture translationInView:panGesture.view].y;

                        if (self.bottomView.frame.origin.y == 0 && [panGesture translationInView:panGesture.view].y < 0)
                        {
 
                            self.bottomView.center = tempCenter;
                        }
                    }
                }
                // 滑动开始后进入，滑动方向要么水平要么垂直
                else
                {
                    if (self.bottomView.frame.origin.y != 0)
                    {
                        tempCenter = self.bottomView.center;
                        
                        tempCenter.y += ([panGesture translationInView:panGesture.view].y - self.originY);//上下滑动
                        self.originY = [panGesture translationInView:panGesture.view].y;
                        
                        //禁止向下划
                        if (self.bottomView.frame.origin.y >= 0 && [panGesture translationInView:panGesture.view].y > 0)
                        {
                            //滑动开始是从0点开始的，并且是向下滑动
//                            self.groupSettingMainView.center = tempCenter;
                        }
                        else if(self.bottomView.frame.origin.y < 0)
                        {
                            self.bottomView.center = tempCenter;
                        }
                        
                    }
                }
                self.isBeginSlid = NO;
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作
            self.interation = NO;
            self.isFirst = NO;
            if (persent > 0.1)
            {
                [self finishInteractiveTransition];
            }
            else
            {
                [self cancelInteractiveTransition];
            }
            
            // 这里添加测试代码
            if(self.bottomView.isHiddenView)
            {
                self.originDirection = HYInteractiveTransitionGestureDirctionNone;
                
                if (self.bottomView.frame.origin.y > -self.vc.view.frame.size.height * 0.8)
                {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGRect frame = self.bottomView.frame;
                        frame.origin.y = 0;
                        self.bottomView.frame = frame;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.bottomView.isHiddenView = NO;
                        });
                    }];
                }
                else
                {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGRect frame = self.bottomView.frame;
                        frame.origin.y = -self.vc.view.frame.size.height;
                        self.bottomView.frame = frame;
                    }];
                    
                }
            }
            else
            {
                self.originDirection = HYInteractiveTransitionGestureDirctionNone;
                
                if (self.bottomView.frame.origin.y < -self.vc.view.frame.size.height * 0.2)
                {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGRect frame = self.bottomView.frame;
                        frame.origin.y = -self.vc.view.frame.size.height;
                        self.bottomView.frame = frame;
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.bottomView.isHiddenView = YES;
                        });
                        
                    }];
                }
                else
                {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGRect frame = self.bottomView.frame;
                        frame.origin.y = 0;
                        self.bottomView.frame = frame;
                    }];
                    
                }
            }
            
        }
            break;
        case UIGestureRecognizerStateFailed:
        {
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
        }
            break;
        default:
            break;
    }
}

- (void)startGesture
{
    switch (_type)
    {
        case HYInteractiveTransitionTypePresent:
        {
            if (_presentConifg)
            {
                _presentConifg(_direction);
            }
        }
            break;
        case HYInteractiveTransitionTypeDismiss:
        {
            [_vc dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case HYInteractiveTransitionTypePush:
        {
            if (_pushConifg) {
                _pushConifg(_direction);
            }
        }
            break;
        case HYInteractiveTransitionTypePop:
        {
            [_vc.navigationController popViewControllerAnimated:YES];
        }
            break;
    }
}

- (void)startGesture:(HYInteractiveTransitionGestureDirection)direction
{
    switch (_type)
    {
        case HYInteractiveTransitionTypePresent:
        {
            if (_presentConifg)
            {
                _presentConifg(_direction);
            }
        }
            break;
        case HYInteractiveTransitionTypeDismiss:
        {
            [_vc dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case HYInteractiveTransitionTypePush:
        {
            if (_pushConifg) {
                _pushConifg(_direction);
            }
        }
            break;
        case HYInteractiveTransitionTypePop:
        {
            [_vc.navigationController popViewControllerAnimated:YES];
        }
            break;
    }
}

@end
