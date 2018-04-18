//
//  BottomView.m
//  KuaishanTransition
//
//  Created by wangfubin on 2018/4/18.
//  Copyright © 2018年 wangfubin. All rights reserved.
//

#import "BottomView.h"

@interface BottomView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIButton *upButton;

@end

@implementation BottomView

#pragma mark -- Life Circle

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self p_setupUI];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"BottomView dealloc");
}

#pragma mark -- Private

- (void)p_setupUI
{
    self.backgroundColor = [UIColor orangeColor];
    [self addSubview:self.maskView];
    [self.maskView addSubview:self.upButton];
}

#pragma mark -- LazyLoading && Setting && Getting

- (UIView *)maskView
{
    CGFloat height = 44;
    if(!_maskView)
    {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(20 , height + 10 , 335 , self.frame.size.height - 2 * (height + 10))];
        [_maskView setBackgroundColor:[UIColor blueColor]];
        _maskView.layer.cornerRadius = 14;
        _maskView.layer.masksToBounds = YES;
    }
    return _maskView;
}

- (UIButton *)upButton
{
    if(!_upButton)
    {
        _upButton = [UIButton buttonWithType: UIButtonTypeCustom];
        _upButton.frame = CGRectMake(self.maskView.frame.size.width / 2.0, self.maskView.frame.size.height - 30, 50, 20);
        [_upButton setTitle:@"UP" forState:UIControlStateNormal];
        [_upButton addTarget: self action:@selector(onUpButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upButton;
}

#pragma mark -- Action

- (void)onUpButtonClick
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = -self.frame.size.height;
        self.frame = frame;
        self.isHiddenView = YES;
    }];
}

@end
