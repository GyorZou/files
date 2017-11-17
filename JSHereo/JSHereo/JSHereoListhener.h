//
//  JSHereoListhener.h
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JShereo.h"
#import "JSConfig.h"

@protocol JSHereoDelegate;

@interface JSHereoListhener : NSObject

@property (nonatomic,strong,readonly) JShereo * hereo;
@property (nonatomic,weak) id<JSHereoDelegate> delegate;
@property (nonatomic,assign,readonly) int heartBeat;
-(void)startListhenHereo:(JShereo*)hereo;
-(void)stop;
@end



@protocol JSHereoDelegate<NSObject>

-(void)listhener:(JSHereoListhener*)ls didAddBusiness:(JSBusiness*)b;
-(void)listhener:(JSHereoListhener*)ls didcCloseBusiness:(JSBusiness*)b;

-(void)listhernerDidUpdate:(JSHereoListhener*)ls;



@end
