//
//  WQTemporaryInquiryController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTemporaryInquiryController.h"
#import "WQTemporaryInquiryCell.h"
#import "WQWaitOrderModel.h"
#import "WQChaViewController.h"
#import "WQorderViewController.h"
#import "WQPeopleListModel.h"
#import "WQTemporaryInquiryEmptyView.h"

#define TAG_BTN 1000
@interface WQTemporaryInquiryController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, retain) UITableView * mainTable;

@property (nonatomic, retain) NSMutableArray * tempChatNids;
@property (nonatomic, retain) NSMutableArray<WQWaitOrderModel *> * dataSource;
@property (nonatomic, strong) WQTemporaryInquiryEmptyView *temporaryInquiryEmptyView;
@end
static NSString *cellid = @"cellid";
@implementation WQTemporaryInquiryController
#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = @[].mutableCopy;
    [self setUpUI];
    [self fetchBidData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    self.navigationItem.title = @"我询问的需求";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;

}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 代理置空，否则会崩
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        // 只有在二级页面生效
        if ([self.navigationController.viewControllers count] == 2) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (void)dealloc {
    
}



//- (void)getAllBider {
//    
//    
//    [SVProgressHUD showWithStatus:@"正在加载中......"];
//    dispatch_group_t group = dispatch_group_create();
//    
//    
//    
//    NSString *urlString = @"api/need/getneedbidder";
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary * params = @{}.mutableCopy;
//    
//    for (<#type *object#> in <#collection#>) {
//        <#statements#>
//    }
//    
//    params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
//    params[@"nid"] = self.nid;
//    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
//        if (error) {
//            NSLog(@"%@",error);
//            [SVProgressHUD dismiss];
//            //dispatch_group_enter(group);
//            return ;
//        }
//        if ([response isKindOfClass:[NSData class]]) {
//            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
//        }
//        [SVProgressHUD dismiss];
//        NSLog(@"%@",response);
//        NSArray * modelArray = [NSArray yy_modelArrayWithClass: NSClassFromString(@"WQPeopleListModel") json:response[@"bids"]].mutableCopy;
//        for(WQPeopleListModel *people in modelArray){
//            [self.bidUserList addObject:people.user_id];
//        }
//    }];
//}



#pragma mark - netWork


//- (void)getBidderWithNeedId:(NSString *)needsId {
//    __weak typeof(self) weakSelf = self;
//    NSMutableDictionary * param = @{}.mutableCopy;
//    NSString * strUrl = @"api/need/getneedbidder";
//    param[@"secretkey"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
//    param[@"nid"] = needsId;
//    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:strUrl parameters:param completion:^(id response, NSError *error) {
//
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//
//
//        /*
//         success true boolean 是否成功
//         bids true array[object] 已投标需求信息[
//         {
//         posttime true string 发布时间
//         user_pic false string 用户头像，如果既不是接单者也不是发单者则不返回
//         user_id true string 用户 id
//         user_name false string 用户名称，如果既不是接单者也不是发单者则不返回
//         user_phone true string 用户手机
//         id true string 需求投标 id，即各个投标接口中的 nbid
//         text true string 投标文字
//         status true string 状态：STATUS_BIDDING(待接单);STATUS_BIDDED（进行中）;STATUS_FNISHED（已完成）
//         work_status true string 接单者工作状态（见文档说明）
//         work_status_time true string 已接单时间
//         truename true string 是否匿名
//         mybidded true string 是否是我的投标
//         can_feedback true boolean 发单者是否可以评价
//         isfeedbacked true boolean 接单者是否已评价
//         },....
//         ]
//         */
//
//        if ([response isKindOfClass:[NSData class]]) {
//            response = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
//        }
//
//        NSArray * allBiders = response[@"bids"];
////        for (NSDictionary * onebider in allBiders) {
////            NSString * myid = [[NSUserDefaults standardUserDefaults] objectForKey:@"im_namelogin"];
////            if ([onebider[@"user_id"] isEqualToString:myid]) {
////
////                strongSelf.iBid = YES;
////                [strongSelf.orderBottomView.helpBtn setTitle:@"已接单" forState:UIControlStateDisabled];
////
////                strongSelf.orderBottomView.helpBtn.enabled = NO;
////                [strongSelf.orderBottomView.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
////                    make.left.equalTo(strongSelf.orderBottomView.askBtn.mas_left);
////                }];
////                return;
////            }
////        }
//    }];
//}





