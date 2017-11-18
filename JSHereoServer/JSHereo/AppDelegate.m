//
//  AppDelegate.m
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <HyphenateLite/HyphenateLite.h>
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate () <CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager* manager;
@end


@implementation AppDelegate
- (CLLocationManager *)manager {
    if (_manager == nil) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        [_manager requestWhenInUseAuthorization];
        _manager.pausesLocationUpdatesAutomatically = false;
        _manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        _manager.distanceFilter = 100.0f;
        [_manager startUpdatingLocation];
        if ([_manager respondsToSelector:@selector(allowsBackgroundLocationUpdates)]) {
            _manager.allowsBackgroundLocationUpdates = YES;
        }
    }
    
    return _manager;
}
-(void)beginBackgroundRun
{
     [self.manager startUpdatingLocation];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    UIApplication *app = [UIApplication sharedApplication];
    // 应用程序右上角数字
    app.applicationIconBadgeNumber = 0;
    
    
    
    EMOptions *options = [EMOptions optionsWithAppkey:@"1198171118178343#heropush"];
    
    options.apnsCertName = @"heropush_dev";
    EMError * err= [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    [self registerRemote];
    
    
    return YES;
}
-(void)registerRemote{
    
    UIApplication *application = [UIApplication sharedApplication];
    
    //iOS10 注册APNs
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                [application registerForRemoteNotifications];
#endif
            }
        }];
        return;
    }
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* loc = [locations firstObject];
    CLLocationCoordinate2D coordinate = loc.coordinate;
    NSLog(@"%f %f",coordinate.latitude,coordinate.longitude);
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"xx");
   // [manager requestAlwaysAuthorization];
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            if ([self.manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.manager requestWhenInUseAuthorization];
            }break;
        default:break;
    }
    
}
// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    UIApplication *app = [UIApplication sharedApplication];
    // 应用程序右上角数字
    app.applicationIconBadgeNumber = 0;

    [[EMClient sharedClient] applicationWillEnterForeground:application];
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
