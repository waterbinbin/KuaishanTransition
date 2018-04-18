//
//  LeftViewController.h
//  KuaishanTransition
//
//  Created by wangfubin on 2018/4/18.
//  Copyright © 2018年 wangfubin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PushControllerDelegate.h"

@interface LeftViewController : UIViewController<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<PushControllerDelegate> delegate;

@end
