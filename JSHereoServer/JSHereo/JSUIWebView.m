//
//  JSUIWebView.m
//  JSHereo
//
//  Created by zougyor on 2017/11/18.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "JSUIWebView.h"
#import "JSConfig.h"
@implementation JSUIWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)loadRequest:(NSURLRequest *)request completion:(void (^)(NSError *, NSString *))blk
{
    _blk = blk;
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    
    [_timer invalidate];
    _timer = nil;
    _webView.delegate = self;
    [_webView loadRequest:request];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [_timer invalidate];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:[JSConfig flushInterval] target:self selector:@selector(readWebDoc) userInfo:nil repeats:YES];
    
    [self readWebDoc];
    NSLog(@"end load");
    
}


-(void)readWebDoc
{
    

    UIWebView * webView = _webView;
    NSString * value = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    if (_blk) {
        _blk(nil,value);
    }
    
}
@end
