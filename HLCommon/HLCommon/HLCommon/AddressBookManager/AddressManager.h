//
//  AddressManager.h
//  xiaoxinyong
//
//  Created by 稻草人lxh on 2017/9/12.
//  Copyright © 2017年 xiaoxinyong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AddressManager;
@protocol AddressManagerDelegate <NSObject>

- (void)addressManager:(AddressManager *)manager didSelectAddressName:(NSString *)name phone:(NSString *)phone;

@end


@interface AddressManager : NSObject

@property (nonatomic, assign) id <AddressManagerDelegate> delegate;

@property (nonatomic, assign) NSInteger tag;                            

+ (AddressManager *)manager;

// 打开通讯录选择联系人
- (void)requestAccessContactInVC:(UIViewController *)inVC;

@end
