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
@interface ViewController ()<UIWebViewDelegate>
{
    JSContext * _context;
    JSHereoListhener * _ls;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end
