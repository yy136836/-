//
//  WQWaitOrderCollectionViewCell.h

//
//  Created
//  Copyright © 2016年 shihua. All rights reserved.
//





#import "WQWaitOrderCollectionViewCell.h"
#import "WQOrderTableViewCell.h"
#import "WQWaitOrderModel.h"
#import "WQWaitOrderoncModel.h"
#import "WQChaViewController.h"
#import "WQMyReceivinganOrderVisitorsLoginView.h"
#import "WQMyOrderViewController.h"

static NSString *cellid = @"cellid";

@interface WQWaitOrderCollectionViewCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *tableViewdetailOrderData;
@property (nonatomic, strong) WQOrderTableViewCell *cell;
@property (nonatomic, strong) WQWaitOrderoncModel *waitOrderoncModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *haunxinparams;
@property (nonatomic, copy) NSString *huanxinId;  //环信id
@property (nonatomic, copy) NSString *needsid;    //用户id
@property (nonatomic, weak) WQMyOrderViewController * vc;
@property (nonatomic, strong) WQMyReceivinganOrderVisitorsLoginView *myReceivinganOrderVisitorsLoginView;
@end

@implementation WQWaitOrderCollectionViewCell


-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    [self loadData];
    //UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
    //topView.backgroundColor = [UIColor colorWithHex:0xededed];
    
    UITableView *tableView = [[UITableView alloc]init];
    //tableView.tableHeaderView = topView;
    //[tableView registerNib:[UINib nibWithNibName:@"WQOrderTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
    [tableView registerClass:[WQOrderTableViewCell class] forCellReuseIdentifier:cellid];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    tableView.alpha = 1;
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

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteClike) name:WQdeleteClike object:nil];
    
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
    self.params[@"type"] = @"STATUS_BIDDING";
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
            [self.tableView reloadData];
            
            NSMutableArray * needIds = @[].mutableCopy;
            
            for (WQWaitOrderModel * model in _waitOrderoncModel.needs) {
                [needIds addObject:model.id];
            }
            
            [_vc hideOrShowDotForBills:needIds ofBidType:BidTypeToSelect];
            _vc.toSelectBidIds = needIds;
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
    WQOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *id = cell.waitorderModel.id;
    __weak typeof(self) weakSelf = self;
    if (weakSelf.pushxiangqingClikeBlock) {
        weakSelf.pushxiangqingClikeBlock(id);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WQOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    self.cell = cell;
    cell.waitorderModel = self.waitOrderoncModel.needs[indexPath.row];
    __weak typeof(self) weakSelf = self;
    [cell setPersonnelClikeBlock:^{
        WQOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *id = cell.waitorderModel.id;
        if (weakSelf.xiangqingWQDefaultTasksBlock) {
            weakSelf.xiangqingWQDefaultTasksBlock(id);
        }
    }];
    
    BOOL redDotbool =  [WQUnreadMessageCenter haveUnreadMessageForBid:cell.waitorderModel.id] || cell.waitorderModel.reddot;

    
    
    
    if (redDotbool) {
        cell.redDotView.hidden = NO;
    }else
    {
        cell.redDotView.hidden = YES;
    }
    
    return cell;
}

#pragma mark - 通知方法
- (void)deleteClike
{
    [self loadData];
}

#pragma mark - dealloc

- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:WQdeleteClike];
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
