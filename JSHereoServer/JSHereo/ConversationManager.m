//
//  ConversationManager.m
//  JSHereoSer
//
//  Created by zougyor on 2017/11/18.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "ConversationManager.h"
#import "NWFToastView.h"
static ConversationManager * _conMer;

@interface ConversationManager()<EMClientDelegate,EMChatManagerDelegate>
{
    
}
@property NSString * uid;
@property (nonatomic,copy) void (^loginBlk)(BOOL);

@end

@implementation ConversationManager

+(ConversationManager*)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _conMer = [[ConversationManager alloc] init];
    });
    return _conMer;
}
+(void)sendCMD:(NSString *)body to:(NSString *)uid
{
    
}
+(void)sendMsg:(NSString *)body to:(NSString *)uid
{
    
}
+(void)login:(NSString *)uid pwd:(NSString *)pwd completion:(void (^)(BOOL))blk
{
    [[EMClient sharedClient] addDelegate:[self manager] delegateQueue:nil];
   
    [NWFToastView showProgress:@"正在登录.."];
    [[EMClient sharedClient] loginWithUsername:uid password:pwd completion:^(NSString *aUsername, EMError *aError) {
        [NWFToastView dismissProgress];
        [self manager].uid = uid;
        _conMer.loginBlk = blk;
        if (!aError) {
            NSLog(@"登录成功");
            
        }
        blk(aError == nil);
        
        //注册消息回调
        [[EMClient sharedClient].chatManager addDelegate:[self manager] delegateQueue:nil];


    }];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        EMError *error = [[EMClient sharedClient] loginWithUsername:uid password:pwd];
//        [self manager].uid = uid;
//        _conMer.loginBlk = blk;
//        if (!error) {
//            NSLog(@"登录成功");
//
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            blk(error == nil);
//
//        });
//
//    });
    
}
- (void)userAccountDidForcedToLogout:(EMError *)aError
{
    NSLog(@"强制被退");
    [NWFToastView showToast:@"被管理员退出了此账号"];
    UINavigationController * navi = [UIApplication sharedApplication].keyWindow.rootViewController;
    [navi popToRootViewControllerAnimated:YES];
    
    
}
- (void)userAccountDidLoginFromOtherDevice
{
    NSLog(@"强制被退");
    [NWFToastView showToast:@"被他人登录了此账号"];
    UINavigationController * navi = [UIApplication sharedApplication].keyWindow.rootViewController;
    [navi popToRootViewControllerAnimated:YES];
    
    
    
}




@end
