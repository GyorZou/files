//
//  HeroTableViewCell.h
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeroTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel * nameLabel;
@property (nonatomic,weak) IBOutlet UILabel * floatBenLabel;
@property (nonatomic,weak) IBOutlet UILabel * numLabel;
@property (nonatomic,weak) IBOutlet UILabel * totalLabel;

@property (nonatomic,weak) IBOutlet UILabel * beatLabel;
@end
