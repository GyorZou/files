//
//  JSPriceListhner.h
//  JSHereoSer
//
//  Created by jp007 on 2017/11/22.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSWebView.h"
@interface JSPriceListhner : NSObject
{
    JSWebView * _webView;
    void (^_handler)(NSArray *);
}

-(void)startWithDataHandler:(void(^)(NSArray *))blk;


@end
