//
//  WQloseAbidCollectionViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/12.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQloseAbidCollectionViewCell.h"
#import "WQWaitOrderoncModel.h"
#import "WQWaitOrderModel.h"
#import "WQloseAbidTableViewCell.h"
#import "WQevaluateViewController.h"
#import "WQorderViewController.h"
#import "WQMyReceivinganOrderVisitorsLoginView.h"
#import "WQConversationListViewController.h"
#import <objc/runtime.h>

static NSString *cellid = @"cellid";

@interface WQloseAbidCollectionViewCell()  <UITableViewDataSource,UITableViewDelegate,WQevaluateViewControllerDelegate>
@property (nonatomic, strong) WQWaitOrderoncModel *waitOrderoncModel;
@property (nonatomic, strong) WQMyReceivinganOrderVisitorsLoginView *myReceivinganOrderVisitorsLoginView;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableDictionary *haunxinparams;
@property (nonatomic, copy) NSString *huanxinId;   //环信id
@property (nonatomic, copy) NSString *needsid;     //用户id
@end

@implementation WQloseAbidCollectionViewCell
-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];

    //UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
    //topView.backgroundColor = [UIColor colorWithHex:0xededed];
    
    UITableView *contentTableView = [[UITableView alloc] init];
    contentTableView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    //[contentTableView registerNib:[UINib nibWithNibName:@"WQloseAbidTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
    [contentTableView registerClass:[WQloseAbidTableViewCell class] forCellReuseIdentifier:cellid];
    self.tableview = contentTableView;
    //取消分割线
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    //contentTableView.tableHeaderView = topView;
    [self.contentView addSubview:contentTableView];
    [contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [contentTableView layoutIfNeeded];
    
    WQMyReceivinganOrderVisitorsLoginView *myReceivinganOrderVisitorsLoginView = [[WQMyReceivinganOrderVisitorsLoginView alloc] init];
    self.myReceivinganOrderVisitorsLoginView = myReceivinganOrderVisitorsLoginView;
    myReceivinganOrderVisitorsLoginView.hidden = YES;
    myReceivinganOrderVisitorsLoginView.isSendOrder = NO;
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
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        NSArray *array = response[@"bids"];
        for (NSDictionary *dict in array) {
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
    self.params[@"type"] = @"BIDDED_FNISHED";
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        _waitOrderoncModel = [WQWaitOrderoncModel yy_modelWithJSON:response];
        
        if (_waitOrderoncModel.needs.count < 1) {
            self.myReceivinganOrderVisitorsLoginView.hidden = NO;
        }else {
            NSLog(@"%@",self.waitOrderoncModel.needs);
            [self.tableview reloadData];
            for (WQWaitOrderModel * model in _waitOrderoncModel.needs) {
                
                [WQUnreadMessageCenter removeMessagesAboutBid:model.id];
            }
        }
        
    }];
}

#pragma mark - WQevaluateViewControllerDelegate
- (void)wqEvaluateViewControllerRefresh:(WQevaluateViewController *)wqEvaluateViewController {
    [self.tableview reloadData];
}

#pragma mark - tableView数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.waitOrderoncModel.needs.count;;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WQloseAbidTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    WQorderViewController *orderVc = [[WQorderViewController alloc] initWithNeedsId:cell.model.id];
    orderVc.isHome = NO;
    orderVc.isIPickUpTheOrder = NO;
    [self.viewController.navigationController pushViewController:orderVc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    WQloseAbidTableViewCell *cellA = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    WQWaitOrderModel *model = self.waitOrderoncModel.needs[indexPath.row];
    cellA.model = model;
    cellA.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cellA.chatHistoryOnCkick = ^{
        
        EaseMessageViewController * vc = [[EaseMessageViewController alloc] initWithConversationChatter:model.user_id conversationType:EMConversationTypeChat needId:model.id needOwnerId:model.user_id fromName:model.bid_user_name fromPic:model.bid_user_pic toName:model.user_name toPic:model.user_pic isFromTemp:NO isTrueName:model.truename isBidTureName:model.bid_truename];
        vc.bidFinished = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
        
    };
    
    
    [cellA setEvaluateBtnClikeBlock:^{
        WQloseAbidTableViewCell *cellA = [tableView cellForRowAtIndexPath:indexPath];
        NSString *needId = cellA.model.nbid;
        if (weakSelf.evaluateBtnBlock) {
            weakSelf.evaluateBtnBlock(needId);
        }
    }];
    if (!cellA.model.can_feedback) {
        [cellA.evaluationBtn setTitle:@" 已评价" forState:UIControlStateNormal];
        [cellA.evaluationBtn setImage:[UIImage imageNamed:@"pingjia"] forState:UIControlStateNormal];
        cellA.evaluationBtn.enabled = NO;
        [cellA.evaluationBtn setTitleColor:[UIColor colorWithHex:0xa3a3a3] forState:UIControlStateNormal];
    }
    return cellA;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return 0;
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
    }
    return _params;
}
- (NSMutableDictionary *)haunxinparams {
    if (!_haunxinparams) {
        _haunxinparams = [[NSMutableDictionary alloc] init];
    }
    return _haunxinparams;
}

@end
