//
//  LeftViewController.m
//  KuaishanTransition
//
//  Created by wangfubin on 2018/4/18.
//  Copyright © 2018年 wangfubin. All rights reserved.
//

#import "LeftViewController.h"

#import "HYInteractiveTransiton.h"
#import "HYLeftTransition.h"

@interface LeftViewController ()

// 过度动画
@property (nonatomic, strong) HYInteractiveTransiton *interactiveTransitionPop;
@property (nonatomic, assign) UINavigationControllerOperation operation;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"Left";
    
    [self p_setupGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.navigationController.delegate = nil;
}


- (void)p_setupGesture
{
    //初始化手势过渡的代理
    self.interactiveTransitionPop = [HYInteractiveTransiton interactiveTransitionWithTransitionType:HYInteractiveTransitionTypePop GestureDirection:HYInteractiveTransitionGestureDirectionLeft];
    //给当前控制器的视图添加手势
    [self.interactiveTransitionPop addPanGestureForViewController:self];
}

#pragma mark -- UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    self.operation = operation;
    //分pop和push两种情况分别返回动画过渡代理相应不同的动画操作
    return [HYLeftTransition transitionWithType:operation == UINavigationControllerOperationPush ? HYLeftTransitionTypePush : HYLeftTransitionTypePop];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (self.operation == UINavigationControllerOperationPush)
    {
        HYInteractiveTransiton *interactiveTransitionPush = (HYInteractiveTransiton *)[self.delegate interactiveTransitionForPush];
        return interactiveTransitionPush.interation ? interactiveTransitionPush : nil;
    }
    else
    {
        return self.interactiveTransitionPop.interation ? self.interactiveTransitionPop : nil;
    }
}


@end
