//
//  WQnewFriendsViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

//目前的处理并不适合扩展需要后续优化 TODO


#import <AddressBook/AddressBook.h>
#import "WQnewFriendsViewController.h"
#import "WQpushnewFriendsTableViewCell.h"
#import "WQnewFriendsModel.h"
#import "WQrecommendnewFriendsModel.h"
#import "WQrecommendFriendsTableViewCell.h"
#import "WQaddFriendsController.h"
#import "WQfriendsModel.h"
#import "WQFriendsNoticeView.h"
#import "WQfriend_listModel.h"
#import "WQrecommendFriends.h"
#import "EMClient.h"
#import "WQPendingNewFriendCell.h"
#import "WQPhoneBookFriendsViewController.h"
#import "WQInviteFriendsViewController.h"
#import "WQUserProfileController.h"

static NSString *cellid = @"cellid";
static NSString *twoCellId = @"twocellid";

@interface WQnewFriendsViewController ()<UITableViewDelegate,UITableViewDataSource,WQPendingNewFriendCellAccceptFriendRequestDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableDictionary *contactParams;
@property (nonatomic, strong) NSMutableArray *recommendFriendsArray;
@property (nonatomic, strong) NSMutableDictionary *newFriendsParams;

@property (nonatomic, copy) NSString *aUsername;
@property (nonatomic, copy) NSString *aMessage;

@property (nonatomic, strong) WQFriendsNoticeView *topTableView;
@property (nonatomic, assign) NSInteger totalHight;

/**
 取得待处理的好友请求列表获取完毕后需要去取得头像姓名所以需要同步
 */
@property (nonatomic, strong) dispatch_group_t friendListGroup;

@property (nonatomic, retain) NSMutableArray * friendModelArray;
@end

@implementation WQnewFriendsViewController {
    WQLoadingView *loadingView;
    WQLoadingError *loadingError;
}

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xededed];
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//        [SVProgressHUD showWithStatus:@"加载中…"];
    });
    
    [self setupUI];
    [self fetchFriendList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:WQ_SHADOW_IMAGE];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"新的朋友";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName : [UIFont systemFontOfSize:20]}];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
}

#pragma mark - netWork
- (void)fetchFriendList {
    _friendModelArray = @[@[],@[],@[]].mutableCopy;
    _friendListGroup = dispatch_group_create();
    
    [self fetchFriendRequest];
}

- (void)fetchFriendRequest {
    NSString *urlString = @"api/friend/applymelist";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:dict completion:^(id response, NSError *error) {

        if (error) {
//            dispatch_group_leave(_friendListGroup);
            [loadingView dismiss];
            [loadingError show];
            return ;
        }
        
        NSMutableArray * arr = [NSArray yy_modelArrayWithClass:[WQPendingNewFriendModel class] json:response[@"list"]].mutableCopy;
        
        if (arr.count) {
            _friendModelArray[0] =arr;
        }
        [loadingError dismiss];
        [self fetchRecommendFriendList];
    }];
}

- (void)fetchRecommendFriendList {
    NSString *urlString = @"api/friend/get";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    
    //    值为（0,1,2，3）；0=获取推荐好友（该好友是通讯录联系人并且已注册本平台）；1=获取当前好友（通过Set接口设置好友的结果，APP获取好友列表应该从IM服务器获取，而不是本接口）；2=获取推荐好友（好友的好友）
    dict[@"degree"] = @(2).description;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:dict completion:^(id response, NSError *error) {
        if (error) {
//            dispatch_group_leave(_friendListGroup);
            [loadingView dismiss];
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        
        NSArray * recommendFriends = [self parseFriendData:response];
        
        [_friendModelArray replaceObjectAtIndex:2 withObject:recommendFriends];
        [self fetchAdressBookFriendList];
    }];
    
}

- (void)fetchAdressBookFriendList {
    NSString *urlString = @"api/friend/get";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    
    //    值为（0,1,2，3）；0=获取推荐好友（该好友是通讯录联系人并且已注册本平台）；1=获取当前好友（通过Set接口设置好友的结果，APP获取好友列表应该从IM服务器获取，而不是本接口）；2=获取推荐好友（好友的好友）
    dict[@"degree"] = @(0).description;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:dict completion:^(id response, NSError *error) {
        if (error) {
//            dispatch_group_leave(_friendListGroup);
            NSLog(@"%@",error);
            [loadingView dismiss];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        
        NSArray * addressBookFriend = [self parseFriendData:response];
        [_friendModelArray replaceObjectAtIndex:1 withObject:addressBookFriend];
        [self.tableview reloadData];
        [loadingView dismiss];
//        [SVProgressHUD dismiss];
    }];
}

- (NSArray *)parseFriendData:(NSDictionary *)friendData {
    
    NSMutableArray * friendModelArray = @[].mutableCopy;
    
    NSArray * friends = friendData[@"friends"];
    
    if (!friends.count) {
        return friendModelArray;
    }
    
    for (NSDictionary * oneFriendSection in friends) {
        
        NSArray * friendsWithSameSpell = oneFriendSection[@"friend_list"];
        NSArray * models = [NSMutableArray yy_modelArrayWithClass:[WQrecommendnewFriendsModel class] json:friendsWithSameSpell];
        [friendModelArray addObjectsFromArray:models];
    }
    return friendModelArray;
}


