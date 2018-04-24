//
//  WQCompletedCollectionViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/12.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQCompletedCollectionViewCell.h"
#import "WQWaitOrderoncModel.h"
#import "WQCompletedTableViewCell.h"
#import "WQWaitOrderModel.h"
#import "WQMyReceivinganOrderVisitorsLoginView.h"
#import "WQOrderTableViewCell.h"

static NSString *cellid = @"cellid";

@interface WQCompletedCollectionViewCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableDictionary *params;         //获取UI数据
@property (nonatomic, strong) NSMutableDictionary *haunxinparams;  //获取需求信息的参数
@property (nonatomic, strong) NSMutableArray *detailOrderData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WQWaitOrderoncModel *waitOrderoncModel;
@property (nonatomic, strong) WQMyReceivinganOrderVisitorsLoginView *myReceivinganOrderVisitorsLoginView;
@property (nonatomic, strong) NSMutableDictionary *applicationForDrawbackDict;
@property (nonatomic, copy) NSString *nbid;
@property (nonatomic, copy) NSString *needsid;     //发送到的环信ID
@property (nonatomic, copy) NSString *huanxinId;   //接收对应的环信ID
@end

@implementation WQCompletedCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    [self loadData];
    //UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
    //topView.backgroundColor = [UIColor colorWithHex:0xededed];
    UITableView *tableView = [[UITableView alloc]init];
    //tableView.tableHeaderView = topView;
    //[tableView registerNib:[UINib nibWithNibName:@"WQCompletedTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
    [tableView registerClass:[WQCompletedTableViewCell class] forCellReuseIdentifier:cellid];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
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
    
    NSLog(@"%@",self.detailOrderData);
    
    return self;
    
}

#pragma mark - 获取环信id
- (void)loadHuanxinidNbid:(NSString *)nbid
{
    NSString *urlString = @"api/need/getneedbidder";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.haunxinparams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    _haunxinparams[@"nid"] = nbid;
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
            self.nbid = dict[@"id"];
        }
        [self applicationForDrawbackBtnClike:self.nbid];
    }];
}
#pragma mark - UI数据
- (void)loadData
{
    NSString *urlString = @"api/need/mycreatedneed";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    self.params[@"type"] = @"STATUS_FNISHED";
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
            [self.tableView reloadData];
            for (WQWaitOrderModel * model in _waitOrderoncModel.needs) {
                
                [WQUnreadMessageCenter removeMessagesAboutBid:model.id];
            }
        }
        
    }];
}


#pragma mark -tableView数据源方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"%zd",self.waitOrderoncModel.needs.count);
    return self.waitOrderoncModel.needs.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WQCompletedTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *id = cell.waitorderModel.id;
    __weak typeof(self) weakSelf = self;
    if (weakSelf.completedPushxiangqingClikeBlock) {
        weakSelf.completedPushxiangqingClikeBlock(id);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WQCompletedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid
                                                                     forIndexPath:indexPath];
    cell.waitorderModel = self.waitOrderoncModel.needs[indexPath.row];
    

    
//    [cell setApplicationForDrawbackBtnClikeBlock:^{
//        WQCompletedTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        NSString *nbid = cell.waitorderModel.id;
//        [self loadHuanxinidNbid:nbid];
//    }];
    return cell;
    
}

//申请退款
- (void)applicationForDrawbackBtnClike:(NSString *)nbid
{
    NSString *urlString = @"api/need/changebiddedneedworkstatus";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.applicationForDrawbackDict[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    _applicationForDrawbackDict[@"work_status"] = @"WORK_STATUS_ARBIRATION";
    _applicationForDrawbackDict[@"nbid"] = nbid;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_applicationForDrawbackDict completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
    }];

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
- (NSMutableDictionary *)applicationForDrawbackDict
{
    if (!_applicationForDrawbackDict) {
        _applicationForDrawbackDict = [[NSMutableDictionary alloc]init];
    }
    return _applicationForDrawbackDict;
}

@end
