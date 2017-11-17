//
//  DataTableViewController.m
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "DataTableViewController.h"
#import "JSHereoListhener.h"
#import "HeroTableViewCell.h"
#import "NoticesTableViewCell.h"
#import "NWFToastView.h"
#import "MJRefresh.h"
#import "StoreTableViewController.h"
#define  TIPLEVEL 50
#define TIPCOUNT 100
@interface DataTableViewController ()<JSHereoDelegate>
{
    NSMutableArray * _businesses;
    NSMutableArray * _hereoes;
    
    JSHereoListhener * _mySelf;
    NSArray * _lastBs;
    
    NSMutableDictionary * _lastInfo;
    NSCalendar * _myCalendar;
}
@end

@implementation DataTableViewController
-(void)didReceiveMemoryWarning
{
    [self sendLocalNoti:@"内存很高，请处理下"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSCalendar * myCalendar = [NSCalendar currentCalendar];
    myCalendar.timeZone = [NSTimeZone systemTimeZone];
    _myCalendar = myCalendar;
    
    
    //763985_15461
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _lastInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    self.title = @"数据为王";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HeroTableViewCell" bundle:nil] forCellReuseIdentifier:@"hero-cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NoticesTableViewCell" bundle:nil] forCellReuseIdentifier:@"noti-cell"];
    _businesses = [NSMutableArray arrayWithCapacity:0];
    _hereoes = [NSMutableArray arrayWithCapacity:0];
    
    
    
    
    JSHereoListhener*  ls = [[JSHereoListhener alloc] init];
    JShereo * h = [[JShereo alloc] init];
    h.uid = @"763985_15461";
    [ls startListhenHereo:h];
    
    [_hereoes addObject:ls];
    ls.delegate = self;
    
    _mySelf = ls;
    
    [self addHero:@"752318_14154"];
    
    //[self addHero:@"688479_10597"];高平
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadData];
        
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.header =header;
    
    self.navigationItem.leftBarButtonItem = [self backItem];
  
    self.navigationItem.rightBarButtonItem = [self rightItem];
    
}
-(void)toggle:(UIButton*)btn
{
    btn.selected = !btn.selected;
    
        for (JSHereoListhener * ls in _hereoes) {
            [ls stop];
            if (btn.selected) {
               [ls startListhenHereo:ls.hereo];
            }
        }
  
    
}
-(UIBarButtonItem *)backItem
{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 50, 30);
    [backBtn setTitle:@"停止" forState:UIControlStateSelected];
    [backBtn setTitle:@"开始" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backBtn.selected = YES;
    [backBtn addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];


    return [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
-(UIBarButtonItem *)rightItem
{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 50, 30);
    [backBtn setTitle:@"新增" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(addHero) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
-(void)addHero{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加英雄" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入英雄的id";
        
    }];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *login = alertController.textFields.firstObject;
        
        [self addHero:login.text];
       
    }];
    [alertController addAction:action];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    
    }];
    
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
  

}
-(void)loadData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.tableView.header endRefreshing];
    });
    
    for (JSHereoListhener * ls in _hereoes) {
        [ls stop];
        [ls startListhenHereo:ls.hereo];
    }
   
}
-(void)addHero:(NSString*)hid{
    if ([hid componentsSeparatedByString:@"_"].count !=2) {
        [NWFToastView showToast:@"id不合法"];
        return;
    }
    JSHereoListhener*  ls = [[JSHereoListhener alloc] init];
    JShereo * h = [[JShereo alloc] init];
    h.uid = hid;
    [ls startListhenHereo:h];
    
    [_hereoes addObject:ls];
    ls.delegate = self;
    [self.tableView reloadData];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    
    return 60;
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return _hereoes.count;
    }
    return _businesses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        HeroTableViewCell * hcell = [tableView dequeueReusableCellWithIdentifier:@"hero-cell"];
        JSHereoListhener * jl = _hereoes[indexPath.row];
        JShereo * h = [jl hereo];
        hcell.nameLabel.text = h.name;
        hcell.totalLabel.text = h.totalMoney;
        hcell.numLabel.text = @(h.businesses.count).stringValue;
        hcell.floatBenLabel.text = h.floatBenifit;
        if(h.floatBenifit.floatValue >0){
            hcell.floatBenLabel.textColor = [UIColor greenColor];
        }else{
            hcell.floatBenLabel.textColor = [UIColor redColor];
        }
        hcell.floatBenLabel.backgroundColor = [UIColor lightGrayColor];
        [UIView animateWithDuration:0.25 animations:^{
            hcell.floatBenLabel.backgroundColor = [UIColor clearColor];
        }];
        hcell.beatLabel.text = @(jl.heartBeat).stringValue;
        cell = hcell;
        
    }else{
         NoticesTableViewCell * hcell = [tableView dequeueReusableCellWithIdentifier:@"noti-cell"];
        JSBusiness * jb = _businesses[indexPath.row];
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
        cell = hcell;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //跳转到持仓列表
        StoreTableViewController  *vc = [[StoreTableViewController alloc] initWithStyle:UITableViewStylePlain];
        vc.hereo = [_hereoes[indexPath.row] hereo];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"英雄榜";
    }
    return @"消息列表";
    
}
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
-(void)listhener:(JSHereoListhener *)ls didAddBusiness:(JSBusiness *)b
{
     b.isClose = NO;
     [_businesses insertObject:b atIndex:0];
    if(_businesses.count>100){
        [_businesses removeLastObject];
    }
    [self sendNotiFor:b];
    [self.tableView reloadData];
}
-(void)listhener:(JSHereoListhener *)ls didcCloseBusiness:(JSBusiness *)b
{
    b.isClose = YES;
    [_businesses insertObject:b atIndex:0];
    if(_businesses.count>100){
        [_businesses removeLastObject];
    }
    [self sendNotiFor:b];
    [self.tableView reloadData];
    
}
-(void)listhernerDidUpdate:(JSHereoListhener *)ls
{
    //前提是工作日且持仓大于0
    if(ls.hereo.businesses.count >0 && [self isWorkDay]){
     if (ls.heartBeat==2) {//连续40秒无数据刷新发通知
        [self sendLocalNoti:@"心跳太低，是否网络故障？"];
     }else if (ls.heartBeat == 0){//强制reload网页
        [ls startListhenHereo:ls.hereo];
     }
    }
    
    if (ls==_mySelf) {
        [self myselfInfoUpdate];
    }
    [self.tableView reloadData];
}
-(void)myselfInfoUpdate
{
    if (_lastBs) {
        //
        JShereo * h = _mySelf.hereo;
        for(JSBusiness * bu in h.businesses){
            //超过+-50提示
            NSString * ids = [bu identifier];
            if([_lastBs containsObject:bu]){
                NSUInteger index = [_lastBs indexOfObject:bu];
                JSBusiness *lb = _lastBs[index];
                //判断盈亏金额
                int lastF = ABS(lb.floatBenifit.floatValue)/TIPLEVEL;
                int nowF = ABS(bu.floatBenifit.floatValue)/TIPLEVEL;
                if(lastF != nowF && nowF > 0){
                    
                    if (bu.floatBenifit.floatValue>0) {
                        NSString * name = [NSString stringWithFormat:@"%@ %@ 盈利超过  %d",bu.productName,bu.isBuy?@"买单":@"卖单",TIPLEVEL];
                        [self sendLocalNoti:name];
                    }else{
                      
                        NSString * name = [NSString stringWithFormat:@"%@ %@ 亏损超过  %d",bu.productName,bu.isBuy?@"买单":@"卖单",TIPLEVEL];
                        [self sendLocalNoti:name];
                    }
                    
                    
                }
                
                //判断是否转亏专盈
                int value = [_lastInfo[ids] intValue];
                int now =  bu.floatBenifit.floatValue;
                
                if( value * now < 0){//一正一负
                    if (ABS(value) > TIPCOUNT) {//满足提示点
                        NSString * name = [NSString stringWithFormat:@"%@ %@ %@",bu.productName,bu.isBuy?@"买单":@"卖单",now>0?@"转盈":@"转亏"];
                        [self sendLocalNoti:name];
                         value = 0;
                    }else{//不满足，
                        if (now >0) {
                            value=1;
                        }else{
                            value = -1;
                        }
                        
                    }
                    
                    
                }else{//前后一致
                    if(value>=0){
                        value++;
                    }else{
                        value--;
                    }
                    
                }
                
                _lastInfo[ids] = @(value);
                
                
            }
            
        }
        
    }
    _lastBs = _mySelf.hereo.businesses;
    
}
-(BOOL)isWorkDay
{
    return YES;
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:-6*60*60];
    
    NSInteger week = [[_myCalendar components:NSCalendarUnitWeekday fromDate:date] weekday];
    return week!=1 && week!=7;;
}
-(void)writeBusinessToLocal
{
    NSArray * temp = [_businesses copy];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];

    docDir = [docDir stringByAppendingString:@"/bs.txt"];
    
    [temp writeToFile:docDir atomically:YES];
}
-(NSArray * )readLocalBusiness
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    docDir = [docDir stringByAppendingString:@"/bs.txt"];
    
    
    return [NSArray arrayWithContentsOfFile:docDir];
}
-(void)sendNotiFor:(JSBusiness*)jb
{

    NSString * state = @"关闭";
   
    if(jb.isClose == NO){
        state = jb.isBuy?@"买入":@"卖出";
    }
    NSString * body = [NSString stringWithFormat:@"%@  %@ %@",jb.userName,state,jb.productName];
    

    [self sendLocalNoti:body];
}
-(void)sendLocalNoti:(NSString*)body
{
    [NWFToastView showToast:body];
    UILocalNotification *localNotifi = [UILocalNotification new];
    localNotifi.alertBody = body;
    localNotifi.soundName = UILocalNotificationDefaultSoundName;
    localNotifi.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotifi];
}
@end
