//
//  ConversationManager.h
//  JSHereoSer
//
//  Created by zougyor on 2017/11/18.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HyphenateLite/HyphenateLite.h>
@interface ConversationManager : NSObject

+(void)sendCMD:(NSString*)body to:(NSString*)uid;
+(void)sendMsg:(NSString*)body to:(NSString*)uid;
+(void)requireHeartBeat:(NSString*)uid;
+(void)sendHeartBeat:(NSString*)uid;
+(void)login:(NSString*)uid pwd:(NSString*)pwd completion:(void(^)(BOOL isSuc))blk;

@end
