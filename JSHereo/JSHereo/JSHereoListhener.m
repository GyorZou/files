//
//  JSHereoListhener.m
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "JSHereoListhener.h"
#import <UIKit/UIKit.h>
#import "JSWebView.h"
#import "XPathQuery.h"
#import "TFHpple.h"
#import "TFHppleElement.h"


#define  BEATSNUM 10
@interface JSHereoListhener()<UIWebViewDelegate,WKNavigationDelegate>
{
    JSWebView * _webView;
    JShereo * _hereo;
    float _isOn;
    NSTimer * _timer;
    int _initialCount;
}
@end

@implementation JSHereoListhener
-(void)stop
{
    _isOn = NO;
    [_timer invalidate];
    _timer = nil;
    _heartBeat = BEATSNUM;
    _initialCount = 0;
}
-(void)startListhenHereo:(JShereo *)hereo
{
   
    [self stop];
    
    _isOn = YES;
    _hereo = hereo;
   
    _hereo.businesses = nil;
 
    
    if (_webView == nil) {
        JSWebView * web = [[JSWebView alloc] initWithFrame:CGRectZero];
        
        _webView = web;
    }


    NSString * url =[NSString stringWithFormat:@"https://hero.jin10.com/#/personal_center/%@",hereo.uid];
    NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:1 timeoutInterval:30];
    [_webView loadRequest:req];
    _webView.navigationDelegate = self;
   //_webView.delegate = self;
    
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [_timer invalidate];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:[JSConfig flushInterval] target:self selector:@selector(readWebDoc) userInfo:nil repeats:YES];
    
    [self readWebDoc];
    NSLog(@"end load");
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start load");
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
    
    _initialCount++;
    
    JSWebView * webView = _webView;
//    NSString * value = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
//     dispatch_async(dispatch_get_global_queue(0, 0), ^{
//       [self handleHtml:value];
//     });
    [webView evaluateJavaScript:@"document.documentElement.innerHTML" completionHandler:^(id _Nullable html, NSError * _Nullable error) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self handleHtml:html];
        });

    }];


    
   
}
-(void)handleHtml:(NSString*)value
{
    
    NSData *data=[value dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    
    
    
    
    
    NSString * avatarkey = @"hero-user-details__avatar";
    NSString * nickKey = @"hero-user-details__nick";
    NSString * dataKey = @"hero-trader-details__h-value";//浮动阴亏
    
    
    NSArray * elements  = [doc searchWithXPathQuery:[NSString stringWithFormat:@"//h4[@class='%@']",nickKey]];
    
    TFHppleElement * e = [elements firstObject];
    _hereo.name = [[e firstChild] content];
    
    
    elements  = [doc searchWithXPathQuery:[NSString stringWithFormat:@"//div[@class='%@']",dataKey]];
    
    e = [elements firstObject];
    elements  = [e searchWithXPathQuery:@"//span"];
    NSString * fb = [[elements firstObject] content];
    if ([fb isEqualToString:_hereo.floatBenifit]) {//
        _heartBeat--;
    }else{
        _heartBeat=BEATSNUM;
    }
    
    _hereo.floatBenifit = fb;
    
    dataKey = @"hero-trader-details__value";
    elements  = [doc searchWithXPathQuery:[NSString stringWithFormat:@"//dd[@class='%@']",dataKey]];
    
    e = [elements firstObject];
    elements  = [e searchWithXPathQuery:@"//b"];
    _hereo.totalMoney = [[elements firstObject] content];
    
    
    
    elements  = [doc searchWithXPathQuery:@"//div[@class='jin10-table__body-wrapper']"];
    
    TFHppleElement * current = [elements firstObject];
    
    elements = [current searchWithXPathQuery:@"//tr"];;
    
    NSMutableArray * temp = [NSMutableArray arrayWithCapacity:elements.count];
    for (TFHppleElement * ele in elements) {
        JSBusiness * jb = [[JSBusiness alloc] init];
        NSArray * eles =  [ele searchWithXPathQuery:@"//div[@class='cell']"];
        if (eles.count == 8) {
            TFHppleElement * e = eles[0];
            jb.date = e.content;
            e = eles[1];
            jb.productName =e.content;
            jb.userName = _hereo.name;
            e = eles[2];
            
            jb.isBuy =  [e.raw rangeOfString:@"hero-icon_fall"].location == NSNotFound;
            
            e = eles[3];
            
            jb.count = e.content;
            
            
            e = eles[6];
            jb.price = e.content;
            
            e = eles[7];
            jb.floatBenifit = e.content;
            [temp addObject:jb];
        }else{
            //异常
        }
        
    }
    //这里对比下差异
    //1、看下有没有平掉的，旧的里包含新的里没有的
    NSArray * old = _hereo.businesses;
    for(JSBusiness * jb in old){
        BOOL contain = [temp containsObject:jb];
        if (contain == NO) {
            //这个jb被卖了
            [self notify:jb directionIn:NO];//平了
        }
    }
    
    //2、看下有没有新加的，看下新的里有没有旧的没有的
    
    if(old&&_initialCount>3){
        for(JSBusiness * jb in temp){
            BOOL contain = [old containsObject:jb];
            if (contain == NO) {
                //这个jb被买了
                
                [self notify:jb directionIn:YES];//新增了
            }
        }
    }
    
    
    _hereo.businesses = [temp copy];
    
    dispatch_async(dispatch_get_main_queue(), ^{
            if (_delegate &&[_delegate respondsToSelector:@selector(listhernerDidUpdate:)]) {
                [_delegate listhernerDidUpdate:self];
            }
    });
    
}
-(void)notify:(JSBusiness*)jb directionIn:(BOOL)isIn
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isIn) {
            if (_delegate && [_delegate respondsToSelector:@selector(listhener:didAddBusiness: )]) {
                [_delegate listhener:self didAddBusiness:jb];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(listhener:didcCloseBusiness: )]) {
                [_delegate listhener:self didcCloseBusiness:jb];
            }
        }
    });

    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"web error ");
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"loading web req:%@",request.URL.absoluteString);
    return YES;
    
}

@end
