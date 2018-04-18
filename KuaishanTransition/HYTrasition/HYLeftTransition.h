//
//  HYLeftTransition.h
//  hooya
//
//  Created by wangfubin on 2018/1/17.
//  Copyright © 2018年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HYLeftTransitionType)
{
    HYLeftTransitionTypePush = 0,
    HYLeftTransitionTypePop
};

@interface HYLeftTransition : NSObject<UIViewControllerAnimatedTransitioning>

/*
 *  动画过渡代理管理的是push还是pop
 */
@property (nonatomic, assign) HYLeftTransitionType type;
/*
 * 初始化动画过渡代理
 * @prama type 初始化pop还是push的代理
 */
+ (instancetype)transitionWithType:(HYLeftTransitionType)type;
- (instancetype)initWithTransitionType:(HYLeftTransitionType)type;

@end
