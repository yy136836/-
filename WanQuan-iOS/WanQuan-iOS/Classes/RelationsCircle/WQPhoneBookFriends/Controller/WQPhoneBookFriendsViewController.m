//
//  WQPhoneBookFriendsViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/11/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQPhoneBookFriendsViewController.h"
#import "WQPhoneBookFriendsHasJoinedTableViewCell.h"
#import "WQPhoneBookFriendsThereIsNoJoinTableViewCell.h"
#import "WQPhoneBookFriendsBottomView.h"
#import "WQPhoneBookFriendsModel.h"

static NSString *identifier = @"identifier";
static NSString *identifiertwo = @"WQPhoneBookFriendsThereIsNoJoinTableViewCell";

@interface WQPhoneBookFriendsViewController () <UITableViewDelegate, UITableViewDataSource,WQPhoneBookFriendsBottomViewDelegate,WQPhoneBookFriendsHasJoinedTableViewCellDelegate,WQPhoneBookFriendsThereIsNoJoinTableViewCellDelegate>

/**
 tableView
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 已经加入万圈好友
 */
@property (nonatomic, strong) NSArray *hasJoinedArray;

/**
 没有加入万圈好友
 */
@property (nonatomic, strong) NSArray *notToJoinArray;

/**
 底部的view
 */
@property (nonatomic, strong) WQPhoneBookFriendsBottomView *bottomView;

@end

@implementation WQPhoneBookFriendsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"通讯录好友";
    UIBarButtonItem *completeBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeBtnClick)];
    self.navigationItem.rightBarButtonItem = completeBtn;
    [completeBtn setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
}

#pragma mark -- 完成的响应事件
- (void)completeBtnClick {
    WQTabBarController *vc = [WQTabBarController new];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}

- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self loadhasJoinedData];
}

#pragma mark -- 获取已加入万圈列表
- (void)loadhasJoinedData {
    NSString *urlString = @"api/contact/get";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"has_joined_wanquan"] = @"true";
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            self.hasJoinedArray = [NSArray yy_modelArrayWithClass:[WQPhoneBookFriendsModel class] json:response[@"contacts"]];
            [self loadnotToJoinData];
        }
    }];
}

#pragma mark -- 获取未加入万圈列表
- (void)loadnotToJoinData {
    NSString *urlString = @"api/contact/get";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"has_joined_wanquan"] = @"false";
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            self.notToJoinArray = [NSArray yy_modelArrayWithClass:[WQPhoneBookFriendsModel class] json:response[@"contacts"]];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark -- 初始化tableview
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView = tableView;
    // 设置代理对象
    tableView.delegate = self;
    tableView.dataSource = self;
    // 设置自动行高和预估行高
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 70;
    // 取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [tableView registerClass:[WQPhoneBookFriendsHasJoinedTableViewCell class] forCellReuseIdentifier:identifier];
    [tableView registerClass:[WQPhoneBookFriendsThereIsNoJoinTableViewCell class] forCellReuseIdentifier:identifiertwo];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
    
    WQPhoneBookFriendsBottomView *bottomView = [[WQPhoneBookFriendsBottomView alloc] init];
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.bottom.right.left.equalTo(self.view);
    }];
}

#pragma mark -- WQPhoneBookFriendsBottomViewDelegate
// 一键邀请
- (void)wqInvitationBtnClick:(WQPhoneBookFriendsBottomView *)bottomView {
    NSString *urlString = @"api/contact/invitejoinwq";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"invite_all"] = @"true";
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        [self loadnotToJoinData];
        [self.bottomView.invitationBtn setTitle:@"已邀请" forState:UIControlStateNormal];
        self.bottomView.invitationBtn.enabled = NO;
    }];
}

#pragma makr --  WQPhoneBookFriendsThereIsNoJoinTableViewCellDelegate
// 邀请的响应事件
- (void)wqInvitationClick:(WQPhoneBookFriendsThereIsNoJoinTableViewCell *)cell {
    NSString *urlString = @"api/contact/invitejoinwq";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"contact_id"] = cell.model.id;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            [cell.invitationBtn setEnabled:NO];
            [cell.invitationBtn setTitle:@"已邀请" forState:UIControlStateNormal];
            cell.invitationBtn.backgroundColor = [UIColor colorWithHex:0xf4f0ff];
            cell.invitationBtn.layer.borderColor = [UIColor colorWithHex:0xede6ff].CGColor;
            [cell.invitationBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kScaleY(60), 25));
            }];
        }
    }];
}

#pragma mark -- WQPhoneBookFriendsHasJoinedTableViewCellDelegate
// 添加的响应事件
- (void)wqAddClick:(WQPhoneBookFriendsHasJoinedTableViewCell *)cell {
    NSString *urlString = @"api/friend/applyfriend";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"message"] = @"";
    params[@"uid"] = cell.model.user_id;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if (![response[@"success"] boolValue]) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"对方是非实名认证用户,无法添加好友" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }else {
            [cell.addBtn setEnabled:NO];
            [cell.addBtn setTitle:@"已发送好友申请" forState:UIControlStateNormal];
            cell.addBtn.backgroundColor = [UIColor colorWithHex:0xf4f0ff];
            cell.addBtn.layer.borderColor = [UIColor colorWithHex:0xede6ff].CGColor;
            [cell.addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kScaleY(115), 30));
            }];
        }
    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.hasJoinedArray.count;
    }else {
        return self.notToJoinArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WQPhoneBookFriendsHasJoinedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.hasJoinedArray[indexPath.row];
        
        return cell;
    }else {
        WQPhoneBookFriendsThereIsNoJoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiertwo forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.notToJoinArray[indexPath.row];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    view.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    UILabel *textLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:16];
    [view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(view.mas_left).offset(kScaleY(ghSpacingOfshiwu));
    }];
    if (section == 0) {
        textLabel.text = @"他们已加入万圈,快添加他们为好友吧";
    }else {
        textLabel.text = @"他们还没有加入实名校友圈,快发出邀请吧";
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

@end
