//
//  ViewController.m
//  KuaishanTransition
//
//  Created by wangfubin on 2018/4/18.
//  Copyright © 2018年 wangfubin. All rights reserved.
//

#import "ViewController.h"

#import "HYInteractiveTransiton.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "PushControllerDelegate.h"

@interface ViewController () <PushControllerDelegate>

@property(nonatomic, strong) HYInteractiveTransiton *interactiveTransitionPush;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Centre";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self p_initInteractiveTransitionPush];
}

#pragma mark -- PushControllerDelegate
- (void)p_initInteractiveTransitionPush
{
    self.interactiveTransitionPush = [[HYInteractiveTransiton alloc] init];
    __weak typeof (self) weakSelf = self;
    self.interactiveTransitionPush.pushConifg = ^(HYInteractiveTransitionGestureDirection direction){
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if(direction == HYInteractiveTransitionGestureDirectionRight)
        {
            [strongSelf leftPush];
        }
        else if(direction == HYInteractiveTransitionGestureDirectionLeft)
        {
            [strongSelf rightPush];
        }
    };
    //
    [self.interactiveTransitionPush addPanGestureForViewController:self];
}

- (void)rightPush
{
    RightViewController *rightViewController = [[RightViewController alloc] init];
    self.navigationController.delegate = rightViewController;
    rightViewController.delegate = self;
    [self.navigationController pushViewController:rightViewController animated:YES];
}

- (void)leftPush
{
    LeftViewController *leftViewController = [[LeftViewController alloc] init];
    self.navigationController.delegate = leftViewController;
    leftViewController.delegate = self;
    [self.navigationController pushViewController:leftViewController animated:YES];
}

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPush
{
    return self.interactiveTransitionPush;
}



@end
