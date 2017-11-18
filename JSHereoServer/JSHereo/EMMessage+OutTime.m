//
//  EMMessage+OutTime.m
//  JSHereoSer
//
//  Created by zougyor on 2017/11/18.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "EMMessage+OutTime.h"

@implementation EMMessage (OutTime)
-(BOOL)isOuttime
{
    long long time = self.localTime/1000;
    long long now = [[NSDate date] timeIntervalSince1970];
    if (now - time > 60) {
        return YES;
    }
    return NO;
}
@end
