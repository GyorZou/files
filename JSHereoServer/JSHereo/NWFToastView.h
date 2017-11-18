//
//  NWFToastView.h
//  ewj
//
//  Created by jp007 on 15/8/11.
//  Copyright (c) 2015年 cre.crv.ewj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NWFToastView : NSObject

+ (void)showToast:(NSString *)message;
+ (void)showToast:(NSString *)message atView:(UIView*)view;
+ (void)dismissToast;

+ (void)showProgress:(NSString *)message inView:(UIView*)view;

+ (void)dismissProgressInView:(UIView*)view;


+ (void)showProgress:(NSString *)message;
+ (void)dismissProgress;
+ (void)dismissProgressDelay:(CGFloat)time;

@end
