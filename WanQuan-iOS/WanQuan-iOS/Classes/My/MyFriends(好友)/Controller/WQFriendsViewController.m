//
//  WQFriendsViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/1.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "WQFriendsViewController.h"
#import "WQfriendsTableViewCell.h"
#import "WQmyFriendsModel.h"
#import "WQnewFriendsTableViewCell.h"
#import "WQnewFriendsViewController.h"
#import "WQChaViewController.h"
#import "WQUserProfileModel.h"
#import "WQUserProfileController.h"
#import "WQfriendsModel.h"
#import "WQfriend_listModel.h"
#import "WQNetworkTools.h"
#import "WQNewFriendTopView.h"
#import "WZLBadgeImport.h"
#import "WQInviteFriendsViewController.h"
//#import <Contacts/Contacts.h>


static NSString *newFriendsCellid = @"WQnewFriendsTableViewCell";
static NSString *cellID = @"cellid";

@interface WQFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) NSArray *userlist;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSArray *friendsArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *uploadContactParams;
@property (nonatomic, strong) NSMutableArray *contactArrayM;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableDictionary *aFriendParams;

@property (nonatomic, retain) UISearchBar * seachBar;

@property (nonatomic, retain) WQNewFriendTopView * topView;

@property (nonatomic, retain) UITableView * mainTable;


/**
 搜索的结果
 */
@property (nonatomic, retain) NSMutableArray * filterData;

@end

@implementation WQFriendsViewController {
    WQLoadingView *loadingView;
    WQLoadingError *loadingError;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (![WQDataSource sharedTool].verified) {
        [self fetchVerifyStatus];
    }
    
//    [SVProgressHUD showWithStatus:@"加载中..."];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    [self setupUI];
    //获取通讯录的授权信息
    [[WQAuthorityManager manger] showAlertForAdressBookAuthority];
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    switch (status) {
            //未授权, 请求授权
        case kABAuthorizationStatusNotDetermined: {
            
            ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, NULL),
                                                     ^(bool granted, CFErrorRef error) {
                                                         if (granted) {
                                                             NSLog(@"授权成功");
                                                             //获取联系人信息
                                                             [self onGetAddressBookInfo];
                                                         } else {
                                                             NSLog(@"授权失败");
                                                         }
                                                     });
            
            break;
        }
            //已授权
        case kABAuthorizationStatusAuthorized: {
            
            [self onGetAddressBookInfo];
            NSLog(@"已授权");
            break;
        }
            //其他情况, 给用户提示
        case kABAuthorizationStatusRestricted:
        case kABAuthorizationStatusDenied:{
            
            NSLog(@"请到设置中, 打开权限");
            break;
        }
        default:{
            break;
        }
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationItem.title = @"我的好友";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"邀请好友" style:UIBarButtonItemStylePlain target:self action:@selector(inviteAdessBookFriend)];
    [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:0x000000]}
                             forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem ;

    [self requestData];
    [self fetchDot];
}

/**
 邀请通讯录好友
 */
