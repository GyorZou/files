//
//  JSWebView.m
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "JSWebView.h"

@implementation JSWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)stop
{
    [_timer invalidate];
    _timer = nil;
}
-(void)loadRequest:(NSURLRequest *)request completion:(void (^)(NSError *, NSString *))blk
{
    
}
@end
