# KuaishanTransition
仿snapchat与快闪的双向转场动画的实现

# 1. 说明

由于iPhone X的面世，越来越多app依赖手势控制页面跳转。一般的转场动画只能指定一个方向，不能在同一个VC中，有2种不同的转场动画。本文仿照快闪app，snapchat app等视频app，视频页面在中间，可以左右滑动或者上下拖动，拖出相关的View。本文转场相关的知识参考：[iOS自定义转场动画](https://www.jianshu.com/p/45434f73019e)，在这边文章的基础下添加对同一个页面的不同手势的转场。

![snapchat根据左右滑动手势显示不同页面](http://upload-images.jianshu.io/upload_images/5333476-53171c29ea92786f?imageMogr2/auto-orient/strip)

![快闪根据左右滑动手势以及下拉手势显示不同页面](http://upload-images.jianshu.io/upload_images/5333476-4cad6b8daa36be51?imageMogr2/auto-orient/strip)

# 2.核心实现

添加一个左滑的LeftTransition处理左滑动画，添加一个右滑的RightTransition处理右滑动画，LeftViewController与RightViewController添加相应的代理，主要在ViewController这个中间VC中处理相应的操作。

#####ViewController文件中：

```
// 由于每次返回ViewController，都要初始化一次自定义转场动画方法，因为初始化函数放在viewDidAppear中
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self p_initInteractiveTransitionPush];
}
```

```
- (void)p_initInteractiveTransitionPush
{
    self.interactiveTransitionPush = [[HYInteractiveTransiton alloc] init];
    __weak typeof (self) weakSelf = self;
    self.interactiveTransitionPush.pushConifg = ^(HYInteractiveTransitionGestureDirection direction){
        __strong typeof (weakSelf) strongSelf = weakSelf;
       // 根据滑动的方向来加载不同的VC
        if(direction == HYInteractiveTransitionGestureDirectionRight)
        {
            [strongSelf leftPush];
        }
        else if(direction == HYInteractiveTransitionGestureDirectionLeft)
        {
            [strongSelf rightPush];
        }
    };
    // 添加下拉手势的view
    [self.interactiveTransitionPush addPanGestureForViewController:self];
}

- (void)rightPush
{
    RightViewController *rightViewController = [[RightViewController alloc] init];
    self.navigationController.delegate = rightViewController;
    rightViewController.delegate = self;
    [self.navigationController pushViewController:rightViewController animated:YES];
}

- (void)leftPush
{
    LeftViewController *leftViewController = [[LeftViewController alloc] init];
    self.navigationController.delegate = leftViewController;
    leftViewController.delegate = self;
    [self.navigationController pushViewController:leftViewController animated:YES];
}

#pragma mark -- PushControllerDelegate
- (id)interactiveTransitionForPush
{
    return self.interactiveTransitionPush;
}

```
#####HYInteractiveTransition文件中
```
/*
 *  手势过渡的过程
 */
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture
{
    //手势百分比
    CGFloat persent = 0;
    self.directionOut = HYInteractiveTransitionGestureDirctionNone;
    // 这里判断在手势指定时是什么手势
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

    // 已经指定了手势方向，判断手势滑动的百分比
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
            
            // 不是左右滑动的话，采用以下方法判断是上下滑动加载view
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
```
效果图如下：
![demo效果图](https://upload-images.jianshu.io/upload_images/5333476-f16cfaf804cfeefa.gif?imageMogr2/auto-orient/strip)