- (void)inviteAdessBookFriend {
    WQInviteFriendsViewController *vc = [[WQInviteFriendsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestData {
    NSString *urlString = @"api/friend/get";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    dict[@"degree"] = @(1).description;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:dict completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
//            [SVProgressHUD dismiss];
            [loadingView dismiss];
            [loadingError show];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        self.modelArray = [NSMutableArray yy_modelArrayWithClass:[WQfriendsModel class] json:response[@"friends"]].mutableCopy;
        [self.tableView reloadData];
        [loadingView dismiss];
        [loadingError dismiss];
//        [SVProgressHUD dismiss];
    }];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}



#pragma mark - 初始化UI
- (void)setupUI {
   
    _seachBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, kScreenWidth, 50)];
    _seachBar.tintColor = HEX(0xf3f3f3);
    [_seachBar setBackgroundImage:[UIImage imageWithColor:[UIColor groupTableViewBackgroundColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    _seachBar.placeholder = @"搜索";
    
    [self.view addSubview:_seachBar];
    _seachBar.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    _topView = [[WQNewFriendTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    [_topView setPushNewFriend:^{
        // MARK: 进入新的好友页面
        if (![[WQDataSource sharedTool] isVerified]) {
            // 快速注册的用户

            
            UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                                     message:@"您的好友太少了,请实名认证后添加更多好友"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     NSLog(@"取消");
                                                                 }];
            UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"实名认证"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                                          WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:[WQDataSource sharedTool].userIdString];
                                    
                                                                          [weakSelf.navigationController pushViewController:vc animated:YES];
                                                                      }];
            [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
            [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
            
            [alertController addAction:cancelButton];
            [alertController addAction:destructiveButton];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
        WQnewFriendsViewController *vc = [WQnewFriendsViewController new];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    UITableView *tableView = [[UITableView alloc]init];
    if (self.isNewFriends) {
        tableView.tableHeaderView = _topView;
    }
    self.tableView = tableView;
    [tableView registerClass:[WQfriendsTableViewCell class] forCellReuseIdentifier:cellID];
    [tableView registerNib:[UINib nibWithNibName:@"WQnewFriendsTableViewCell" bundle:nil] forCellReuseIdentifier:newFriendsCellid];
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //自动布局
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(_seachBar.mas_bottom);
    }];
    
    tableView.tableFooterView = [UIView new];
    tableView.dataSource = self;
    tableView.delegate = self;
    //tableView.sectionIndexBackgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _mainTable = tableView;
    
    loadingView = [[WQLoadingView alloc] init];
    [loadingView show];
    [self.view addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    __weak typeof(loadingView) weakLoadingView = loadingView;
    loadingError = [[WQLoadingError alloc] init];
    [loadingError setClickRetryBtnClickBlock:^{
        [weakLoadingView show];
        [weakSelf requestData];
    }];
    [loadingError dismiss];
    [self.view addSubview:loadingError];
    [loadingError mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.left.right.bottom.equalTo(self.view);
    }];
}

/**
 获取到通讯录授权后后处理获得的数据
 */
- (void)onGetAddressBookInfo {
    //获取通讯录对象
    ABAddressBookRef addressbook = ABAddressBookCreateWithOptions(NULL, NULL);
    //获取通讯录内容
    CFArrayRef peopleArray = ABAddressBookCopyArrayOfAllPeople(addressbook);
    //获取通讯录的个数
    CFIndex count = CFArrayGetCount(peopleArray);
    
    //遍历通讯录内容
    for (CFIndex i = 0; i < count; i++) {
//        [CNContactStore
        NSMutableDictionary *contactDict = [NSMutableDictionary dictionary];
        
        //获取单个通讯录内容 --> 获取单个联系人的信息
        ABRecordRef person = CFArrayGetValueAtIndex(peopleArray, i);
        //根据Person获取姓名和电话 --> 代码可以参考有界面通讯录的写法
        //获取姓名
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        //NSLog(@"firstName: %@, lastName:%@", firstName, lastName);
        
        NSString *contactName = [lastName ?:@"" stringByAppendingString:firstName ?:@""];
        
        //获取电话
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(phone);
        if (phoneCount > 0) {
            contactDict[@"name"] = contactName;
            
            NSString * num  = (NSString *) CFBridgingRelease(ABMultiValueCopyValueAtIndex(phone, 0));
            num = [[num componentsSeparatedByString:@"-"] componentsJoinedByString:@""];
            contactDict[@"phone"] = num;
            [self.contactArrayM addObject:contactDict];
        }
        //释放CF对象
        CFRelease(phone);
    }
    //释放CF对象
    CFRelease(peopleArray);
    CFRelease(addressbook);
    
    [self uploadContact];
}

#pragma mark - 上传通讯录
- (void)uploadContact {
    NSString *urlString = @"api/contact/add";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.uploadContactParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    NSData *arrAydata = [NSJSONSerialization dataWithJSONObject:self.contactArrayM options:NSJSONWritingPrettyPrinted error:nil];
    NSString *idcardStr = [[NSString alloc] initWithData:arrAydata encoding:NSUTF8StringEncoding];
    _uploadContactParams[@"contacts"] = idcardStr;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost
                               urlString:urlString
                              parameters:_uploadContactParams
                              completion:^(id response, NSError *error) {
                                  if (error) {
                                      NSLog(@"%@",error);
                                      return ;
                                  }
                                  if ([response isKindOfClass:[NSData class]]) {
                                      response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
                                  }
                                  NSLog(@"%@",response);
                                  if ([response[@"success"] boolValue]) {
                                      //获取通讯录上传服务器成功
                                  }
                              }];
}

- (void)fetchDot {
    NSString * strURL = @"api/message/reddot";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSDictionary * param = @{@"secretkey":secreteKey};
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    NSURLSessionDataTask * task =  [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            return ;
        }
        
        
        //        ecode = 0;
        //        好友申请
        //        "friendapply_count" = 0;
        //        消息
        //        message = 0;
        //        入群申请
        //        "message_applyjoingroup" = 0;
        //        评论
        //        "message_comment" = 0;
        //        赞
        //        "message_like" = 0;
        //        系统消息
        //        "message_sys" = 0;
        //        "my_bidded_need_bidded_doing_count" = 0;
        //        "my_bidded_need_bidded_finished_count" = 1;
        //        "my_bidded_need_bidding_count" = 0;
        //        "my_bidded_need_total_count" = 1;
        //        "my_count" = 1;
        //        "my_created_need_bidded_count" = 0;
        //        "my_created_need_bidding_count" = 0;
        //        "my_created_need_finished_count" = 0;
        //        "my_created_need_total_count" = 0;
        //        success = 1;
        
        
        
        
        
        ROOT(root);
        
        if (root) {
            if ([response[@"my_bidded_need_bidded_doing_count"] boolValue]||
                [response[@"my_bidded_need_bidding_count"] boolValue]||
                [response[@"my_created_need_bidded_count"] boolValue]||
                [response[@"my_created_need_bidding_count"] boolValue]) {
                root.haveBidInfoToDealWith = YES;
            } else {
                root.haveBidInfoToDealWith = NO;
            }
            
            
            
            root.haveFriendapply = [response[@"friendapply_count"] boolValue];
            
            root.haveSystemInfoToDealWith = [response[@"message_sys"] boolValue];
            
            root.haveGroupApply  = [response[@"message_applyjoingroup"] boolValue];
            
            root.haveCommentInfoToDealWith = [response[@"message_comment"] boolValue];
            
            root.haveMessageInfoToDealWith = [response[@"message"] boolValue];
            
            root.haveLikeTodealWith = [response[@"message_like"] boolValue];
            
            root.haveCircleEvent = [response[@"message_applyjoingroup"]boolValue]||[response[@"message_comment"]boolValue]||[response[@"message_like"]boolValue];
            if (root.haveFriendapply) {
                [_topView showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
                
            } else {
                [_topView clearBadge];
            }
        }
    }];
    
}
#pragma mark - TableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WQfriendsTableViewCell *friendscell = [tableView cellForRowAtIndexPath:indexPath];
    WQUserProfileController *userProfileVc = [[WQUserProfileController alloc]initWithUserId:friendscell.model.user_id];
    userProfileVc.fromFriendList = YES;
    [self.navigationController pushViewController:userProfileVc animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_seachBar.text.length) {
        return 1;
    }
    return self.modelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_seachBar.text.length) {
        return _filterData.count;
    }
    
    WQfriendsModel *model = self.modelArray[section];
    return model.friend_list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    WQfriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    WQfriendsModel *model = self.modelArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_seachBar.text.length) {
        
        cell.model = _filterData[indexPath.row];
    } else {
        
        cell.model = model.friend_list[indexPath.row];
    }
    return cell;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (_seachBar.text.length) {
        return nil;
    }
    NSMutableArray * titles = @[].mutableCopy;
    for (WQfriendsModel * model in self.modelArray) {
        [titles addObject:model.first_spell];
    }
    return titles;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    WQfriendsModel *model = self.modelArray[section];
    return model.first_spell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView * view = [UITableViewHeaderFooterView new];
    view.textLabel.font = [UIFont systemFontOfSize:15];
    view.textLabel.textColor = HEX(0x999999);
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_seachBar.text.length) {
        return 0;
    } else {
        return 25;
    }
}


