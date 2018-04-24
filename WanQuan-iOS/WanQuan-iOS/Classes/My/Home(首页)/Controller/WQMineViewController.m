//
//  WQMineViewController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/16.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQMineViewController.h"
#import "WQMyUserInfoCell.h"
#import "WQUserTreasureCell.h"
#import "WQBidNavCell.h"
#import "WQMyBidInfoCell.h"
#import "WQMyAllBidsCell.h"
#import "WQMyHometwoTableViewCell.h"

#import "WQUserProfileModel.h"

#import "WQUserProfileController.h"
#import "WQhelpViewController.h"
#import "WQMySetupViewController.h"
#import "WQLogInController.h"

#import "WQlineOfCreditViewController.h"
#import "WQMyWalletViewController.h"
#import "WQFriendsViewController.h"

#import "WQMyOrderViewController.h"
#import "WQMyReceivinganOrderViewController.h"
#import "WQTemporaryInquiryController.h"

#import "WQMyCollectionController.h"
#import "WQFocusOnCollectViewController.h"


#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface WQMineViewController ()<UITableViewDelegate,UITableViewDataSource,WQBidNavCellDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, retain) UITableView * mainTable;
@property (nonatomic, retain) WQUserProfileModel * userModel;


@property (nonatomic, assign) BOOL havePostedToDealWith;
@property (nonatomic, assign) BOOL haveAcceptedToDealWith;




/**
 选中的订单的类型
 0 我发的订单
 1 我接的订单
 2 我询问的订单
 */
@property (nonatomic, assign) NSInteger selectedBidIndex;

@end

@implementation WQMineViewController


#pragma mark - lifeCircle;
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * lab = [[UILabel alloc] init];
    lab.text = @"我的";
    lab.font = [UIFont systemFontOfSize:20];
    lab.textColor = [UIColor blackColor];
    [lab sizeToFit];
    self.navigationItem.titleView = lab;
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:WQpic_truename object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:WQ_SHADOW_IMAGE];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self loadData];
}


