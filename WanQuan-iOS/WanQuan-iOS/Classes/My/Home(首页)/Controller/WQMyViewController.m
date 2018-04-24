//
//  WQMyViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/10/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQMyViewController.h"
#import "WQHeadTableViewController.h"
#import "WQFriendsViewController.h"
#import "WQMyHometwoTableViewCell.h"
#import "WQMyHomeModel.h"
#import "WQlineOfCreditViewController.h"
#import "WQMyOrderViewController.h"
#import "WQMyReceivinganOrderViewController.h"
#import "WQMyWalletViewController.h"
#import "WQMySetupViewController.h"
#import "WQindividualViewController.h"
#import "WQUserProfileModel.h"
#import "WQLearningexperienceViewController.h"
#import "WQTouristView.h"
#import "EaseConversationListViewController.h"
#import "WQMyHomeHeaderView.h"
#import "WQhelpViewController.h"
#import "WQUserProfileController.h"
#import "WQTemporaryInquiryController.h"
#import "WQTabBarController.h"
#import "WQMyHomeVisitorsLoginView.h"
#import "WQLoginPopupWindow.h"
#import "WQLogInController.h"
#import "WQRegisteredViewController.h"
#import "WQFocusOnCollectViewController.h"


#import "WQMyCollectionController.h"

static NSString *Homewcellid = @"Homewcellid";

@interface WQMyViewController () <WQLoginPopupWindowDelegate>

@property (nonatomic, strong) WQMyHomeModel *myModel;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) WQUserProfileModel *userModel;
@property (nonatomic, strong) NSArray *titleOncArray;
@property (nonatomic, strong) NSArray *titleTwoArray;
@property (nonatomic, strong) NSArray *titleThreeArray;
@property (nonatomic, strong) WQMyHomeHeaderView *myHomeHeaderView;
@property (nonatomic, strong) WQLoginPopupWindow *loginPopupWindow;


@property (nonatomic, assign) BOOL havePostedToDealWith;

@property (nonatomic, assign) BOOL haveAcceptedToDealWith;

@end

@implementation WQMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xededed];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        //初始化游客登录UI
        [self setupTouristUI];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:WQpic_truename object:nil];
        [self setupUI];
        [self loadData];
        self.titleOncArray = @[@"信用额度",@"钱包",@"我的好友"];
        self.titleTwoArray = @[@"我发的订单",@"我接的订单",@"我询问的订单"];
        self.titleThreeArray = @[@"帮助",@"设置"];
    }
//    self.tabBarController.delegate = self;
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    [self.tableview reloadData];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self preferredStatusBarStyle]
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationItem.title = @"我的";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_tableview) {
        [self loadData];
    }
}

