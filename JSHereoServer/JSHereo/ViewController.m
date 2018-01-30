//
//  ViewController.m
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "ViewController.h"
#import "JSWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "XPathQuery.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "JSHereoListhener.h"
#import "JSPriceListhner.h"
@interface ViewController ()<UIWebViewDelegate>
{
    JSContext * _context;
    JSHereoListhener * _ls;
    JSPriceListhner * _jp;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
//    _jp = [[JSPriceListhner alloc] init];
//    
//    [_jp startWithDataHandler:^(NSArray * arr) {
//        
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end
