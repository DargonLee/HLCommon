//
//  XXYMainTabbarViewController.m
//  HLNeiHanDuanZI
//
//  Created by DragonLee on 2017/10/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "XXYMainTabbarViewController.h"
#import "XXYBaseNavigationViewController.h"
#import "XXYTabBar.h"
#import "HomeViewController.h"
#import "MeViewController.h"
#import "LoginViewController.h"

@interface XXYMainTabbarViewController ()<UITabBarControllerDelegate>

@end

@implementation XXYMainTabbarViewController

+ (void)initialize
{
    //设置为不透明
    [[UITabBar appearance]setTranslucent:NO];
    //设置背景颜色
    [UITabBar appearance].tintColor = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
    
    // 拿到整个导航控制器的外观
    UITabBarItem * item = [UITabBarItem appearance];
    //设置底部文字的偏移
    item.titlePositionAdjustment = UIOffsetMake(0, 1.5);
    
    // 普通状态
    NSMutableDictionary * normalAtts = [NSMutableDictionary dictionary];
    normalAtts[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    normalAtts[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.56f green:0.60f blue:0.70f alpha:1.00f];
    [item setTitleTextAttributes:normalAtts forState:UIControlStateNormal];
    
    // 选中状态
    NSMutableDictionary *selectAtts = [NSMutableDictionary dictionary];
    selectAtts[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectAtts[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.21f green:0.39f blue:0.93f alpha:1.00f];
    [item setTitleTextAttributes:selectAtts forState:UIControlStateSelected];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addChildViewControllerWithClassname:[HomeViewController description] imagename:@"home" title:@"借款"];
    [self addChildViewControllerWithClassname:[MeViewController description] imagename:@"me" title:@"我的"];
//    [self setValue:[[XXYTabBar alloc]init] forKey:@"tabBar"]; //自定义tabbar
    self.delegate = self;
}

// 添加子控制器
- (void)addChildViewControllerWithClassname:(NSString *)classname
                                  imagename:(NSString *)imagename
                                      title:(NSString *)title
{
    UIViewController *vc = [[NSClassFromString(classname) alloc] init];
    XXYBaseNavigationViewController *nav = [[XXYBaseNavigationViewController alloc] initWithRootViewController:vc];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [UIImage imageNamed:imagename];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:[imagename stringByAppendingString:@"_press"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if([viewController.tabBarItem.title isEqualToString:@"我的"] && !kIsLogin){
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [tabBarController.selectedViewController pushViewController:loginVC animated:YES];
        return NO;
    }
    return YES;
}

@end
