//
//  NWFToastView.m
//  ewj
//
//  Created by jp007 on 15/8/11.
//  Copyright (c) 2015年 cre.crv.ewj. All rights reserved.
//

#import "NWFToastView.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#define TOAST_DURATION 4
#define TOAST_LONG  2000
#define TOAST_SHORT 1000
#define NWF_APP_WINDOW  [[UIApplication sharedApplication] keyWindow]
#define kToast_View_Tag 1024

#define kCBToastPadding         20
#define kCBToastMaxWidth        220
#define kCBToastCornerRadius    4.0
#define kCBToastFadeDuration    0.5
#define kCBToastTextColor       [UIColor whiteColor]
#define kCBToastBottomPadding   30

@implementation NWFToastView

#pragma mark - ToastView
+(void)showToast:(NSString *)message atView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // build the toast label
        UILabel *toast = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        toast.text = message;
        toast.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        toast.textColor = kCBToastTextColor;
        toast.numberOfLines = 1000;
        toast.tag = kToast_View_Tag;
        toast.textAlignment = NSTextAlignmentCenter;
        toast.lineBreakMode = NSLineBreakByWordWrapping;
        toast.font = [UIFont systemFontOfSize:14.0f];
        toast.layer.cornerRadius = kCBToastCornerRadius;
        toast.layer.masksToBounds = YES;
        
        // resize based on message
        CGSize maximumLabelSize = CGSizeMake(kCBToastMaxWidth, 9999);
        CGSize expectedLabelSize = [toast.text boundingRectWithSize:maximumLabelSize
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:toast.font}
                                                            context:nil].size;
        //adjust the label to the new height
        CGRect newFrame = toast.frame;
        newFrame.size = CGSizeMake(expectedLabelSize.width + kCBToastPadding,
                                   expectedLabelSize.height + kCBToastPadding);
        toast.frame = newFrame;
        
        // add the toast to the root window (so it overlays everything)
        if ([toast.text length] > 0) {
            [view addSubview:toast];
            
            // get the window frame to determine placement
            CGRect windowFrame = view.frame;
            
            // align the toast properly
            toast.center = CGPointMake(windowFrame.size.width / 2, windowFrame.size.height / 2);
            
            // round the x/y coords so they aren't 'split' between values (would appear blurry)
            toast.frame = CGRectMake(round(toast.frame.origin.x),
                                     round(toast.frame.origin.y),
                                     toast.frame.size.width,
                                     toast.frame.size.height);
            
            // set up the fade-in
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:kCBToastFadeDuration];
            
            // values being aninmated
            toast.alpha = 1.0f;
            
            // perform the animation
            [UIView commitAnimations];
            
            // calculate the delay based on fade-in time + display duration
            NSTimeInterval delay = TOAST_DURATION;
            
            // set up the fade out (to be performed at a later time)
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:delay];
            [UIView setAnimationDuration:kCBToastFadeDuration];
            [UIView setAnimationDelegate:toast];
            [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
            
            // values being animated
            toast.alpha = 0.0f;
            
            // commit the animation for being performed when the timer fires
            [UIView commitAnimations];
        }
    });

}
+ (void)showToast:(NSString *)message {
    [self showToast:message atView:NWF_APP_WINDOW];
}

+ (void)dismissToast {
    UILabel *toast = (UILabel *)NWF_APP_WINDOW.subviews.lastObject;
    
    if (toast.tag == kToast_View_Tag) {
        [toast removeFromSuperview];
    }
}


#pragma mark - ProgressView
+ (void)showProgress:(NSString *)message {

    [self showProgress:message inView:NWF_APP_WINDOW];
}

+ (void)dismissProgress {
    [self dismissProgressInView:nil];
}
+ (void)dismissProgressDelay:(CGFloat)time
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissProgress];
    });
}

+ (void)showProgress:(NSString *)message inView:(UIView*)view
{
    
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor blackColor];
    message = nil;
    if (view == nil) {
        view = NWF_APP_WINDOW;
    }


    if ([NSThread isMainThread]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.label.text = message;
       
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        
        hud.bezelView.color = [UIColor clearColor];
        [hud showAnimated:YES];
        hud.alpha = 0.5;
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
            hud.label.text = message;
            hud.bezelView.color = [UIColor clearColor];
            hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            [hud showAnimated:YES];
            hud.alpha = 0.5;
        });
    }

}

+ (void)dismissProgressInView:(UIView*)view
{
    if (view == nil) {
        view = NWF_APP_WINDOW;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];
    });

}

@end