#pragma make - 初始化UI
- (void)setupTouristUI {
    // WQTouristView *touristView = [[WQTouristView alloc]init];
    WQMyHomeVisitorsLoginView *myHomeVisitorsLoginView = [[WQMyHomeVisitorsLoginView alloc] init];
    [self.view addSubview:myHomeVisitorsLoginView];
    
    [myHomeVisitorsLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    WQLoginPopupWindow *loginPopupWindow = [[WQLoginPopupWindow alloc] init];
    loginPopupWindow.delegate = self;
    self.loginPopupWindow = loginPopupWindow;
    loginPopupWindow.hidden = YES;
    [self.view addSubview:loginPopupWindow];
    [loginPopupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [myHomeVisitorsLoginView setLoginBtnClickBlock:^{
//        self.tabBarController.tabBar.hidden = YES;
//        loginPopupWindow.hidden = NO;
//        [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.left.right.equalTo(loginPopupWindow);
//            make.height.offset(280);
//        }];
//        
//        [UIView animateWithDuration:0.25 animations:^{
//            [loginPopupWindow layoutIfNeeded];
//        }];
        WQLogInController *vc = [[WQLogInController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark -- WQLoginPopupWindowDelegate
- (void)wqLoginBtnClick:(WQLoginPopupWindow *)loginPopupWindow {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
    WQLogInController *vc = [[WQLogInController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)wqRegisteredBtnClick:(WQLoginPopupWindow *)loginPopupWindow {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
    WQRegisteredViewController *vc = [[WQRegisteredViewController alloc] init];
    vc.isLogin = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)wqTranslucentAreaClick:(WQLoginPopupWindow *)loginPopupWindow {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
}

- (void)setupUI
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    
    
    
    
    
    [tableView registerNib:[UINib nibWithNibName:@"WQMyHometwoTableViewCell" bundle:nil] forCellReuseIdentifier:Homewcellid];
    //取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithHex:0xededed];
    
    WQMyHomeHeaderView *myHomeHeaderView = [[WQMyHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
    self.myHomeHeaderView = myHomeHeaderView;
    tableView.tableHeaderView = myHomeHeaderView;
    [myHomeHeaderView setMyHomeHeaderbtnClikeBlock:^{
        
        WQUserProfileController*individualVc = [WQUserProfileController new];

        [self.navigationController pushViewController:individualVc animated:YES];
    }];
    
    [self.view addSubview:tableView];
    
    //自动布局
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.top.equalTo(self.view).offset(64);
    }];
    
    
    
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableview = tableView;
    

    
}

- (void)loadData
{
    NSString *urlString = @"api/user/getbasicinfo";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    
//    [SVProgressHUD showWithStatus:@"正在加载"];
    [tools request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD showWithStatus:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1];
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }
        
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
        }
        
        [SVProgressHUD showWithStatus:@""];
        [SVProgressHUD dismissWithDelay:0.1];
        self.userModel = [WQUserProfileModel yy_modelWithJSON:response];
        self.myHomeHeaderView.userName.text = self.userModel.true_name;
        //NSString *imageUrl = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",self.userModel.pic_truename]];
        [self.myHomeHeaderView.avatarImage yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(self.userModel.pic_truename)] options:YYWebImageOptionProgressive];
        self.myHomeHeaderView.tagoncLabel.text = [NSString stringWithFormat:@"%@",self.userModel.tag.firstObject?self.userModel.tag.firstObject:@""];
        
//        STATUS_UNVERIFY=未实名认证；
//        STATUS_VERIFIED=已实名认证；
//        STATUS_VERIFING=已提交认证正在等待管理员审批

        if ([self.userModel.idcard_status isEqualToString:@"STATUS_UNVERIFY"]) {
            _myHomeHeaderView.flagImageView.image = [UIImage imageNamed:@"woyaoshimingrenzheng"];
        }
        if ([self.userModel.idcard_status isEqualToString:@"STATUS_VERIFING"]) {
            _myHomeHeaderView.flagImageView.image = [UIImage imageNamed:@"dengdaihoutaishenhe"];
        }
        if ([self.userModel.idcard_status isEqualToString:@"STATUS_VERIFIED"]) {
            _myHomeHeaderView.flagImageView.image = [UIImage imageNamed:@"rightArrow"];
            [_myHomeHeaderView.flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_myHomeHeaderView.mas_right).offset(-15);
                make.centerY.equalTo(_myHomeHeaderView.mas_centerY);
            }];
        }
        
        [self updateBidStatus];
    }];
}



- (void)updateBidStatus {
    NSString * strURL = @"api/message/reddot";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSDictionary * param = @{@"secretkey":secreteKey};
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            return ;
        }
        WQTabBarController * root = (WQTabBarController *)[[UIApplication sharedApplication].delegate.window rootViewController];
        
        if (root) {
            if ([response[@"my_count"] boolValue]) {
                root.haveBidInfoToDealWith = YES;
            } else {
                root.haveBidInfoToDealWith = NO;
            }
            
            
//            my_bidded_need_total_count
//            my_created_need_total_count
            
            
            self.haveAcceptedToDealWith = [response[@"my_bidded_need_bidded_doing_count"] boolValue]||
            [response[@"my_bidded_need_bidding_count"] boolValue];
            
            self.havePostedToDealWith =  [response[@"my_created_need_bidded_count"] boolValue]||
            [response[@"my_created_need_bidding_count"] boolValue];
            
            
            root.haveFriendapply = [response[@"friendapply_count"] boolValue];
            
            
            root.haveBidInfoToDealWith = self.haveAcceptedToDealWith ||  self.havePostedToDealWith;
            [[NSNotificationCenter defaultCenter] postNotificationName:WQShouldHideRedNotifacation object:nil];
            
            [_tableview reloadData];
        }
    }];
}