#pragma mark - UI
- (void)setupUI {
    self.view.backgroundColor = WQ_BG_LIGHT_GRAY;
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, kScreenWidth, kScreenHeight - NAV_HEIGHT - 49) style:UITableViewStyleGrouped];
    [self.view addSubview:_mainTable];
    _mainTable.backgroundColor = WQ_BG_LIGHT_GRAY;
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.emptyDataSetSource = self;
    _mainTable.emptyDataSetDelegate = self;
    _mainTable.showsVerticalScrollIndicator = NO;
    _mainTable.estimatedSectionFooterHeight = 0;
    _mainTable.estimatedSectionHeaderHeight = 0;
    [_mainTable registerNib:[UINib nibWithNibName:@"WQMyUserInfoCell" bundle:nil] forCellReuseIdentifier:@"WQMyUserInfoCell"];
    [_mainTable registerNib:[UINib nibWithNibName:@"WQMyBidInfoCell" bundle:nil] forCellReuseIdentifier:@"WQMyBidInfoCell"];
    [_mainTable registerNib:[UINib nibWithNibName:@"WQMyAllBidsCell" bundle:nil] forCellReuseIdentifier:@"WQMyAllBidsCell"];
    [_mainTable registerNib:[UINib nibWithNibName:@"WQMyHometwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"Homewcellid"];
}

#pragma  mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSString *role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]){
        return 0;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    个人信息
    if (section == 0) {
        
        return 1;
    }
    //    我的钱包我的信用我的好友
    if (section == 1) {
        return 1;
    }
    //    我的订单
    if (section == 2) {
        return 2;
    }
    
    if (section == 3) {
        return 1;
    }
    
    //    帮助设置
    if (section == 4) {
        return 2;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        WQMyUserInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQMyUserInfoCell"];
        
        if (self.userModel) {
            cell.model = self.userModel;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 1) {
        WQUserTreasureCell * cell = [[WQUserTreasureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WQUserTreasureCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.qianbaoyueeLabel.text = [_userModel.balance
                                  stringByAppendingString:@"元"];
        cell.haoyouLabel.text = [NSString stringWithFormat:@"%d个",_userModel.friendCount];
        cell.xinyongfenLabel.text = [NSString stringWithFormat:@"%.0f分",_userModel.credit_score];
        
        [cell showFriendBadge];
        
        cell.creditOnclick = ^{
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
                                                                            style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                                              WQUserProfileController *vc = [[WQUserProfileController alloc] init];
                                                                              
                                                                              vc.userId = [WQDataSource sharedTool].userIdString;
                                                                              //                                                                              vc.ismyaccount = YES;
                                                                              //                                                                              vc.userProfileType = UserProfileTypeEdit;
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
        };
        cell.purseOnclick = ^{
            WQMyWalletViewController *myWalletVc = [WQMyWalletViewController new];
            [self.navigationController pushViewController:myWalletVc animated:YES];
        };
        
        cell.friendOnclick = ^{
            WQFriendsViewController *friendsVc = [WQFriendsViewController new];
            friendsVc.isNewFriends = YES;
            [self.navigationController pushViewController:friendsVc animated:YES];
        };
        
        return cell;
    }
    
    if (indexPath.section == 2) {
        
        NSArray *picName = @[@"wofadedingdan",@"wojiededingdan",@"xunwendingdan"];
        NSArray * titles = @[@"我发的需求",@"我接的需求"];
        WQMyHometwoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Homewcellid"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleImage.image = [UIImage imageNamed:picName[indexPath.row]];
        cell.myName.text = titles[indexPath.row];
        
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
        
        
        return cell;
    }
    
    if (indexPath.section == 3) {
        WQMyHometwoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Homewcellid"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleImage.image = [UIImage imageNamed:@"woshoucangdewenzhang"];
        cell.myName.text = @"关注、收藏";
        return cell;
    }
    
    if (indexPath.section == 4) {
        
        NSArray *picName = @[@"bangzhu",@"shezhi"];
        NSArray * titles = @[@"帮助",@"设置"];
        WQMyHometwoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Homewcellid"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleImage.image = [UIImage imageNamed:picName[indexPath.row]];
        cell.myName.text = titles[indexPath.row];
        return cell;
    }
    
    return [UITableViewCell new];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 85;
    }
    if (indexPath.section == 1) {
        return 136;
    }
    
    if (indexPath.section == 2) {
        return 45;
    }
    //    if (indexPath.section == 2) {
    //        return 44;
    //    }
    //    if (indexPath.section == 3) {
    //        return 55;
    //    }
    if (indexPath.section == 3) {
        return 45;
    }
    
    if (indexPath.section == 4) {
        return 45;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //    帮助设置
    if (section == 4) {
        return 40;
    }
    
    return .1;
}

/**
 SELECT_TABLE
 
 @param tableView tableView
 @param indexPath indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    //    用户信息
    if (indexPath.section == 0) {
        
        WQUserProfileController*vc = [WQUserProfileController new];
        //        individualVc.ismyaccount = YES;
        //        individualVc.userProfileType = UserProfileTypeEdit;
        vc.selfEditing = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
//    订单
    if (indexPath.section == 2) {

        if (indexPath.row == 0) {
            WQMyOrderViewController *myOrderVc = [WQMyOrderViewController new];
            [self.navigationController pushViewController:myOrderVc animated:YES];
        }
        if (indexPath.row == 1) {
            WQMyReceivinganOrderViewController *myReceivinganOrderVc = [WQMyReceivinganOrderViewController new];
            [self.navigationController pushViewController:myReceivinganOrderVc animated:YES];
        }
//        if (indexPath.row == 2) {
//            WQTemporaryInquiryController *vc = [WQTemporaryInquiryController new];
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        }
        
    }
    // MARK: 收藏关注
    if (indexPath.section == 3) {
        //WQMyCollectionController * vc = [[WQMyCollectionController alloc] init];
        WQFocusOnCollectViewController *vc = [[WQFocusOnCollectViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 4) {
        //        帮助
        if (indexPath.row == 0) {
            WQhelpViewController *vc = [[WQhelpViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            //            设置
            WQMySetupViewController *mySetupVc = [[WQMySetupViewController alloc]init];
            [self.navigationController pushViewController:mySetupVc animated:YES];
        }
    }
    
    
}


#pragma mark - DZNEmpty

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    
}

/**
 Tells the delegate that the action button was tapped.
 
 @param scrollView A scrollView subclass informing the delegate.
 @param button the button tapped by the user
 */
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    UIViewController * vc;
    if ([role_id isEqualToString:@"200"]) {
        vc = [[WQLogInController alloc] init];
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}




/**
 Asks the data source for the description of the dataset.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 
 @param scrollView A scrollView subclass informing the data source.
 @return An attributed string for the dataset description text, combining font, text color, text pararaph style, etc.
 */
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableAttributedString * str  = [[NSMutableAttributedString alloc] init];
    NSDictionary * att = @{NSForegroundColorAttributeName:HEX(0x999999),
                           NSFontAttributeName:[UIFont systemFontOfSize:14],
                           NSParagraphStyleAttributeName:paragraphStyle};
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n你在万圈的痕迹保存在这里\n\n" attributes:att]];
    }
    [str setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],
                         NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, 1)];
    [str setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                         NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(str.length - 2, 2)];
    return str;
}

