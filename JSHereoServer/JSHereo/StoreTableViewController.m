//
//  StoreTableViewController.m
//  JSHereo
//
//  Created by jp007 on 2017/11/16.
//  Copyright © 2017年 crv.jp007. All rights reserved.
//

#import "StoreTableViewController.h"
#import "MsgTableViewCell.h"
#import "MJRefresh.h"
#import "ConversationManager.h"
#import "NWFToastView.h"
#import "MessegeTool.h"
#import "EMMessage+OutTime.h"
#import "AppDelegate.h"
@interface StoreTableViewController ()<EMChatManagerDelegate>
{
    NSMutableDictionary * _heroNames;
    NSMutableArray * _msgs ;
    
    NSUInteger _heartRate;
   
    
}
@end

@implementation StoreTableViewController

-(void)dealloc
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    
}
-(void)sendHeatBeat
{
    //10086是服务器，跟他建立连接
    _heartRate = 0;//设置为0
    //5秒钟后，测试心率是否为10
    [NWFToastView showProgress:@"服务器连线测试.."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //没收到心率回复
        [NWFToastView dismissProgress];
        if(_heartRate == 0){
            self.navigationItem.title = @"服务器掉线";
            [MessegeTool sendLocalNoti:@"服务器断线了呀？"];
        }else{
            self.navigationItem.title = @"数据列表";
        }
    });
    [[EMClient sharedClient].chatManager getConversation:@"10086" type:EMConversationTypeChat createIfNotExist:YES];
    
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:@"心跳测试包"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:@"10086" from:from to:@"10086" body:body ext:@{@"type":@"heart"}];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    
    [[EMClient sharedClient].chatManager  sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        NSLog(@"发送了消息");
        if(message.status == EMMessageStatusSucceed){
            NSLog(@"成功给服务器发送了消息");
        }else{
            NSLog(@"失败发送了消息");
        }
    }];
    
}

