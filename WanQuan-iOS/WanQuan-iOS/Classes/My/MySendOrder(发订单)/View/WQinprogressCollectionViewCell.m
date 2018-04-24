//
//  WQinprogressCollectionViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/12.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQinprogressCollectionViewCell.h"
#import "WQWaitOrderoncModel.h"
#import "WQWaitOrderModel.h"
#import "WQMyOrderViewController.h"
#import "WQMyReceivinganOrderVisitorsLoginView.h"
#import "WQOrderTableViewCell.h"

static NSString *cellid = @"cellid";

@interface WQinprogressCollectionViewCell() <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableDictionary *params;            //获取UI数据
@property (nonatomic, strong) NSMutableDictionary *haunxinparams;     //获取需求信息的参数
@property (nonatomic, strong) NSMutableArray *detailOrderData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WQWaitOrderoncModel *waitOrderoncModel;
@property (nonatomic, copy) NSString *needsid;                        //发送到的环信ID
@property (nonatomic, copy) NSString *huanxinId;

@property (nonatomic, weak) WQMyOrderViewController * vc;
@property (nonatomic, strong) WQMyReceivinganOrderVisitorsLoginView *myReceivinganOrderVisitorsLoginView;

//接收对应的环信ID
@end

@implementation WQinprogressCollectionViewCell
-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    [self loadData];
    //UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
    //topView.backgroundColor = [UIColor colorWithHex:0xededed];
    
    UITableView *tableView = [[UITableView alloc]init];
    //tableView.tableHeaderView = topView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[tableView registerNib:[UINib nibWithNibName:@"WQinprogressTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
    [tableView registerClass:[WQOrderTableViewCell class] forCellReuseIdentifier:cellid];
    tableView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.tableView = tableView;
    [self.contentView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [tableView layoutIfNeeded];
    
    WQMyReceivinganOrderVisitorsLoginView *myReceivinganOrderVisitorsLoginView = [[WQMyReceivinganOrderVisitorsLoginView alloc] init];
    self.myReceivinganOrderVisitorsLoginView = myReceivinganOrderVisitorsLoginView;
    myReceivinganOrderVisitorsLoginView.isSendOrder = YES;
    self.myReceivinganOrderVisitorsLoginView = myReceivinganOrderVisitorsLoginView;
    myReceivinganOrderVisitorsLoginView.hidden = YES;
    [self.contentView addSubview:myReceivinganOrderVisitorsLoginView];
    [myReceivinganOrderVisitorsLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    return self;
    
}

#pragma mark - 获取环信id
- (void)loadHuanxinid
{
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
        self.needsid = response[@"user_id"];
    }];
}
#pragma mark - UI数据
- (void)loadData
{
    NSString *urlString = @"api/need/mycreatedneed";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    self.params[@"type"] = @"STATUS_BIDDED";
    
    __weak typeof(self) weakself = self;
    
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        weakself.vc = (WQMyOrderViewController *)weakself.viewController;
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
            NSMutableArray * bidIds = @[].mutableCopy;
            
            for (WQWaitOrderModel * model in _waitOrderoncModel.needs) {
                [bidIds addObject:model.id];
            }
            
            self.vc.selectedBidIds = bidIds;
            [self.vc hideOrShowDotForBills:bidIds ofBidType:BidTypeSelected];
            [self.tableView reloadData];
        }
    }];
}


#pragma mark -tableView数据源方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.waitOrderoncModel.needs.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //WQinprogressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    WQOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *id = cell.waitorderModel.id;
    __weak typeof(self) weakSelf = self;
    if (weakSelf.inprogressPushxiangqingClikeBlock) {
        weakSelf.inprogressPushxiangqingClikeBlock(id);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.waitorderModel = self.waitOrderoncModel.needs[indexPath.row];
    
    BOOL redDotbool = [WQUnreadMessageCenter haveUnreadBidChatForBid:cell.waitorderModel.id] || cell.waitorderModel.reddot;
    if (redDotbool) {
        cell.redDotView.hidden = NO;
    }else {
        cell.redDotView.hidden = YES;
    }
    
    return cell;
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}

- (NSMutableDictionary *)haunxinparams
{
    if (!_haunxinparams) {
        _haunxinparams = [[NSMutableDictionary alloc]init];
    }
    return _haunxinparams;
    
}

- (NSMutableArray *)detailOrderData
{
    if (!_detailOrderData) {
        _detailOrderData = [[NSMutableArray alloc]init];
    }
    return _detailOrderData;
}
@end
