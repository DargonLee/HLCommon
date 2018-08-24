//
//  NHDefaultHeader.h
//  HLNeiHanDuanZI
//
//  Created by DragonLee on 2017/11/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef NHDefaultHeader_h
#define NHDefaultHeader_h

#define kRootVC [UIApplication sharedApplication].keyWindow.rootViewController
/**
 *  弱指针
 */
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
/**
 *  强指针
 */
#define StrongSelf(strongSelf) __strong __typeof(weakSelf)strongSelf = weakSelf;
#define Real(value) ((value)/375.0f*[UIScreen mainScreen].bounds.size.width)

#pragma mark - 颜色
#define kBaseThemeMainColor [UIColor colorWithRed:0.21f green:0.39f blue:0.93f alpha:1.00f]
#define kWhiteColor [UIColor whiteColor]
#define kBlackColor [UIColor blackColor]
#define kDarkGrayColor [UIColor darkGrayColor]
#define kLightGrayColor [UIColor lightGrayColor]
#define kGrayColor [UIColor grayColor]
#define kRedColor [UIColor redColor]
#define kGreenColor [UIColor greenColor]
#define kBlueColor [UIColor blueColor]
#define kCyanColor [UIColor cyanColor]
#define kYellowColor [UIColor yellowColor]
#define kMagentaColor [UIColor magentaColor]
#define kOrangeColor [UIColor orangeColor]
#define kPurpleColor [UIColor purpleColor]
#define kBrownColor [UIColor brownColor]
#define kClearColor [UIColor clearColor]
#define kCommonGrayTextColor [UIColor colorWithRed:0.63f green:0.63f blue:0.63f alpha:1.00f]
#define kCommonRedColor [UIColor colorWithRed:0.91f green:0.33f blue:0.33f alpha:1.00f]
#define kBgColor kRGBColor(243,245,247)
#define kLineBgColor [UIColor colorWithRed:0.86f green:0.88f blue:0.89f alpha:1.00f]
#define kTextColor [UIColor colorWithRed:0.32f green:0.36f blue:0.40f alpha:1.00f]
#define kRGBAColor(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kRGBColor(r,g,b) kRGBAColor(r,g,b,1.0f)
#define kCommonBlackColor [UIColor colorWithRed:0.17f green:0.23f blue:0.28f alpha:1.00f]
#define kSeperatorColor kRGBColor(234,237,240)
#define kDetailTextColor [UIColor colorWithRed:0.56f green:0.60f blue:0.62f alpha:1.00f]
#define kCommonTintColor [UIColor colorWithRed:0.42f green:0.33f blue:0.27f alpha:1.00f]
#define kCommonBgColor [UIColor colorWithRed:0.86f green:0.85f blue:0.80f alpha:1.00f]
#define kCommonHighLightRedColor [UIColor colorWithRed:1.00f green:0.49f blue:0.65f alpha:1.00f]
#define kLeftMargin 15

#pragma mark - 系统UI
#define kNavigationBarHeight 44
#define kStatusBarHeight 20
#define kTopBarHeight 64
#define kToolBarHeight 44
#define kTabBarHeight 49
#define kiPhone4_W 320
#define kiPhone4_H 480
#define kiPhone5_W 320
#define kiPhone5_H 568
#define kiPhone6_W 375
#define kiPhone6_H 667
#define kiPhone6P_W 414
#define kiPhone6P_H 736

/***  判断iPhone X */
#define KISIphoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))

/***  当前屏幕宽度 */
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
/***  当前屏幕高度 */
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height
/***  比例值 */
#define IsIphone6P          kScreenWidth==414
#define SizeScale           (IsIphone6P ? 1.5 : 1)
/***  粗体 */
#define kBoldFont(size) [UIFont boldSystemFontOfSize:size*SizeScale]
/***  普通字体 */
#define kFont(size) [UIFont systemFontOfSize:size*SizeScale]

#define kLineHeight (1 / [UIScreen mainScreen].scale)



#define kIsIphoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))

#pragma mark - 字符串转化
#define kEmptyStr @""
#define kIntToStr(i) [NSString stringWithFormat: @"%d", i]
#define kIntegerToStr(i) [NSString stringWithFormat: @"%ld", i]


/******************本地存储的一些宏********************/
#define kLogin @"kLogin" //token
#define kIsLogin [[NSUserDefaults standardUserDefaults]valueForKey:kLogin]//登录状态
#define kCurrentAccountIndex @"CurrentAccountIndex"  //存当前钱包的索引
#define kToken @"token" //token
#define kLanguage @"currentLanguage" //当前语言设置
#define kNSNotificationRefreash @"kNSNotificationRefreash" //刷新首页
#define kNSNotificationTip @"kNSNotificationTip" //钱包已存在提示
#define kAccountIndex @"kAccountIndex" //钱包索引
#define kAccount @"account"//注册邮箱




#define kAlias @"alias"//极光推送别名
#define kAppKey @"4fd3ee9791ab94238253d03e"//极光推送AppKey
#ifdef DEBUG
#define kApsForProduction NO
#else
#define kApsForProduction YES
#endif




/**
 * 在.h文件中调用singleH(类名)
 * 在.m文件中调用singleM(类名)
 */
#define singleH(name) +(instancetype)share##name;

#define singleM(name) static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+(instancetype)share##name\
{\
return [[self alloc]init];\
}\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}

#endif /* NHDefaultHeader_h */
