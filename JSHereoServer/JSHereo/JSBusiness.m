//
//  JSBusiness.m
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "JSBusiness.h"

@implementation JSBusiness
-(void)setDate:(NSString *)date
{
    date = [date stringByReplacingOccurrencesOfString:@" " withString:@""];
    date = [date stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    _date = date;
    
}
-(void)setUserName:(NSString *)userName
{
    userName = [userName stringByReplacingOccurrencesOfString:@" " withString:@""];
    userName = [userName stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    _userName = userName;
}
-(void)setProductName:(NSString *)productName
{
    productName = [productName stringByReplacingOccurrencesOfString:@" " withString:@""];
    productName = [productName stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    _productName = productName;
}
-(void)setCount:(NSString *)count
{   count = [count stringByReplacingOccurrencesOfString:@" " withString:@""];
    count = [count stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    _count = count;
    
}
-(void)setPrice:(NSString *)price
{
    price = [price stringByReplacingOccurrencesOfString:@" " withString:@""];
    price = [price stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    _price = price;
    
}
-(BOOL)isEqual:(id)object
{
    
    if ([object isKindOfClass:[self class]]) {
        JSBusiness *jb = object;
        if ([[self identifier] isEqualToString:[jb identifier] ]) {
            return YES;
        }
    }
    return NO;
    
}
-(NSString *)identifier
{
    return [NSString stringWithFormat:@"%@_%@",_productName,_date];
}
@end