-(void)sendOperator:(NSInteger)index
{
    
    NSString * type = @"";
    switch (index) {
        case 0:
            type  = @"refresh";
            break;
        case 1:
            type  = @"heart";
            break;
        case 2:
            type  = @"pause";
            break;
            
        default:
            break;
    }
    [[EMClient sharedClient].chatManager getConversation:@"10086" type:EMConversationTypeChat createIfNotExist:YES];
    
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:@"操作指令"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:@"10086" from:from to:@"10086" body:body ext:@{@"type":type}];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    
    [[EMClient sharedClient].chatManager  sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        NSLog(@"发送了消息");
        if(message.status == EMMessageStatusSucceed){
            NSLog(@"成功给服务器发送了消息");
        }else{
            NSLog(@"失败发送了消息");
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"数据列表";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"msg-cell"];
    
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
    
    
    [ConversationManager login:@"007" pwd:@"qwe123" completion:^(BOOL isSuc) {
        if (isSuc==NO) {
            [NWFToastView showToast:@"登录失败，请检查"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
            self.navigationItem.rightBarButtonItem = [self rightItem];
            self.navigationItem.leftBarButtonItem = [self leftItem];
            AppDelegate * app =  (AppDelegate*)[UIApplication sharedApplication].delegate ;
            [app bindToken];
        }
    }];
    _heroNames = [NSMutableDictionary dictionaryWithCapacity:0];
    [_heroNames setObject:@"李先生" forKey:@"744891_15246"];
    //744891_15065
    [_heroNames setObject:@"先生666" forKey:@"744891_15065"];
    [_heroNames setObject:@"高频" forKey:@"688479_17273"];
   // [_heroNames setObject:@"盈利为先" forKey:@"752318_14154"];
    [_heroNames setObject:@"顶域投资" forKey:@"752318_16822"];
    [_heroNames setObject:@"AMP资管一号" forKey:@"330344_7743"];
    //758539_14872

    [_heroNames setObject:@"vikingpower" forKey:@"758539_14872"];
    _msgs = [NSMutableArray arrayWithCapacity:0];
}

-(void)showLeftMenu
{
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"菜单" message:@"" preferredStyle:0];
 
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"刷新服务器" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self sendOperator:0];
    }];
    [ac addAction:action];
    action = [UIAlertAction actionWithTitle:@"测服务心跳" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //[self sendOperator:1];
        [self sendHeatBeat];
        
    }];
    [ac addAction:action];

    
    action = [UIAlertAction actionWithTitle:@"停止/继续读取" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self sendOperator:2];
        
    }];
    [ac addAction:action];
    
    
    action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:action];
    
    [self presentViewController:ac animated:YES completion:nil];
    
}
-(void)addHero
{
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"选择" message:@"" preferredStyle:0];
    for (NSString * key in _heroNames.allKeys) {
        NSString * name = _heroNames[key];
        UIAlertAction *action = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requirePushFor:key];
            
        }];
        [ac addAction:action];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"其他" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self addOther];
    }];
    [ac addAction:action];
    
    action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:action];
    
    [self presentViewController:ac animated:YES completion:nil];
    
}
-(void)addOther
{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加英雄" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"输入英雄的id";
            
        }];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *login = alertController.textFields.firstObject;
            
            [self requirePushFor:login.text];
            
        }];
        [alertController addAction:action];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        

}
-(UIBarButtonItem *)leftItem
{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 70, 30);
    [backBtn setTitle:@"菜单" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
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
-(void)cancelRequirePushFor:(NSString*)heroId
{
    [[EMClient sharedClient].chatManager getConversation:@"10086" type:EMConversationTypeChat createIfNotExist:YES];
    
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:@"要发送的消息,来自007哦"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:@"10086" from:from to:@"10086" body:body ext:[MessegeTool extForHeroLishenerMsg:heroId isAdd:NO]];
    
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    
    [[EMClient sharedClient].chatManager  sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        NSLog(@"发送了消息");
        if(message.status == EMMessageStatusSucceed){
            NSLog(@"成功给服务器发送了消息");
        }else{
            NSLog(@"失败发送了消息");
        }
    }];
    
}
-(void)requirePushFor:(NSString*)heroId
{
    //10086是服务器，跟他建立连接
      [[EMClient sharedClient].chatManager getConversation:@"10086" type:EMConversationTypeChat createIfNotExist:YES];
    
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:@"要发送的消息,来自007哦"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:@"10086" from:from to:@"10086" body:body ext:[MessegeTool extForHeroLishenerMsg:heroId isAdd:YES]];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    
    [[EMClient sharedClient].chatManager  sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        NSLog(@"发送了消息");
        if(message.status == EMMessageStatusSucceed){
            NSLog(@"成功给服务器发送了消息");
        }else{
            NSLog(@"失败发送了消息");
        }
    }];
    
    
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

    MsgTableViewCell * hcell = [tableView dequeueReusableCellWithIdentifier:@"msg-cell"];
    
    hcell.msgLabel.text = _msgs[indexPath.row];

   

    return hcell;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _msgs.count;
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


- (void)messagesDidReceive:(NSArray *)aMessages
{
    
    for(EMMessage * message in aMessages){
        
        if ([message.from isEqual:@"10086"] !=YES) {
            
            continue;
        }
        if ([message isOuttime]) {
            continue;//超时消息不显示了
        }
        _heartRate = 10;//收到消息就让心率为10
        EMMessageBody *msgBody = message.body;
        switch (msgBody.type) {
            case EMMessageBodyTypeText:
            {
                // 收到的文字消息
                EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                NSString *txt = textBody.text;
                NSLog(@"收到的文字是 txt -- %@",txt);
                NSDictionary * d = message.ext;
                
                
                //message.timestamp
                [_msgs insertObject:txt atIndex:0];
                
                if (_msgs.count>100) {
                    [_msgs removeLastObject];
                }
                [MessegeTool sendLocalNoti:txt];
                [self.tableView reloadData];
            }
                break;
            default:
                break;
        }
    }
    NSLog(@"get normal mess:%@",aMessages);
}
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages
{
    NSLog(@"get cmd:%@",aCmdMessages);
    
}

@end
