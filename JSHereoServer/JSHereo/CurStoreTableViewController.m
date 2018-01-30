//
//  StoreTableViewController.m
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "CurStoreTableViewController.h"
#import "MsgTableViewCell.h"
#import "MJRefresh.h"
#import "ConversationManager.h"
#import "NWFToastView.h"
#import "MessegeTool.h"
#import "EMMessage+OutTime.h"
#import "NoticesTableViewCell.h"
@interface CurStoreTableViewController ()
{
    NSMutableDictionary * _heroNames;
    NSMutableArray * _msgs ;
    
    NSUInteger _heartRate;
   
    
}
@end

@implementation CurStoreTableViewController

-(void)dealloc
{

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"数据列表";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NoticesTableViewCell" bundle:nil] forCellReuseIdentifier:@"noti-cell"];
    
    self.tableView.rowHeight = 60;
    _heartRate = 10;
    __weak typeof(self) ws= self;
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ws.tableView reloadData];
            [ws.tableView.header endRefreshing];
        });
        
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.header =header;
    
    

    
    _msgs = [NSMutableArray arrayWithCapacity:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    return 60;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;
    
    
    NoticesTableViewCell * hcell = [tableView dequeueReusableCellWithIdentifier:@"noti-cell"];
    JSBusiness * jb = _hereo.businesses[indexPath.row];
    hcell.dateLabel.text = jb.date;
    hcell.nameLabel.text = jb.userName;
    NSString * state = @"关闭";
    UIColor * color = [UIColor lightGrayColor];
    if(jb.isClose == NO){
        state = jb.isBuy?@"买入":@"卖出";
        color = jb.isBuy?[UIColor redColor]:[UIColor greenColor];
    }
    hcell.inoutLabel.textColor = color;
    hcell.inoutLabel.text = state;
    hcell.numLabel.text = [NSString stringWithFormat:@"%@手",jb.count];
    hcell.priceLabel.text = jb.price;
    hcell.productLabel.text = jb.productName;
    if ([jb.floatBenifit floatValue]>0) {
        hcell.floatLabel.textColor = [UIColor greenColor];
    }else{
        hcell.floatLabel.textColor = [UIColor redColor];
    }
    hcell.floatLabel.text = jb.floatBenifit;
    cell = hcell;
    
    
    
    return cell;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _hereo.businesses.count;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
