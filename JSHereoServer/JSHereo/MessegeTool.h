//
//  MessegeTool.h
//  JSHereoSer
//
//  Created by zougyor on 2017/11/18.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HyphenateLite/HyphenateLite.h>
@interface MessegeTool : NSObject
+(void)sendLocalNoti:(NSString*)body;
//
+(NSDictionary*)extForHeroLishenerMsg:(NSString*)hid isAdd:(BOOL)add;

+(NSDictionary*)extForHeroLishenerMsgResponse:(NSString*)hid isAdd:(BOOL)add;

+(NSDictionary*)extForHeartBeatMsg;

+(BOOL)isAvailableextForHeroLishenerMsg:(EMMessage*)msg;

+(BOOL)isAvailableextForHeroLishenerMsgResponse:(EMMessage *)msg;
@end
