//
//  MSTabBarController.m
//  MSTabBarController
//
//  Created by mr.scorpion on 15/8/11.
//  Copyright (c) 2015年 MSTabBarController. All rights reserved.
//

#import "MSTabBarController.h"
#import <objc/runtime.h>

#define TAB_BAR_HEIGHT 50

@interface MSTabBarController () {
    BOOL _didViewAppeared;
}
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL contentScrollEnabled;
@property (nonatomic, assign) BOOL contentSwitchAnimated;
@end

@implementation MSTabBarController
- (instancetype)init {
    self = [super init];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _selectedControllerIndex = -1;
    _tabBar = [[MSTabBar alloc] init];
    _tabBar.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 设置默认的tabBar的frame和contentViewFrame
    CGSize screenSize = [UIScreen mainScreen].bounds.size;

    CGFloat contentViewY = 0;
    CGFloat tabBarY = screenSize.height - TAB_BAR_HEIGHT;
    CGFloat contentViewHeight = tabBarY;
    // 如果parentViewController为UINavigationController及其子类
    if ([self.parentViewController isKindOfClass:[UINavigationController class]] &&
        !self.navigationController.navigationBarHidden &&
        !self.navigationController.navigationBar.hidden) {
            
        CGFloat navMaxY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        if (!self.navigationController.navigationBar.translucent ||
            self.edgesForExtendedLayout == UIRectEdgeNone ||
            self.edgesForExtendedLayout == UIRectEdgeTop) {
            tabBarY = screenSize.height - TAB_BAR_HEIGHT - navMaxY;
            contentViewHeight = tabBarY;
        } else {
            contentViewY = navMaxY;
            contentViewHeight = screenSize.height - TAB_BAR_HEIGHT - contentViewY;
        }
    }
    
    [self setTabBarFrame:CGRectMake(0, tabBarY, screenSize.width, TAB_BAR_HEIGHT)
        contentViewFrame:CGRectMake(0, contentViewY, screenSize.width, contentViewHeight)];
    
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tabBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 在第一次调用viewWillAppear方法时，初始化选中的item
    if (!_didViewAppeared) {
        self.tabBar.selectedItemIndex = 0;
        _didViewAppeared = YES;
    }
}

- (void)setContentViewFrame:(CGRect)contentViewFrame {
    _contentViewFrame = contentViewFrame;
    [self updateContentViewsFrame];
}

- (void)setTabBarFrame:(CGRect)tabBarFrame contentViewFrame:(CGRect)contentViewFrame {
    self.tabBar.frame = tabBarFrame;
    self.contentViewFrame = contentViewFrame;
}

- (void)setViewControllers:(NSArray *)viewControllers {
    
    for (UIViewController *controller in self.viewControllers) {
        [controller removeFromParentViewController];
        [controller.view removeFromSuperview];
    }
    
    _viewControllers = [viewControllers copy];
    [_viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addChildViewController:obj];
    }];
    
    NSMutableArray *items = [NSMutableArray array];
    for (UIViewController *controller in _viewControllers) {
        MSTabItem *item = [MSTabItem buttonWithType:UIButtonTypeCustom];
        item.image = controller.MS_tabItemImage;
        item.selectedImage = controller.MS_tabItemSelectedImage;
        item.title = controller.MS_tabItemTitle;
        [items addObject:item];
    }
    self.tabBar.items = items;
    
    if (_didViewAppeared) {
        _selectedControllerIndex = -1;
        self.tabBar.selectedItemIndex = 0;
    }
    
    // 更新scrollView的content size
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeMake(self.contentViewFrame.size.width * _viewControllers.count,
                                                 self.contentViewFrame.size.height);
    }
}

- (void)setContentScrollEnabledAndTapSwitchAnimated:(BOOL)switchAnimated {
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.contentViewFrame];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.delegate = self.tabBar;
        [self.view insertSubview:self.scrollView belowSubview:self.tabBar];
        self.scrollView.contentSize = CGSizeMake(self.contentViewFrame.size.width * _viewControllers.count,
                                                 self.contentViewFrame.size.height);
    }
    [self updateContentViewsFrame];
    self.contentSwitchAnimated = switchAnimated;
}

