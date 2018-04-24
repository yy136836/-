//
//  WQGroupController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupController.h"
#import "WQGroupListCell.h"
#import "WQGroupMembersController.h"
#import "WQTopicDetailController.h"
#import "WQGroupDynamicViewController.h"
#import "WQGroupModel.h"
#import "WQGroupInformationViewController.h"

@interface WQGroupController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UISearchBar * searchBar;
@property (nonatomic, retain) UITableView * mainTable;
@property (nonatomic, retain) NSMutableArray * groupList;
@end

static NSString * cellID = @"groupListCell";
@implementation WQGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _groupList = @[].mutableCopy;
    [self setupUI];
    [self loadGroupList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _searchBar.text = nil;
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)setupUI {
    _searchBar = [[UISearchBar alloc] init];
    [self.view addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    _searchBar.delegate = self;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.showsCancelButton = NO;


    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"取消"];
    [_searchBar setTintColor:[UIColor blackColor]];

    _searchBar.backgroundImage = [UIImage imageWithColor:[UIColor colorWithHex:0xededed]];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
    
     setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor],
      NSForegroundColorAttributeName,
      nil]
     
     forState:UIControlStateNormal];

    
    _mainTable = [[UITableView alloc] init];
    [self.view addSubview:_mainTable];
    [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_searchBar.mas_bottom);
    }];
    
    
    
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.tableFooterView = [UIView new];
    _mainTable.tableHeaderView = [UIView new];
    [_mainTable registerNib:[UINib nibWithNibName:@"WQGroupListCell" bundle:nil] forCellReuseIdentifier:cellID];
    
}

- (void)loadGroupList {
    NSString * strURL = @"api/group/mygrouplist";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSDictionary * param = @{@"secretkey":secreteKey};
//    [SVProgressHUD showWithStatus:@"正在加载..."];
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {

//        gid true string 群ID
//        name true string 群名称
//        member_count true string 群内已正式加入的成员总数
//        isOwner true string 当前用户是否为该群的群主
//        joined_datetime true string 加入该群的时间：yyyy-MM-dd HH:mm:ss
//        latest_topic_name true string 最新的主题的标题
        
        if (error) {
            [SVProgressHUD showWithStatus:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.3];
            return ;
        }
        if (![response[@"success"] boolValue]) {
            [SVProgressHUD showWithStatus:@"请检查网络连接"];
            [SVProgressHUD dismissWithDelay:1.3];
            return;
        }
        
//        [SVProgressHUD dismissWithDelay:0.1];
        [_groupList removeAllObjects];
        
        
        
        [_groupList addObjectsFromArray:[NSArray yy_modelArrayWithClass:[WQGroupModel class] json:response[@"groups"]]];
        
        for (WQGroupModel * model in _groupList) {
            model.isMember = YES;
        }
        
        [_mainTable reloadData];
    }];


}



#pragma mark - searchBar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (!searchBar.text.isVisibleString) {
        [WQAlert showAlertWithTitle:nil message:@"请输入搜索条件" duration:1.3];
    }
    
    NSString * strURL = @"api/group/querygroup";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    
    
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    param[@"name"] = _searchBar.text.length?_searchBar.text:@"";
    
    param[@"start"] = @"0";
    param[@"limit"] = @"1000";
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            return ;
        }
        
        [_groupList removeAllObjects];
        [_groupList addObjectsFromArray:[NSArray yy_modelArrayWithClass:[WQGroupModel class] json:response[@"groups"]]];
        [_mainTable reloadData];
    }];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self loadGroupList];
    searchBar.text = nil;
    [self.view endEditing:YES];
}


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    return YES;
}


#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groupList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WQGroupListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = _groupList[indexPath.row];
    __weak typeof(cell) weakCell = cell;
    // 点击头像的事件
    [cell setWqAvatarImageViewClikeBlock:^{
        WQGroupInformationViewController *vc = [[WQGroupInformationViewController alloc] init];
        vc.gid = weakCell.model.gid;
        vc.groupModel = weakCell.model;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    
    
    return cell;
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WQGroupModel * model = _groupList[indexPath.row];
    
    if (!model.isMember) {
        WQGroupListCell * cell = [_mainTable cellForRowAtIndexPath:indexPath];
        cell.wqAvatarImageViewClikeBlock();
        return;
    }
    
    WQGroupDynamicViewController *vc = [[WQGroupDynamicViewController alloc] init];
    vc.gid = model.gid;
    vc.groupModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


@end
