//
//  WQNearbyroboneViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/23.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQNearbyroboneViewController.h"
#import "WQNearbyroboneTabViewcell.h"
#import "WQHomeNearby.h"
#import "WQNearbyroboneBottomView.h"

static NSString *cellID = @"cellid";

@interface WQNearbyroboneViewController ()<UITableViewDelegate,UITableViewDataSource,WQNearbyroboneBottomViewDelegate>
//参数
@property(nonatomic,strong)NSMutableDictionary *params;
@property(nonatomic,strong)NSMutableArray *tableViewdetailOrderData;
//是否匿名
@property(nonatomic,assign)BOOL whetheranonymous;
//抢单输入的优势
@property(nonatomic,strong)NSMutableDictionary *successParams;
@property(nonatomic,strong)NSMutableDictionary *requestparams;
@property(nonatomic,strong)WQHomeNearby *homemodel;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSIndexPath *wqIndexPath;
@end

@implementation WQNearbyroboneViewController

- (instancetype)initWithUserId:(NSString *)stringUserId {
    if (self = [super init]) {
        self.stringuserId = stringUserId;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"我能帮助";
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;

}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    [self loadData];
}

#pragma mark - 请求数据
- (void)loadData {
    NSString *urlString = @"api/need/getneedinfo";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.requestparams[@"nid"] = self.stringuserId;
    _requestparams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_requestparams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        WQHomeNearby *model = [WQHomeNearby yy_modelWithJSON:response];
        self.homemodel = model;
        [self.tableViewdetailOrderData addObject:self.homemodel];
        [self.tableview reloadData];
    }];
}

#pragma mark - 初始化UI
- (void)setupUI {
    UITableView *tableview = [UITableView new];
    self.tableview = tableview;
    [tableview registerClass:[WQNearbyroboneTabViewcell class] forCellReuseIdentifier:cellID];
    //取消分割线
    tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(kScaleX(-76));
    }];
    
    WQNearbyroboneBottomView *bottomView = [[WQNearbyroboneBottomView alloc] init];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.height.offset(kScaleX(76));
    }];
    
    tableview.dataSource = self;
    tableview.delegate = self;
}

#pragma masrk -- WQNearbyroboneBottomViewDelegate
- (void)wqSubmitBtnClick:(WQNearbyroboneBottomView *)bottomView {
    [self rushonebtnClike];
}

#pragma mark - 抢单的点击事件,加载数据
- (void)rushonebtnClike {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"抢单失败" message:@"请登陆后重新尝试" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }else {
    
        WQNearbyroboneTabViewcell *cell = [self.tableview cellForRowAtIndexPath:self.wqIndexPath];
        if (cell.superiorityTextView.text.length > 50) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"抢单失败" message:@"请勿输入超50个字" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return;
        }
        
        [[WQAuthorityManager manger] showAlertForAPNSAuthority];
        
        NSString *urlString = @"api/need/bidneed";
        self.params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        _params[@"nid"] = self.stringuserId;
        NSString *stringFloat = (_whetheranonymous==false)?@"true":@"false";
        _params[@"truename"] = stringFloat;
        
        _params[@"text"] = cell.superiorityTextView.text;
        
        [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                return ;
            }
            NSLog(@"%@",response);
            
            
            
            NSDictionary *dict = response;
            BOOL successbool = [dict[@"success"] boolValue];
            if (successbool) {
                
                NSString *urlString = @"api/need/getneedbidder";
                self.successParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
                _successParams[@"nid"] = self.stringuserId;
                [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_successParams completion:^(id response, NSError *error) {
                    if (error) {
                        NSLog(@"%@",error);
                        return ;
                    }
                    NSLog(@"%@",response);
                    NSDictionary *dict = response;
                    NSLog(@"%@",dict);
                }];
                
                BOOL successbool = [response[@"success"] boolValue];
                if (!successbool) {
                    NSString *str = [NSString stringWithFormat:@"%@",response[@"message"]];
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"抢单失败" message:str preferredStyle:UIAlertControllerStyleAlert];
                    
                    [self presentViewController:alertVC animated:YES completion:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alertVC dismissViewControllerAnimated:YES completion:nil];
                        });
                    }];
                    return;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:WQorderReceivingsucceedin object:self];
                //抢单成功
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"抢单成功" message:@"可在我接的需求中查询" preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:^{
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    });
                }];
            }else {
                NSString *str = [NSString stringWithFormat:@"%@",dict[@"message"]];
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"抢单失败" message:str preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
                return;
            }
        }];
    }
}

#pragma mark - tableView数据源
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 550;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewdetailOrderData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQNearbyroboneTabViewcell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    self.wqIndexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    [cell setBoolwhetheranonBlock:^(BOOL whetheranonymous) {
        weakSelf.whetheranonymous = whetheranonymous;
    }];
    WQHomeNearby *model = self.tableViewdetailOrderData[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}

- (NSMutableDictionary *)successParams {
    if (!_successParams) {
        _successParams = [[NSMutableDictionary alloc]init];
    }
    return _successParams;
}

- (NSMutableDictionary *)requestparams {
    if (!_requestparams) {
        _requestparams = [[NSMutableDictionary alloc]init];
    }
    return _requestparams;
}

- (NSMutableArray *)tableViewdetailOrderData {
    if (!_tableViewdetailOrderData) {
        _tableViewdetailOrderData = [[NSMutableArray alloc]init];
    }
    return _tableViewdetailOrderData;
}

@end
