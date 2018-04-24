//
//  WQUserProfileAllJoinedGroupsController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/29.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUserProfileAllJoinedGroupsController.h"
#import "WQUserprofileJoinedGroupNotSelfCell.h"
#import "WQUserProfileGroupModel.h"
#import "WQGroupInformationViewController.h"
#import "WQGroupDynamicViewController.h"

@interface WQUserProfileAllJoinedGroupsController ()

@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * userName;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WQUserProfileAllJoinedGroupsController {
    WQLoadingView *loadingView;
}


- (instancetype)initWithUserId:(NSString *)userId {
    if (self = [super init]) {
        _userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];
}

- (void)setupView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.bounds;
    // 设置代理对象
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    // 取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerNib:[UINib nibWithNibName:@"WQUserprofileJoinedGroupNotSelfCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"WQUserprofileJoinedGroupNotSelfCell"];
//    tableView.estimatedRowHeight = 402.5;
    [self.view addSubview:tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.title = @"加入的圈子";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]}];
    [self loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groupsInfo.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQUserprofileJoinedGroupNotSelfCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WQUserprofileJoinedGroupNotSelfCell"];
    
    cell.model = _groupsInfo[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WQUserProfileGroupModel * model = _groupsInfo[indexPath.row];
    if (model.isGroupUser) {
        WQGroupDynamicViewController *vc = [[WQGroupDynamicViewController alloc] init];
        vc.gid = model.gid;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        WQGroupInformationViewController * vc = [[WQGroupInformationViewController alloc] init];
        vc.gid = model.gid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)loadData {
    
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
