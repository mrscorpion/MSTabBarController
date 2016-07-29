//
//  ViewController.m
//  MSTabBarController
//
//  Created by mr.scorpion on 15/8/11.
//  Copyright (c) 2015年 MSTabBarController. All rights reserved.
//

#import "ViewController.h"
#import "MSTabBarController.h"
#import "RootTabController.h"
@interface ViewController ()
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, tMSically from a nib.
//    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.label.text = self.MS_tabItemTitle;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"按钮" forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 100, 50);
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

//    [self.view addSubview:button];
    NSLog(@"viewDidLoad--->%@", self.MS_tabItemTitle);
}
- (IBAction)buttonClicked:(UIButton *)button {
//    self.MS_tabBarController.contentViewFrame = CGRectMake(0, 64, 300, 500);
    [self.navigationController pushViewController:[[ViewController alloc] init] animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear--->%@ %@", NSStringFromClass(self.class), self.MS_tabItemTitle);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear--->%@ %@", NSStringFromClass(self.class), self.MS_tabItemTitle);
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear--->%@ %@", NSStringFromClass(self.class), self.MS_tabItemTitle);
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear--->%@ %@", NSStringFromClass(self.class), self.MS_tabItemTitle);
}

- (void)tabItemDidDeselected {
    NSLog(@"Deselected--->%@ %@", NSStringFromClass(self.class), self.MS_tabItemTitle);
}

- (void)tabItemDidSelected {
    NSLog(@"Selected--->%@ %@", NSStringFromClass(self.class), self.MS_tabItemTitle);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)doubleClicked {
    NSLog(@"doubleClicked");
}

@end
