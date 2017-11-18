//
//  JSBusiness.h
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSBusiness : NSObject
@property (nonatomic,strong) NSString * count;
@property (nonatomic,strong) NSString * date;
@property (nonatomic,strong) NSString * userName;
@property (nonatomic,strong) NSString * productName;
@property (nonatomic,strong) NSString * price;

@property (nonatomic,strong) NSString * floatBenifit;
@property (nonatomic,assign) BOOL isBuy;

@property (nonatomic,assign) BOOL isClose;

-(NSString *)identifier;

@end