#pragma mark - UI
- (void)setupUI {
    UITableView *tableview = [[UITableView alloc]init];
    tableview.backgroundColor = [UIColor whiteColor];
    self.tableview = tableview;
    [tableview registerClass:[WQpushnewFriendsTableViewCell class] forCellReuseIdentifier:cellid];
    [tableview registerClass:[WQrecommendFriendsTableViewCell class] forCellReuseIdentifier:twoCellId];
    [tableview registerNib:[UINib nibWithNibName:@"WQPendingNewFriendCell" bundle:nil] forCellReuseIdentifier:@"WQPendingNewFriendCell"];
    [self.view addSubview:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.left.right.bottom.equalTo(self.view);
    }];
    tableview.dataSource = self;
    tableview.delegate = self;
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footer.backgroundColor = WQ_BG_LIGHT_GRAY;
    self.view.backgroundColor = WQ_BG_LIGHT_GRAY;
    _tableview.backgroundColor = WQ_BG_LIGHT_GRAY;
    tableview.tableFooterView = footer;
    tableview.tableHeaderView = [UIView new];
    
    
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakLoadingView show];
        });
        [weakSelf fetchFriendList];
    }];
    [loadingError dismiss];
    [self.view addSubview:loadingError];
    [loadingError mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - TableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.friendModelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friendModelArray[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell;
    if ([_friendModelArray[indexPath.section] count] <= indexPath.row) {
        return UITableViewCell.new;
    }
    if (indexPath.section) {
        WQrecommendFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twoCellId ];
        if (indexPath.section) {
            cell.type = indexPath.section;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([_friendModelArray[indexPath.section] count] <= indexPath.row) {
            return UITableViewCell.new;
        }
        
        cell.model = _friendModelArray[indexPath.section][indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) weakSelf= self;
        __weak typeof(cell) weakCell= cell;

        [cell setFriendsAddBtnClikeBlock:^{
            
            WQUserProfileModel * model = weakSelf.friendModelArray[indexPath.section][indexPath.row];
            NSString *huanxinId = model.user_id.length ? model.user_id : model.im_namelogin;
            WQaddFriendsController *vc = [[WQaddFriendsController alloc]initWithIMId:huanxinId];
            vc.type = @"添加好友";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    } else {
        WQPendingNewFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQPendingNewFriendCell"];
        
        cell.model = _friendModelArray[indexPath.section][indexPath.row];
        cell.delegate = self;
//        cell.acceptFriendRequest = ^(NSString *friend_apply_id) {
//            NSString * strURL = @"api/friend/aggreefriendapply";
////            secretkey true string
////            friend_apply_id true string
//            NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
//            if (!secreteKey.length) {
//                return;
//            }
//            NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
//            param[@"friend_apply_id"] = friend_apply_id;
//
//            WQNetworkTools *tools = [WQNetworkTools sharedTools];
//            [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
//                if (error) {
//                    return ;
//                }
//
//
//                if ([response[@"success"] boolValue]) {
//
//
//                    [_friendModelArray[0] removeObjectAtIndex:indexPath.row];
//
//                    [_tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//
//                    [APPDELEGATE updateBidStatus];
//                }
//
//            }];
//        };
        return cell;
    }
    
    
    
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    WQrecommendFriendsTableViewCell* cell0 = (WQrecommendFriendsTableViewCell*)cell;

//    WQrecommendFriendsTableViewCell *cell0 = [tableView cellForRowAtIndexPath:indexPath];
//    if (indexPath.section) {
//        cell0.type = indexPath.section;
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!indexPath.section) {
        WQPendingNewFriendModel *model = _friendModelArray[indexPath.section][indexPath.row];
        WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:model.user_id];
        vc.fromFriendRequest = YES;
        vc.requestInfo = model.friend_apply_message;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    WQPendingNewFriendModel * model = _friendModelArray[indexPath.section][indexPath.row];
    
    
    
    NSString * strURL = @"api/friend/aggreefriendapply";
    //            secretkey true string
    //            friend_apply_id true string
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    param[@"friend_apply_id"] = model.friend_apply_id;
    param[@"aggree"] = @(NO);
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            return ;
        }
        if ([response[@"success"] boolValue]) {
            [_friendModelArray[0] removeObjectAtIndex:indexPath.row];
            [_tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [APPDELEGATE updateBidStatus];
        }
    }];
};



#pragma mark - barbuttonItem
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)WQPendingNewFriendCell:(WQPendingNewFriendCell *)cell accceptFriendRequestBtnClicked:(UIButton *)sender {
    NSString * strURL = @"api/friend/aggreefriendapply";
    ////            secretkey true string
    ////            friend_apply_id true string
                NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
                if (!secreteKey.length) {
                    return;
                }
                NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
                param[@"friend_apply_id"] = cell.model.friend_apply_id;
    
                WQNetworkTools *tools = [WQNetworkTools sharedTools];
                [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
                    if (error) {
                        return ;
                    }
    
    
                    if ([response[@"success"] boolValue]) {
                        
                        NSInteger index = [_friendModelArray[0] indexOfObject:cell.model];
                        
                        [_friendModelArray[0] removeObjectAtIndex:index];
    
                        [_tableview deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
                        [APPDELEGATE updateBidStatus];
                    }
    
                }];
}

#pragma mark - 懒加载


- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
- (NSMutableDictionary *)contactParams {
    if (!_contactParams) {
        _contactParams = [[NSMutableDictionary alloc]init];
    }
    return _contactParams;
}
- (NSArray *)recommendFriendsArray {
    if (!_recommendFriendsArray) {
        _recommendFriendsArray = [[NSMutableArray alloc]init];
    }
    return _recommendFriendsArray;
}

- (NSMutableDictionary *)newFriendsParams {
    if (!_newFriendsParams) {
        _newFriendsParams = [[NSMutableDictionary alloc] init];
    }
    return _newFriendsParams;
}
@end
