//
//  JSConfig.m
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "JSConfig.h"
static NSUInteger _moneyHome = 10;
@implementation JSConfig

+(NSUInteger)tipMoney
{
    return _moneyHome;
}
+(void)setTipMoney:(NSUInteger)money{
    _moneyHome = money;
}
+(NSUInteger)reloadInterval
{
    return 10*60;
}
+(NSUInteger)flushInterval
{
    return 8;
}
@end
