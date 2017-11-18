//
//  NoticesTableViewCell.h
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticesTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel * nameLabel;
@property (nonatomic,weak) IBOutlet UILabel * productLabel;
@property (nonatomic,weak) IBOutlet UILabel * priceLabel;
@property (nonatomic,weak) IBOutlet UILabel * dateLabel;
@property (nonatomic,weak) IBOutlet UILabel * numLabel;
@property (nonatomic,weak) IBOutlet UILabel * inoutLabel;

@property (nonatomic,weak) IBOutlet UILabel * floatLabel;

@end
