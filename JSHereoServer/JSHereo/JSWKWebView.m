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
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [_timer invalidate];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:[JSConfig flushInterval] target:self selector:@selector(readWebDoc) userInfo:nil repeats:YES];
    
    [self readWebDoc];
    NSLog(@"end load");
    
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