/**
 Asks the data source for the image of the dataset.
 
 @param scrollView A scrollView subclass informing the data source.
 @return An image for the dataset.
 */
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    UIImage * image;
    if ([role_id isEqualToString:@"200"]) {
        image = [UIImage imageNamed:@"youkengdengluwode"];
    }
    return image;
    
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSMutableAttributedString * str  = [[NSMutableAttributedString alloc] init];
    NSDictionary * att = @{NSForegroundColorAttributeName:HEX(0x5d2a89),
                           NSFontAttributeName:[UIFont systemFontOfSize:15]};
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:att]];
    }
    return str;
}



- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {

    UIImage * str ;
    //    NSDictionary * att = @{NSForegroundColorAttributeName:HEX(0x5d2a89),
    //                           NSFontAttributeName:[UIFont systemFontOfSize:15]};
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        str = [UIImage imageNamed:@"立即登录"];
    }
    
    return  str;
    
}
/**
 Asks the data source for the background color of the dataset. Default is clear color.
 
 @param scrollView A scrollView subclass object informing the data source.
 @return A color to be applied to the dataset background view.
 */
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return HEX(0xf3f3f3);
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return -5;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -37;
}

#pragma mark - http
- (void)loadData {
    NSString *urlString = @"api/user/getbasicinfo";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * params =@{}.mutableCopy;
    params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    
    //    [SVProgressHUD showWithStatus:@"正在加载"];
    [tools request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
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
        if (![response[@"success"] boolValue]) {
            return;
        }
        _userModel = [WQUserProfileModel yy_modelWithJSON:response];
        
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
        ROOT(root);
        
        if (root) {
            if ([response[@"my_count"] boolValue]) {
                root.haveBidInfoToDealWith = YES;
            } else {
                root.haveBidInfoToDealWith = NO;
            }
            
            self.haveAcceptedToDealWith = [response[@"my_bidded_need_bidded_doing_count"] boolValue]||
            [response[@"my_bidded_need_bidding_count"] boolValue];
            
            self.havePostedToDealWith =  [response[@"my_created_need_bidded_count"] boolValue]||
            [response[@"my_created_need_bidding_count"] boolValue];
            root.haveFriendapply = [response[@"friendapply_count"] boolValue];
            root.haveBidInfoToDealWith = self.haveAcceptedToDealWith || self.havePostedToDealWith;
            [[NSNotificationCenter defaultCenter] postNotificationName:WQShouldHideRedNotifacation object:nil];
            [_mainTable reloadData];
            
        }
    }];
}

#pragma mark - WQBidNavCellDelegaet

- (void)bidNavCellDelegateSelectAt:(NSInteger)i {
    
    UITableViewRowAnimation anima = UITableViewRowAnimationAutomatic;
    _selectedBidIndex = i;
    [_mainTable reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:anima];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
