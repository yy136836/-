//
//  WQInviteFriendsViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/11/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQInviteFriendsViewController.h"
#import "WQPhoneBookFriendsBottomView.h"
#import "WQPhoneBookFriendsThereIsNoJoinTableViewCell.h"
#import "WQPhoneBookFriendsModel.h"

static NSString *identifier = @"identifier";

@interface WQInviteFriendsViewController () <WQPhoneBookFriendsThereIsNoJoinTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource,WQPhoneBookFriendsBottomViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISearchBar *seachBar;

/**
 底部的view
 */
@property (nonatomic, strong) WQPhoneBookFriendsBottomView *bottomView;

/**
 默认数据
 */
@property (nonatomic, strong) NSArray *notToJoinArray;

/**
 搜索出来的数据
 */
@property (nonatomic, strong) NSMutableArray *seachDataArray;

@end

@implementation WQInviteFriendsViewController {
    WQLoadingView *loadingView;
    WQLoadingError *loadingError;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsCompact];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"邀请好友";
    
    WQNavBackButton *btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    [self loadnotToJoinData];
}

- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

#pragma mark -- 初始化View
- (void)setUpView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UISearchBar *seachBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, kScreenWidth, 50)];
    self.seachBar = seachBar;
    seachBar.delegate = self;
    seachBar.placeholder = @"搜索通讯录好友";
    [seachBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xffffff]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    seachBar.barTintColor = [UIColor whiteColor];
    UITextField *textfield = [[[seachBar.subviews firstObject] subviews] lastObject];
    textfield.layer.borderWidth = .0f;
    textfield.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    
    [self.view addSubview:seachBar];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView = tableView;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    // 设置代理对象
    tableView.delegate = self;
    tableView.dataSource = self;
    // 设置自动行高和预估行高
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 70;
    // 取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [tableView registerClass:[WQPhoneBookFriendsThereIsNoJoinTableViewCell class] forCellReuseIdentifier:identifier];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
        make.top.equalTo(seachBar.mas_bottom);
    }];
    
    WQPhoneBookFriendsBottomView *bottomView = [[WQPhoneBookFriendsBottomView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.bottom.right.left.equalTo(self.view);
    }];
    
    loadingView = [[WQLoadingView alloc] init];
    [loadingView show];
    [self.view addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(loadingView) weakLoadingView = loadingView;
    loadingError = [[WQLoadingError alloc] init];
    [loadingError setClickRetryBtnClickBlock:^{
        [weakLoadingView show];
        [weakSelf loadnotToJoinData];
    }];
    [loadingError dismiss];
    [self.view addSubview:loadingError];
    [loadingError mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.left.right.bottom.equalTo(self.view);
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
            [loadingView dismiss];
            [loadingError show];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            self.notToJoinArray = [NSArray yy_modelArrayWithClass:[WQPhoneBookFriendsModel class] json:response[@"contacts"]];
            [self.tableView reloadData];
            [loadingView dismiss];
            [loadingError dismiss];
        }
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

#pragma amrk -- WQPhoneBookFriendsThereIsNoJoinTableViewCellDelegate
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

#pragma mark - SearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!searchText.length) {
        [self.seachBar resignFirstResponder];
        [self.tableView reloadData];
        return;
    }
    if (self.seachDataArray) {
        [self.seachDataArray removeAllObjects];
    }
    
    for (WQPhoneBookFriendsModel *model in self.notToJoinArray) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", searchText];
        if ([predicate evaluateWithObject:model.name]) {
            [self.seachDataArray addObject:model];
        }
    }
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_seachBar.text.length) {
        return self.seachDataArray.count;
    }
    return self.notToJoinArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQPhoneBookFriendsThereIsNoJoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.delegate = self;
    
    if (self.seachBar.text.length) {
        cell.model = self.seachDataArray[indexPath.row];
    } else {
        cell.model = self.notToJoinArray[indexPath.row];
    }
    
    return cell;
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
    textLabel.text = @"他们还没有加入实名校友圈,快发出邀请吧";
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark -- 懒加载
- (NSMutableArray *)seachDataArray {
    if (!_seachDataArray) {
        _seachDataArray = [NSMutableArray array];
    }
    return _seachDataArray;
}

@end
