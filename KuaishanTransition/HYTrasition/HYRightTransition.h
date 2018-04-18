//
//  HYRightTransition.h
//  hooya
//
//  Created by wangfubin on 2018/1/17.
//  Copyright © 2018年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HYRightTransitionType)
{
    HYRightTransitionTypePush = 0,
    HYRightTransitionTypePop
};

@interface HYRightTransition : NSObject<UIViewControllerAnimatedTransitioning>

/*
 *  动画过渡代理管理的是push还是pop
 */
@property (nonatomic, assign) HYRightTransitionType type;
/*
 * 初始化动画过渡代理
 * @prama type 初始化pop还是push的代理
 */
+ (instancetype)transitionWithType:(HYRightTransitionType)type;
- (instancetype)initWithTransitionType:(HYRightTransitionType)type;

@end
