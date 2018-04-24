//
//  WQReceivinganOrdercollectionCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/7.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQReceivinganOrdercollectionCell.h"
#import "WQReceivinganOrderTableViewCell.h"
#import "WQWaitOrderoncModel.h"
#import "WQWaitOrderModel.h"
#import "WQorderViewController.h"
#import "WQMyReceivinganOrderViewController.h"
#import "UIView+WZLBadge.h"
#import "WQMyReceivinganOrderVisitorsLoginView.h"

static NSString *cellid = @"cellid";

@interface WQReceivinganOrdercollectionCell ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableDictionary *params;
@property(nonatomic,strong)WQWaitOrderoncModel *waitOrderoncModel;
@property(nonatomic,strong)UITableView *tableview;
//用户id
@property(nonatomic,copy)NSString *needsid;
//环信id
@property(nonatomic,copy)NSString *huanxinId;
@property(nonatomic,strong)NSMutableDictionary *haunxinparams;
@property (nonatomic, weak) WQMyReceivinganOrderViewController * vc;
@property (nonatomic, strong) WQMyReceivinganOrderVisitorsLoginView *myReceivinganOrderVisitorsLoginView;
@end

@implementation WQReceivinganOrdercollectionCell
-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self.needsid = [[NSString alloc]init];
    //UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
    //topView.backgroundColor = [UIColor colorWithHex:0xededed];
    UITableView *contentTableView = [[UITableView alloc] init];
    //[contentTableView registerNib:[UINib nibWithNibName:@"WQReceivinganOrderTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
    [contentTableView registerClass:[WQReceivinganOrderTableViewCell class] forCellReuseIdentifier:cellid];
    self.tableview = contentTableView;
    contentTableView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    //contentTableView.tableHeaderView = topView;
    //取消分割线
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    
    [self.contentView addSubview:contentTableView];
    [contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [contentTableView layoutIfNeeded];
    
    WQMyReceivinganOrderVisitorsLoginView *myReceivinganOrderVisitorsLoginView = [[WQMyReceivinganOrderVisitorsLoginView alloc] init];
    myReceivinganOrderVisitorsLoginView.isSendOrder = NO;
    self.myReceivinganOrderVisitorsLoginView = myReceivinganOrderVisitorsLoginView;
    myReceivinganOrderVisitorsLoginView.hidden = YES;
    [self.contentView addSubview:myReceivinganOrderVisitorsLoginView];
    [myReceivinganOrderVisitorsLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self loadData];
    

    
    return self;
}
#pragma mark - 获取环信id
- (void)loadHuanxinid {
    NSString *urlString = @"api/need/getneedbidder";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.haunxinparams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    _haunxinparams[@"nid"] = self.huanxinId;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_haunxinparams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        NSLog(@"%@",response);
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSArray *array = response[@"bids"];
        
        for (NSDictionary *dict in array) {
            NSLog(@"%@",dict);
            self.needsid = dict[@"user_id"];
            NSLog(@"%@",_needsid);
        }

    }];
}
#pragma mark - 加载数据
- (void)loadData {
    NSString *urlString = @"api/need/mybidneed";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    self.params[@"type"] = @"BIDDING";
    
    __weak typeof(self) weakself = self;
    
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        weakself.vc = (WQMyReceivinganOrderViewController *)weakself.viewController;
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        NSLog(@"%@",response);
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        _waitOrderoncModel = [WQWaitOrderoncModel yy_modelWithJSON:response];
        
        if (_waitOrderoncModel.needs.count < 1) {
            self.myReceivinganOrderVisitorsLoginView.hidden = NO;
        }else {
            NSLog(@"%@",self.waitOrderoncModel.needs);
            [self.tableview reloadData];
            
            NSMutableArray * needIds = @[].mutableCopy;
            
            for (WQWaitOrderModel * model in _waitOrderoncModel.needs) {
                [needIds addObject:model.id];
            }
            
            [_vc hideOrShowDotForBills:needIds ofBidType:BidTypeToSelect];
            _vc.toSelectBidIds = needIds;
        }
    }];
}

#pragma mark - tableView数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.waitOrderoncModel.needs.count;;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WQReceivinganOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    WQorderViewController *orderVc = [[WQorderViewController alloc] initWithNeedsId:cell.model.id];
    orderVc.isHome = NO;
    orderVc.isIPickUpTheOrder = NO;
    [self.viewController.navigationController pushViewController:orderVc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQReceivinganOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WQWaitOrderModel *model = self.waitOrderoncModel.needs[indexPath.row];
    cell.model = model;
    __weak typeof(self) weakSelf = self;
    [cell setBillingPresonClikeBlock:^{
        WQReceivinganOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        //这是需求id啊看文档。。
        NSString *nid = cell.model.id;
        NSString *userId = cell.model.user_id;//发单者ID
        NSString *toName = cell.model.user_name;//发单者显示名称
        NSString *toPic = cell.model.user_pic;//发单者显示头像
        NSString *userName = cell.model.bid_user_name;//接单者显示名称
        NSString *userPic = cell.model.bid_user_pic; //接单者显示头像
        BOOL isTrueName = cell.model.truename;
        BOOL isBidTureName = cell.model.bid_truename;
        if (weakSelf.pushxiangqingClikeBlock) {
            weakSelf.pushxiangqingClikeBlock(userId, nid, userId, userName, userPic, toName, toPic , YES, isTrueName, isBidTureName);
        }
    }];
    
    //BOOL redDotbool = [EaseConversationListViewController shouldShowRedDot:cell.model.id withBidUser:cell.model.user_id];
    //BOOL redDotbool = [EaseConversationListViewController shouldShowRedDotForNid:cell.model.id];
    //聊天的红点
    BOOL redDotbool = [WQUnreadMessageCenter haveUnreadMessageForBid:cell.model.id];
    if (redDotbool) {
        cell.redDotView.hidden = NO;
    }else {
        cell.redDotView.hidden = YES;
    }
    
    BOOL bidDot =  cell.model.reddot;
    
    //订单的红点

    
    
    if (bidDot) {
        [cell showDotBadge];
        cell.badge.frame = CGRectMake(cell.badge.x - 15, cell.badge.y + 10, cell.badge.width, cell.badge.height);
        
    } else {
        [cell hideDotBadge];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0;
    }
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86;
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
- (NSMutableDictionary *)haunxinparams {
    if (!_haunxinparams) {
        _haunxinparams = [[NSMutableDictionary alloc]init];
    }
    return _haunxinparams;
    
}

@end
