//
//  WQDetailsViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQDetailsViewController.h"
#import "WQDetailsTableViewCell.h"
#import "WQHomeNearby.h"
#import "WQPeopleListModel.h"

static NSString *cellID = @"cellid";

@interface WQDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableDictionary *PeopleListparams;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) WQHomeNearby *homemodel;
@property (nonatomic, strong) NSMutableArray *tableViewdetailOrderData;
@property (nonatomic, strong) NSMutableDictionary *confirmParams;
@property (nonatomic, assign) OrderType wqorderType;
@property (nonatomic, copy) NSString *needid;

@end

@implementation WQDetailsViewController

- (instancetype)initWithid:(NSString *)needid wqOrderType:(OrderType)orderType
{
    if (self = [super init]) {
        self.needid = needid;
        self.wqorderType = orderType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中…请稍候"];
    [self loadData];
    [self loadPeopleListData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"需求详情";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - 初始化UI
- (void)setupUI
{
    UITableView *tableview = [[UITableView alloc]init];
    [tableview registerNib:[UINib nibWithNibName:@"WQDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.tableview = tableview;
    
    //取消分割线
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    tableview.delegate = self;
    tableview.dataSource = self;
}
#pragma mark - 加载UI数据
- (void)loadData
{
    NSString *urlString = @"api/need/getneedinfo";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.params[@"nid"] = self.needid;
    _params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        WQHomeNearby *model = [WQHomeNearby yy_modelWithJSON:response];
        self.homemodel = model;
        
        __weak typeof(self)weakSelf = self;
        [model setImagesBlock:^{
            [weakSelf.tableViewdetailOrderData addObject:weakSelf.homemodel];
            [SVProgressHUD dismiss];
            [weakSelf.tableview reloadData];
        }];
//        [SVProgressHUD dismiss];
//        [weakSelf.tableview reloadData];
    }];
}

- (void)loadPeopleListData
{
    [SVProgressHUD showWithStatus:@"加载中…"];
    NSString *urlString = @"api/need/getneedbidder";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.PeopleListparams[@"nid"] = self.needid;
    _PeopleListparams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        [SVProgressHUD dismiss];
        NSLog(@"%@",response);
        self.modelArray = [NSArray yy_modelArrayWithClass: NSClassFromString(@"WQPeopleListModel") json:response[@"bids"]].mutableCopy;
        NSLog(@"%@",self.modelArray);
    }];
}

#pragma mark - tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 876;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewdetailOrderData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WQDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WQHomeNearby *model = self.tableViewdetailOrderData[indexPath.row];
    cell.model = model;
    for (int i = 0; i < self.modelArray.count ; i++) {
        cell.peopleListModel = self.modelArray[i];
    }
    if (self.wqorderType == OrderTypeSelected) {
        cell.confirmBtn.hidden = YES;
    }
    if (self.wqorderType == OrderTypeEnsure) {
        cell.confirmBtn.hidden = NO;
        [cell setConfirmBtnClikeBlock:^{
            NSString *urlString = @"api/need/changebiddedneedworkstatus";
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            WQDetailsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString *nbid = cell.peopleListModel.id;
            weakSelf.confirmParams[@"nbid"] = nbid;
            _confirmParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
            _confirmParams[@"work_status"] = @"WORK_STATUS_PRE_DONE";
            [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_confirmParams completion:^(id response, NSError *error) {
                if (error) {
                    NSLog(@"%@",error); 
                    return ;
                }
                if ([response isKindOfClass:[NSData class]]) {
                    response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
                }
                NSLog(@"%@",response);
                if ([response[@"success"] boolValue]) {
                    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"已经您完成的需求发送给发单人确认" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [self presentViewController:alertVC animated:YES completion:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alertVC dismissViewControllerAnimated:YES completion:nil];
                            [self dismissViewControllerAnimated:YES completion:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }];
                }else
                {
                    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",response[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                    
                    [self presentViewController:alertVC animated:YES completion:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alertVC dismissViewControllerAnimated:YES completion:nil];
                            [self dismissViewControllerAnimated:YES completion:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }];
                }
            }];
        }];
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
- (NSMutableArray *)tableViewdetailOrderData
{
    if (!_tableViewdetailOrderData) {
        _tableViewdetailOrderData = [[NSMutableArray alloc]init];
    }
    return _tableViewdetailOrderData;
}

- (NSMutableDictionary *)confirmParams
{
    if (!_confirmParams) {
        _confirmParams = [[NSMutableDictionary alloc]init];
    }
    return _confirmParams;
}

- (NSMutableDictionary *)PeopleListparams
{
    if (!_PeopleListparams) {
        _PeopleListparams = [[NSMutableDictionary alloc]init];
    }
    return _PeopleListparams;
}

- (NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc]init];
    }
    return _modelArray;
}

@end
