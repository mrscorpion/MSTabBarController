//
//  MSTabBarController.h
//  MSTabBarController
//
//  Created by mr.scorpion on 15/8/11.
//  Copyright (c) 2015年 MSTabBarController. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSTabBar.h"
#import "MSTabItem.h"

@interface MSTabBarController : UIViewController <MSTabBarDelegate>

@property (nonatomic, strong, readonly) MSTabBar *tabBar;

@property (nonatomic, copy) NSArray <UIViewController *> *viewControllers;

/**
 *  内容视图的Frame
 */
@property (nonatomic, assign) CGRect contentViewFrame;

/**
 *  被选中的ViewController的Index
 */
@property (nonatomic, assign, readonly) NSInteger selectedControllerIndex;

/**
 *  设置tabBar和contentView的frame，
 *  默认是tabBar在底部，contentView填充其余空间
 */
- (void)setTabBarFrame:(CGRect)tabBarFrame contentViewFrame:(CGRect)contentViewFrame;


/**
 *  设置内容视图支持滑动切换，以及点击item切换时是否有动画
 *
 *  @param animated  点击切换时是否支持动画
 */
- (void)setContentScrollEnabledAndTapSwitchAnimated:(BOOL)animated;

/**
 *  获取被选中的ViewController
 */
- (UIViewController *)selectedController;

@end

@interface UIViewController (MSTabBarController)

@property (nonatomic, copy) NSString *MS_tabItemTitle; // tabItem的标题
@property (nonatomic, strong) UIImage *MS_tabItemImage; // tabItem的图像
@property (nonatomic, strong) UIImage *MS_tabItemSelectedImage; // tabItem的选中图像

- (MSTabItem *)MS_tabItem;
- (MSTabBarController *)MS_tabBarController;

/**
 *  ViewController对应的Tab被Select后，执行此方法
 */
- (void)tabItemDidSelected;

/**
 *  ViewController对应的Tab被Deselect后，执行此方法
 */
- (void)tabItemDidDeselected;

@end
