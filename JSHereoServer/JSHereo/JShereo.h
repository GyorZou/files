//
//  JShereo.h
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSBusiness.h"
@interface JShereo : NSObject

@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * uid;
@property (nonatomic,strong) NSString * avatar;

@property (nonatomic,strong) NSString * floatBenifit;
@property (nonatomic,strong) NSString * totalMoney;

@property (nonatomic,strong) NSString * storeCount;
@property (nonatomic,strong) NSString * historyCount;
@property (nonatomic,strong) NSArray * businesses;

@end