- (void)updateContentViewsFrame {
    if (self.scrollView) {
        self.scrollView.frame = self.contentViewFrame;
        self.scrollView.contentSize = CGSizeMake(self.contentViewFrame.size.width * _viewControllers.count,
                                                 self.contentViewFrame.size.height);
        [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull controller,
                                                           NSUInteger idx, BOOL * _Nonnull stop) {
            if (controller.isViewLoaded) {
                controller.view.frame = CGRectMake(idx * self.contentViewFrame.size.width,
                                                   0,
                                                   self.contentViewFrame.size.width,
                                                   self.contentViewFrame.size.height);
            }
        }];
        [self.scrollView scrollRectToVisible:self.selectedController.view.frame animated:NO];
    } else {
        self.selectedController.view.frame = self.contentViewFrame;
    }
}

- (void)setSelectedControllerIndex:(NSInteger)selectedControllerIndex {
    UIViewController *oldController = nil;
    if (_selectedControllerIndex >= 0) {
        oldController = self.viewControllers[_selectedControllerIndex];
    }
    UIViewController *curController = self.viewControllers[selectedControllerIndex];
    BOOL isAppearFirstTime = YES;
    if (self.scrollView) {
        // contentView支持滚动
        // 调用oldController的viewWillDisappear方法
        [oldController viewWillDisappear:NO];
        if (!curController.view.superview) {
            // superview为空，表示为第一次加载，设置frame，并添加到scrollView
            curController.view.frame = CGRectMake(selectedControllerIndex * self.scrollView.frame.size.width,
                                                  0,
                                                  self.scrollView.frame.size.width,
                                                  self.scrollView.frame.size.height);
            [self.scrollView addSubview:curController.view];
        } else {
            // superview不为空，表示为已经加载过了，调用viewWillAppear方法
            isAppearFirstTime = NO;
            [curController viewWillAppear:NO];
        }
        // 切换到curController
        [self.scrollView scrollRectToVisible:curController.view.frame animated:self.contentSwitchAnimated];
    } else {
        // contentView不支持滚动
        // 将oldController的view移除
        if (oldController) {
            [oldController.view removeFromSuperview];
        }
        [self.view insertSubview:curController.view belowSubview:self.tabBar];
        // 设置curController.view的frame
        if (!CGRectEqualToRect(curController.view.frame, self.contentViewFrame)) {
            curController.view.frame = self.contentViewFrame;
        }
    }
    
    // 当contentView为scrollView及其子类时，设置它支持点击状态栏回到顶部
    if (oldController && [oldController.view isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *)oldController.view setScrollsToTop:NO];
    }
    if ([curController.view isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *)curController.view setScrollsToTop:YES];
    }
    
    _selectedControllerIndex = selectedControllerIndex;
    
    // 调用状态切换的回调方法
    [oldController tabItemDidDeselected];
    [curController tabItemDidSelected];
    if (self.scrollView) {
        [oldController viewDidDisappear:NO];
        if (!isAppearFirstTime) {
            [curController viewDidAppear:NO];
        }
    }
}

- (UIViewController *)selectedController {
    if (self.selectedControllerIndex >= 0) {
        return self.viewControllers[self.selectedControllerIndex];
    }
    return nil;
}

#pragma mark - MSTabBarDelegate
- (void)MS_tabBar:(MSTabBar *)tabBar didSelectedItemAtIndex:(NSInteger)index {
    if (index == self.selectedControllerIndex) {
        return;
    }
    self.selectedControllerIndex = index;
}


@end

@implementation UIViewController (MSTabBarController)

- (NSString *)MS_tabItemTitle {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMS_tabItemTitle:(NSString *)MS_tabItemTitle {
    objc_setAssociatedObject(self, @selector(MS_tabItemTitle), MS_tabItemTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIImage *)MS_tabItemImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMS_tabItemImage:(UIImage *)MS_tabItemImage {
    objc_setAssociatedObject(self, @selector(MS_tabItemImage), MS_tabItemImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)MS_tabItemSelectedImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMS_tabItemSelectedImage:(UIImage *)MS_tabItemSelectedImage {
    objc_setAssociatedObject(self, @selector(MS_tabItemSelectedImage), MS_tabItemSelectedImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MSTabItem *)MS_tabItem {
    MSTabBar *tabBar = self.MS_tabBarController.tabBar;
    NSInteger index = [self.MS_tabBarController.viewControllers indexOfObject:self];
    return tabBar.items[index];
}

- (MSTabBarController *)MS_tabBarController {
    return (MSTabBarController *)self.parentViewController;
}

- (void)tabItemDidSelected {
    
}

- (void)tabItemDidDeselected {
    
}

@end
