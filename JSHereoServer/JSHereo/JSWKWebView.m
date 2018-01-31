//
//  JSWKWebView.m
//  JSHereo
//
//  Created by zougyor on 2017/11/18.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "JSWKWebView.h"
#import "JSConfig.h"
@implementation JSWKWebView

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
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    }

    [_timer invalidate];
    _timer = nil;
    _webView.navigationDelegate = self;
    [_webView loadRequest:request];
    _request =request;
    if (self.readNow) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[self readWebDoc];
            [self startTimer];
        });
    }
}
-(void)startTimer{
    [_timer invalidate];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:[JSConfig flushInterval] target:self selector:@selector(readWebDoc) userInfo:nil repeats:YES];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
    [self startTimer];
    
    [self readWebDoc];

    
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
    
    [self loadRequest:_request completion:_blk];
    
    
}
-(void)readWebDoc
{
  
    [_webView evaluateJavaScript:@"document.documentElement.innerHTML" completionHandler:^(id _Nullable html, NSError * _Nullable error) {
        if (_blk) {
            _blk(error,html);
        }

    }];

}

@end
