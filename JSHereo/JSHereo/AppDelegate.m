//
//  AppDelegate.m
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self.manager startUpdatingLocation];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
   
    return YES;
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
