//
//  RootTabController.m
//  MSTabBarController
//
//  Created by mr.scorpion on 15/8/11.
//  Copyright (c) 2015年 MSTabBarController. All rights reserved.
//

#import "RootTabController.h"
#import "ViewController.h"
#import "FixedItemWidthTabController.h"
#import "DynamicItemWidthTabController.h"
#import "SegmentTabController.h"
#import "UnscrollTabController.h"

@interface RootTabController ()

@end

@implementation RootTabController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initViewControllers];
    self.tabBar.backgroundColor = [UIColor lightGrayColor];
    
    // 设置数字样式的badge的位置和大小
    [self.tabBar setNumberBadgeMarginTop:2
                       centerMarginRight:20
                     titleHorizonalSpace:8
                      titleVerticalSpace:2];
    // 设置小圆点样式的badge的位置和大小
    [self.tabBar setDotBadgeMarginTop:5
                    centerMarginRight:15
                           sideLength:10];
    
    
    UIViewController *controller1 = self.viewControllers[0];
    UIViewController *controller2 = self.viewControllers[1];
    UIViewController *controller3 = self.viewControllers[2];
    UIViewController *controller4 = self.viewControllers[3];
    controller1.MS_tabItem.badge = 8;
    controller2.MS_tabItem.badge = 88;
    controller3.MS_tabItem.badge = 120;
    controller4.MS_tabItem.badgeStyle = MSTabItemBadgeStyleDot;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViewControllers {
    
    DynamicItemWidthTabController *controller1 = [[DynamicItemWidthTabController alloc] init];
    controller1.MS_tabItemTitle = @"动态宽度";
    controller1.MS_tabItemImage = [UIImage imageNamed:@"tab_message_normal"];
    controller1.MS_tabItemSelectedImage = [UIImage imageNamed:@"tab_message_selected"];
    
    FixedItemWidthTabController *controller2 = [[FixedItemWidthTabController alloc] init];
    controller2.MS_tabItemTitle = @"固定宽度";
    controller2.MS_tabItemImage = [UIImage imageNamed:@"tab_discover_normal"];
    controller2.MS_tabItemSelectedImage = [UIImage imageNamed:@"tab_discover_selected"];
    
    UnscrollTabController *controller3 = [[UnscrollTabController alloc] init];
    controller3.MS_tabItemTitle = @"不滚动tab";
    controller3.MS_tabItemImage = [UIImage imageNamed:@"tab_me_normal"];
    controller3.MS_tabItemSelectedImage = [UIImage imageNamed:@"tab_me_selected"];
    
    SegmentTabController *controller4 = [[SegmentTabController alloc] init];
    controller4.MS_tabItemTitle = @"系统Segment";
    controller4.MS_tabItemImage = [UIImage imageNamed:@"tab_me_normal"];
    controller4.MS_tabItemSelectedImage = [UIImage imageNamed:@"tab_me_selected"];
    
//    ViewController *controller5 = [[ViewController alloc] init];
//    controller5.MS_tabItemTitle = @"普通";
//    controller5.MS_tabItemImage = [UIImage imageNamed:@"tab_me_normal"];
//    controller5.MS_tabItemSelectedImage = [UIImage imageNamed:@"tab_me_selected"];
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, nil];
    
    // 生成一个居中显示的MSTabItem对象，即“+”号按钮
    MSTabItem *item = [MSTabItem buttonWithType:UIButtonTypeCustom];
    item.title = @"+";
    item.titleColor = [UIColor yellowColor];
    item.backgroundColor = [UIColor darkGrayColor];
    item.titleFont = [UIFont boldSystemFontOfSize:40];
    
    // 设置其size，如果不设置，则默认为与其他item一样
    item.size = CGSizeMake(80, 60);
    // 高度大于tabBar，所以需要将此属性设置为NO
    self.tabBar.clipsToBounds = NO;
    
    [self.tabBar setSpecialItem:item
             afterItemWithIndex:1
                     tapHandler:^(MSTabItem *item) {
                         NSLog(@"item--->%ld", (long)item.index);
                     }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSLog(@"viewWillAppear");
}

@end
