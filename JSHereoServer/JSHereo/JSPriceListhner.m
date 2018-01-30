//
//  JSPriceListhner.m
//  JSHereoSer
//
//  Created by jp007 on 2017/11/22.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "JSPriceListhner.h"
#import "XPathQuery.h"
#import "TFHpple.h"
#import "TFHppleElement.h"

#import "JSUIWebView.h"
#import "JSWKWebView.h"
@implementation JSPriceListhner
-(void)startWithDataHandler:(void (^)(NSArray *))blk
{
    
    if (_webView == nil) {
        //wk
        JSWebView * web = [[JSWKWebView alloc] initWithFrame:CGRectZero];
        
        //uiwev
        //  JSWebView * web = [[JSUIWebView alloc] initWithFrame:CGRectZero];
        
        
        _webView = web;
    }
    
    
    NSString * url =@"https://tickmill.com/cn/";
    NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:1 timeoutInterval:30];
    _webView.readNow = YES;
    [_webView loadRequest:req completion:^(NSError *err, NSString *html) {
        [self readWebDoc:html];
    }];
    _handler = blk;
    
    
}

-(void)readWebDoc:(NSString*)html
{
    [self handleHtml:html];
}
-(void)handleHtml:(NSString*)value
{
    
    NSData *data=[value dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    
    
    
    
    
    NSString * avatarkey = @"hero-user-details__avatar";
    NSString * nickKey = @"hero-user-details__nick";
    NSString * dataKey = @"home-intro-quotes-table";//浮动阴亏
    
    
    NSArray * elements  = [doc searchWithXPathQuery:[NSString stringWithFormat:@"//table[@class='%@']",dataKey]];
    if (elements.count == 0) {
        return;
    }
    
    TFHppleElement * e = [elements firstObject];
    //_hereo.name = [[e firstChild] content];
    
    
    elements  = [e searchWithXPathQuery:[NSString stringWithFormat:@"//tbody"]];
    
    e = [elements firstObject];

    NSArray * trs = [e childrenWithTagName:@"tr"];
    NSMutableArray * mu = [NSMutableArray arrayWithCapacity:trs.count];
    
    for (TFHppleElement * ele in trs) {
       
        NSString * string = ele.content;
        NSArray * nodes = [string componentsSeparatedByString:@" "];
        if (nodes.count == 6) {
            NSDictionary * d = @{nodes[0]:nodes[1]};
            [mu addObject:d];
        }
    }
    

    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_handler) {
            _handler([mu copy]);
        }
    });
    
}
@end
