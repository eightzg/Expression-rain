//
//  AppDelegate.m
//  emojiTest
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 eight. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if ([UIDevice currentDevice].systemVersion.doubleValue <= 8.0) {
        // 不是iOS8
        UIRemoteNotificationType type = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        // 当用户第一次启动程序时就获取deviceToke
        // 该方法在iOS8以及过期了
        // 只要调用该方法, 系统就会自动发送UDID和当前程序的Bunle ID到苹果的APNs服务器
        [application registerForRemoteNotificationTypes:type];
    }else
    {
        // iOS8
        UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        // 注册通知类型
        [application registerUserNotificationSettings:settings];
        
        // 申请试用通知
        [application registerForRemoteNotifications];
    }
    
    //    // 1.取出数据
    //    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    //
    //    if (userInfo) {
    //        static int count = 0;
    //        count++;
    //        UILabel *label = [[UILabel alloc] init];
    //        label.frame = CGRectMake(0, 40, 200, 200);
    //        label.numberOfLines = 0;
    //        label.textColor = [UIColor whiteColor];
    //        label.font = [UIFont systemFontOfSize:11];
    //        label.backgroundColor = [UIColor orangeColor];
    //        label.text = [NSString stringWithFormat:@" %@ \n %d", userInfo, count];
    //        [self.window.rootViewController.view addSubview:label];
    //    }
    
    
    return YES;
}

/**
 *  获取到用户对应当前应用程序的deviceToken时就会调用
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%@", deviceToken);
    // <47e58207 31340f18 ed83ba54 f999641a 3d68bc7b f3e2db29 953188ec 7d0cecfb>
    // <286c3bde 0bd3b122 68be655f 25ed2702 38e31cec 9d54da9f 1c62325a 93be801e>
}

//连接APNs失败时候调用
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"_______________");
    //    BmobUser *user = [BmobUser getCurrentUser];
    //    if (user) {
    //        [self connectToServer];
    //    }
}

@end