#pragma make - TableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                
                if (![WQDataSource sharedTool].isVerified) {
                    // 快速注册的用户
                    UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                                             message:@"请实名认证后,获得个人信用额度"
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                                           style:UIAlertActionStyleCancel
                                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                             NSLog(@"取消");
                                                                         }];
                    UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"实名认证"
                                                                                style:UIAlertActionStyleDestructive
                                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                                  WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:[WQDataSource sharedTool].userIdString];

                                                                                  [self.navigationController pushViewController:vc animated:YES];
                                                                              }];
                    [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
                    [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
                    
                    [alertController addAction:cancelButton];
                    [alertController addAction:destructiveButton];
                    [self presentViewController:alertController animated:YES completion:nil];
                    return;
                }
                
                WQlineOfCreditViewController *lineOfCreditVc = [WQlineOfCreditViewController new];
                [self.navigationController pushViewController:lineOfCreditVc animated:YES];
            }else if (indexPath.row == 1){
                WQMyWalletViewController *myWalletVc = [WQMyWalletViewController new];
                [self.navigationController pushViewController:myWalletVc animated:YES];
            }else{
                WQFriendsViewController *friendsVc = [WQFriendsViewController new];
                friendsVc.isNewFriends = YES;
                [self.navigationController pushViewController:friendsVc animated:YES];
            }
        }
            break;
        case 1:{
            if (indexPath.row == 0) {
                WQMyOrderViewController *myOrderVc = [WQMyOrderViewController new];
                [self.navigationController pushViewController:myOrderVc animated:YES];
            }
            if (indexPath.row == 1) {
                WQMyReceivinganOrderViewController *myReceivinganOrderVc = [WQMyReceivinganOrderViewController new];
                [self.navigationController pushViewController:myReceivinganOrderVc animated:YES];
            }
            if (indexPath.row == 2) {
                WQTemporaryInquiryController *vc = [WQTemporaryInquiryController new];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            
        }
            break;
        case 2:{
            if (indexPath.row == 0) {
                WQhelpViewController *vc = [[WQhelpViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                WQMySetupViewController *mySetupVc = [[WQMySetupViewController alloc]init];
                [self.navigationController pushViewController:mySetupVc animated:YES];
            }
        }
            break;
        
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0 || section == 1 || section == 2) {
        return 20;
    }else{
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.layer.borderWidth = 0.5f;
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [UIColor colorWithHex:0xcbcbcb].CGColor;
    view.backgroundColor = [UIColor colorWithHex:0xededed];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        view.layer.borderWidth = 0.5f;
        view.layer.masksToBounds = YES;
        view.layer.borderColor = [UIColor colorWithHex:0xcbcbcb].CGColor;
        view.backgroundColor = [UIColor colorWithHex:0xededed];
        return view;
    }
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return self.titleOncArray.count;
    }else if (section == 1){
        return self.titleTwoArray.count;
    }else if (section == 2){
        return self.titleThreeArray.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WQMyHometwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Homewcellid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.myName.text = self.titleOncArray[indexPath.row];
        NSArray *picName = @[@"xinyongedu",@"qianbao",@"wodehaoyou"];
        cell.titleImage.image = [UIImage imageNamed:picName[indexPath.row]];
        if (indexPath.row == 2) {
//            cell.lineView.hidden = YES;
            cell.redDotView.hidden = ![WQContactManager haveUnacceptedFriendRequest];
        }
        
        
        
    }else if(indexPath.section == 1){
        cell.myName.text = self.titleTwoArray[indexPath.row];
        NSArray *picName = @[@"wofadedingdan",@"wojiededingdan",@"xunwendingdan"];
        cell.titleImage.image = [UIImage imageNamed:picName[indexPath.row]];
        if (indexPath.row) {
//            cell.lineView.hidden = YES;
        }
        
        
        
        
        BOOL redDotBool = [WQUnreadMessageCenter MYBILL_haveUnreadBidChatWithMyId:[[NSUserDefaults standardUserDefaults] objectForKey:@"im_namelogin"]]|| self.havePostedToDealWith;
        
        BOOL redDotBooltwo = [WQUnreadMessageCenter OTHERSBILL_haveUnreadBidingChatWithMyId:[[NSUserDefaults standardUserDefaults] objectForKey:@"im_namelogin"]] || self.haveAcceptedToDealWith;
        
        BOOL haveUnreadTemp = [WQUnreadMessageCenter haveUnreadTemChatITalkedTo];
        if (indexPath.row == 0) {
            if (redDotBool) {
                cell.redDotView.hidden = NO;
            }else{
                cell.redDotView.hidden = YES;
            }
        }
        if (indexPath.row == 1) {
            if (redDotBooltwo) {
                cell.redDotView.hidden = NO;
            }else{
                cell.redDotView.hidden = YES;
            }
        }
        if (indexPath.row == 2) {
            cell.redDotView.hidden = !haveUnreadTemp;
        }
        
    }else{
        NSArray *picName = @[@"bangzhu",@"shezhi"];
        cell.titleImage.image = [UIImage imageNamed:picName[indexPath.row]];
        cell.myName.text = self.titleThreeArray[indexPath.row];
        if (indexPath.row == 1) {
//            cell.lineView.hidden = YES;
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
            [cell.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0.5);
                make.left.bottom.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView).offset(100);
            }];
        }
    }
    return cell;
}

#pragma make - 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}

#pragma make - 移除通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end
