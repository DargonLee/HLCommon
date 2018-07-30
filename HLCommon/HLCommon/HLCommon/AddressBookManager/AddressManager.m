//
//  AddressManager.m
//  xiaoxinyong
//
//  Created by 稻草人lxh on 2017/9/12.
//  Copyright © 2017年 xiaoxinyong. All rights reserved.
//
//  联系人Manager

#import "AddressManager.h"
#import "XXYContactHelper.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddressManager ()<ABPeoplePickerNavigationControllerDelegate>

@property (strong, nonatomic) XXYContactHelper *contactHelper;

@end

@implementation AddressManager

+ (AddressManager *)manager {
    
    static AddressManager *dataManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dataManager = [[AddressManager alloc] init];
    });
    
    return dataManager;
}

- (XXYContactHelper *)contactHelper {
    if (!_contactHelper) {
        _contactHelper = [[XXYContactHelper alloc] init];
    }
    
    return _contactHelper;
}

// 打开通讯录选择联系人
- (void)requestAccessContactInVC:(UIViewController *)inVC {
    
    [self.contactHelper requestAccessContactComplete:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self pickContactInVC:inVC];
            });
            
        }
        else {
            [self showAlertWithTitle:@"您的通讯录权限已被限制" message:@"点击手机设置－隐私－通讯录－好人品小助手－开启访问的功能即可" inVC:inVC];
        }
    }];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message inVC:(UIViewController *)inVC {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的通讯录权限已被限制" message:@"点击手机设置－隐私－通讯录－好人品小助手－开启访问的功能即可" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"等会吧" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"立即设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openSettings];
    }]];
    
    
    [inVC presentViewController:alert animated:true completion:nil];
}

- (void)openSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)pickContactInVC:(UIViewController *)inVC {
    ABPeoplePickerNavigationController *vc = [[ABPeoplePickerNavigationController alloc] init];
    __weak id weakSelf = self;
    vc.peoplePickerDelegate = weakSelf;
    
    [inVC presentViewController:vc animated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person {
    
    NSString *fullname = [XXYContactHelper fullnameForPerson:person];
    NSString *phoneString = [XXYContactHelper phoneStringForPerson:person];
    
    phoneString = [self replacePhone:phoneString];
    
    
    if (self.delegate) {
        [self.delegate addressManager:self didSelectAddressName:fullname phone:phoneString];
    }
    
    [peoplePicker dismissViewControllerAnimated:true completion:nil];
}

-(NSString *)replacePhone:(NSString *)phone{
    // 准备对象
    NSString * searchStr = phone;
    searchStr = [self replaceRegExp:@"^(\\+86)" WithPhone:phone WithreplacStr:@""];
   
    searchStr = [self replaceRegExp:@"^(86)" WithPhone:searchStr WithreplacStr:@""];
    
    searchStr = [self replaceRegExp:@"-" WithPhone:searchStr WithreplacStr:@""];
    
//    NSArray *arr = [searchStr componentsSeparatedByString:@" "];
//    searchStr = [self replaceRegExp:@"  " WithPhone:searchStr WithreplacStr:@""];
//   searchStr = [[searchStr mutableCopy] stringByReplacingOccurrencesOfString:@" " withString:@""];
    searchStr = [[searchStr componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    
    return searchStr;
    
}

-(NSString *)replaceRegExp:(NSString *)regExpStr WithPhone:(NSString *)phone WithreplacStr:(NSString *)replaceStr{
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regExpStr
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];
    NSString *resultStr = phone;
    // 替换匹配的字符串为 searchStr
    resultStr = [regExp stringByReplacingMatchesInString:phone
                                                 options:NSMatchingReportProgress
                                                   range:NSMakeRange(0, phone.length)
                                            withTemplate:replaceStr];
    return resultStr;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [peoplePicker dismissViewControllerAnimated:true completion:nil];
}

@end