- (void)fetchBidData {
    NSArray * allData = [WQUnreadMessageCenter allTempChatBidIds];
    NSString * url =  @"api/need/getneedinfo";
    NSMutableDictionary * params = @{}.mutableCopy;
    params[@"secretkey"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    
    __block BOOL haveError = NO;
    
    [SVProgressHUD showWithStatus:@"加载中…"];
    
    dispatch_group_t group = dispatch_group_create();
    
    for (NSString * bid in allData) {
        dispatch_group_enter(group);
        params[@"nid"] = bid;
        [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:url parameters:params completion:^(id response, NSError *error) {
            
            if (error) {
                haveError = YES;
            }
            if ([response isKindOfClass:[NSData class]]) {
                response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            }
            NSLog(@"%@",response);
            WQWaitOrderModel * model = [WQWaitOrderModel yy_modelWithJSON:response];
            
            
            
            if ([response[@"success"] boolValue]) {
                if (model) {
                    [_dataSource addObject:model];
                }
            } else {
                
            }
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (haveError) {
            
            [SVProgressHUD showWithStatus:@"订单信息获取,请重试"];
            [SVProgressHUD dismissWithDelay:1];
            
        } else {
            
            //            [self getBidderWithNeedId:[_dataSource[1] id]];
            
            NSMutableArray * all = allData.mutableCopy;
            
            
            for (WQWaitOrderModel * model in _dataSource) {
                for (NSString * id in  allData) {
                    if ([model.id isEqualToString:id]) {
                        [all removeObject:id];
                    }
                }
            }
            
            if (all.count) {
                for (NSString * id in all) {
                    [WQUnreadMessageCenter removeTempChatAboutBid:id];

                }
            }
            
            if (_dataSource.count < 1) {
                self.temporaryInquiryEmptyView.hidden = NO;
            }else {
                [_mainTable reloadData];
            }
            
            [SVProgressHUD dismiss];
        }
    });
}

#pragma mark - UI
- (void)setUpUI {
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.tableHeaderView = [UIView new];
    [tableView registerClass:[WQTemporaryInquiryCell class] forCellReuseIdentifier:cellid];
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    tableView.alpha = 1;
    self.mainTable = tableView;
    
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
    
    WQTemporaryInquiryEmptyView *temporaryInquiryEmptyView = [[WQTemporaryInquiryEmptyView alloc] init];
    self.temporaryInquiryEmptyView = temporaryInquiryEmptyView;
    temporaryInquiryEmptyView.hidden = YES;
    [self.view addSubview:temporaryInquiryEmptyView];
    [temporaryInquiryEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
}

#pragma mark - tableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WQTemporaryInquiryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *id = cell.waitorderModel.id;
    
    NSDictionary * allTempInfo = [WQUnreadMessageCenter allTempChatInfo];
    
    NSArray * allChatterWithBid = allTempInfo[id];
    NSSet * set = [NSSet setWithArray:allChatterWithBid];
    
    WQorderViewController *orderVc = [[WQorderViewController alloc]initWithNeedsId:id];
    //    WQorderViewController *orderVc = [[WQorderViewController alloc] initWithNeedsId:cell.homeNearbyTagModel.id];
    //    orderVc.user_degree = cell.homeNearbyTagModel.user_degree;
    //    orderVc.distance = distance;
    //    orderVc.creditPoints = cell.homeNearbyTagModel.user_creditscore;
    orderVc.fromTemp = YES;
    [self.navigationController pushViewController:orderVc animated:YES];
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WQTemporaryInquiryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    cell.waitorderModel = _dataSource[indexPath.row];
    __weak typeof(self) weakSelf = self;
    [cell setPersonnelClikeBlock:^{
        WQTemporaryInquiryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *id = cell.waitorderModel.id;
        
    }];
    
    [cell.contactBiderButton addTarget:self action:@selector(contractBidder:) forControlEvents:UIControlEventTouchUpInside];
    
    //    使用 tag 标记是哪一个模型
    cell.contactBiderButton.tag = TAG_BTN + indexPath.row;
    BOOL redDotbool =  [WQUnreadMessageCenter haveUnreadTmpChatForBid:cell.waitorderModel.id];
    
    
    
    
    if (redDotbool) {
        cell.redDotView.hidden = NO;
    } else {
        cell.redDotView.hidden = YES;
    }
    
    return cell;
}

- (void)contractBidder:(UIButton *)sender {
    WQWaitOrderModel * model = _dataSource[sender.tag - TAG_BTN];
    
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:model.user_id type:EMConversationTypeChat createIfNotExist:NO];
    
    __block EMMessage * currentMessage;
    
    [conversation loadMessagesStartFromId:nil count:100 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        for (EMMessage * message in aMessages) {
            if ([message.ext[@"nid"] isEqualToString:model.id] && (![message.ext[@"is_bidding"] boolValue])) {
                currentMessage = message;
                break;
            }
        }
        
        NSDictionary * ext = @{};
        
        if (currentMessage) {
            ext = currentMessage.ext;
        }
        
        WQChaViewController *chatController = [[WQChaViewController alloc] initWithConversationChatter:model.user_id conversationType:EMConversationTypeChat needId:model.id needOwnerId:model.user_id  fromName:ext[@"from_name"] fromPic:ext[@"from_pic"] toName:ext[@"to_name"] toPic:ext[@"to_name"] isFromTemp:ext[@"is_bidding"] isTrueName:ext[@"istruename"]isBidTureName:ext[@"isBidTureName"]];
        
        if (![model.can_bid boolValue]) {
            chatController.tempChatBiding = YES;
        }
        
        [self.navigationController pushViewController:chatController animated:YES];
        
    }];
    
    
    //    ext = [[NSMutableDictionary alloc] init];
    //}
    //if(self.nid != nil && self.nid.length > 0){
    //    [ext setObject:self.nid forKey:@"nid"];
    //}
    //if(self.needOwnerId != nil){
    //    [ext setObject:self.needOwnerId forKey:@"need_owner_id"];
    //}
    //if(self.fromName != nil){
    //    [ext setObject:self.fromName forKey:@"from_name"];
    //}
    //if(self.fromPic){
    //    [ext setObject:self.fromPic forKey:@"from_pic"];
    //}
    //if(self.toName){
    //    [ext setObject:self.toName forKey:@"to_name"];
    //}
    //if(self.toPic){
    //    [ext setObject:self.toPic forKey:@"to_pic"];
    //}
    //[ext setObject:[NSNumber numberWithBool:!self.isFromTemp] forKey:@"is_bidding"];
    //[ext setObject:[NSNumber numberWithBool:self.isBidTureName] forKey:@"isBidTureName"];
    //[ext setObject:[NSNumber numberWithBool:self.isTrueName] forKey:@"istruename"];
    ////发送消息者为当前用户
    
    
    
    
}
@end
