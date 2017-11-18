//
//  MessegeTool.m
//  JSHereoSer
//
//  Created by zougyor on 2017/11/18.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "MessegeTool.h"
#import "NWFToastView.h"
@implementation MessegeTool
+(NSDictionary *)extForHeroLishenerMsg:(NSString *)hid isAdd:(BOOL)add
{
    return @{@"type":@"req",@"heroId":hid,@"action": add?@"add":@"cancel"};
}
+(NSDictionary *)extForHeroLishenerMsgResponse:(NSString *)hid isAdd:(BOOL)add
{
    return @{@"type":@"resp",@"heroId":hid,@"action": add?@"add":@"cancel"};
}
+(BOOL)isAvailableextForHeroLishenerMsg:(EMMessage *)msg
{
    NSDictionary* d = msg.ext;
    if( [d[@"type"] isEqual:@"req"]){
        if ([[d[@"heroId"] componentsSeparatedByString:@"_"] count] ==2) {
            return YES;
        }
    }
    return NO;
    
}

+(BOOL)isAvailableextForHeroLishenerMsgResponse:(EMMessage *)msg
{
    
    NSDictionary* d = msg.ext;
    if( [d[@"type"] isEqual:@"resp"]){
        if ([[d[@"heroId"] componentsSeparatedByString:@"_"] count] ==2) {
            return YES;
        }
    }
    return NO;
}
+(void)sendLocalNoti:(NSString*)body
{
    [NWFToastView showToast:body];
    UILocalNotification *localNotifi = [UILocalNotification new];
    localNotifi.alertBody = body;
    localNotifi.soundName = UILocalNotificationDefaultSoundName;
    localNotifi.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotifi];
}
@end
