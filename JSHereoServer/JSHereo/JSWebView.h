//
//  JSWebView.h
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
//@interface JSWebView : WKWebView
@interface JSWebView : UIView

{
    NSURLRequest * _request;
    NSTimer * _timer;
    void (^_blk)(NSError*err,NSString*);
}
@property (nonatomic,assign) BOOL readNow;

-(void)stop;
-(void)loadRequest:(NSURLRequest *)request completion:(void(^)(NSError*err,NSString*html))blk;
@end
