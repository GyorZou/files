//
//  JSWKWebView.h
//  JSHereo
//
//  Created by zougyor on 2017/11/18.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "JSWebView.h"
#import <WebKit/WebKit.h>
@interface JSWKWebView : JSWebView<WKNavigationDelegate>

{
    WKWebView * _webView;
}
@end