#pragma mark - UISearchBarDelegate


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!searchText.length) {
        [searchBar resignFirstResponder];
        [_mainTable reloadData];
        return;
    }
    if (_filterData) {
        [_filterData removeAllObjects];
    }
    NSString *filterString = searchText;
    
    for (WQfriendsModel * friendsModel in self.modelArray) {
        
        for (WQfriend_listModel * model in friendsModel.friend_list) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", filterString];
            
            if  ([predicate evaluateWithObject: model.true_name ]) {
                
                if (!_filterData) {
                    _filterData = @[].mutableCopy;
                }
                [_filterData addObject:model];
            }
        }
    }
    [_mainTable reloadData];

}


- (void)fetchVerifyStatus {
    [WQDataSource sharedTool].secretkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    NSString *urlString = @"api/user/getbasicinfo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
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
            [WQDataSource sharedTool].loginStatus = response[@"idcard_status"];
        }
    }];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
-(NSArray *)friendsArray
{
    if (!_friendsArray) {
        _friendsArray = [[NSArray alloc]init];
    }
    return _friendsArray;
}
- (NSMutableDictionary *)uploadContactParams
{
    if(!_uploadContactParams)
    {
        _uploadContactParams = [[NSMutableDictionary alloc]init];
    }
    return _uploadContactParams;
}
- (NSMutableArray *)contactArrayM
{
    if (!_contactArrayM) {
        _contactArrayM = [[NSMutableArray alloc]init];
    }
    return _contactArrayM;
}
- (NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc]init];
    }
    return _modelArray;
}

- (NSMutableDictionary *)aFriendParams
{
    if (!_aFriendParams) {
        _aFriendParams = [[NSMutableDictionary alloc] init];
    }
    return _aFriendParams;
}
@end
