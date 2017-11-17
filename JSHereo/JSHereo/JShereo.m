//
//  JShereo.m
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "JShereo.h"

@implementation JShereo

-(NSString *)description
{
    
    return [NSString stringWithFormat:@"%@,name=%@;holding count=%ld;floatBenit = %@,total money= %@",[super description],_name,_businesses.count,_floatBenifit,_totalMoney];
}
@end
