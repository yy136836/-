//
//  WQGroupDemandForDetailsViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupDemandForDetailsViewController.h"
#import "WQorderDetailsTableViewCell.h"
#import "WQorderHeadView.h"
#import "WQHomeNearby.h"
#import "WQICanHelpTableViewCell.h"
#import "WQCommentsView.h"
#import "WQTopicCommentCell.h"
#import "WQTextField.h"
#import "WQCommentDetailController.h"
#import "WQCommentTextView.h"
#import "WQChaViewController.h"
//#import "WQChaViewController.h"
#import "WQSharMenuView.h"
#import "UMSocialUIManager.h"
#import "UMSocialSinaHandler.h"
#import "WQGroupChooseSharGroupViewController.h"

#import "WQGroupBidModel.h"
#import "WQAlreadyReceiveView.h"
#import "WQTopicDetailFooter.h"
#import "WQUserProfileController.h"
#import "WQGroupDemandForDetailsSharView.h"


#import "WQActionSheet.h"

static NSString *identifier = @"identifier";
static NSString *identifierTwo = @"identifierTwo";
static NSString *commentsIdentifier = @"WQTopicCommentCell";

@interface WQGroupDemandForDetailsViewController () <UITableViewDelegate, UITableViewDataSource,WQCommentsViewDelegate,WQTopicCommentCellDelegate,WQICanHelpTableViewCellDelegate,WQSharMenuViewDelegate,WQorderDetailsTableViewCellDelegate,WQAlreadyReceiveViewDelegate,UIGestureRecognizerDelegate,WQGroupDemandForDetailsSharViewDelegate,WQActionSheetDelegate>

@property (nonatomic, strong) NSDictionary *response;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WQorderHeadView *orderHeadView;
@property (nonatomic, strong) WQHomeNearby *model;
// 评论的输入框
@property (nonatomic, strong) WQCommentsView *commentsView;
// 添加分享菜单默认隐藏
@property (nonatomic, strong) WQSharMenuView *sharMenuView;
@property (nonatomic, strong) WQAlreadyReceiveView *alreadyReceiveView;
@property (nonatomic, strong) NSArray *commentsListArray;

@property (nonatomic, retain) WQGroupBidModel * bidModel;
@property (nonatomic, strong) WQGroupDemandForDetailsSharView *detailsSharView;
@property (nonatomic, strong) WQorderDetailsTableViewCell *orderDetailsTableViewCell;

/**
 cell 的 index
 */
@property (nonatomic, strong) NSIndexPath *index;

@end

@implementation WQGroupDemandForDetailsViewController {
    NSMutableArray *commentArray;
    NSString *moneyString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    commentArray = [NSMutableArray array];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"加载中…请稍候"];
    [self loadData];
    [self setupTableView];
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCommentsData) name:WQCommentSuccess object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithHex:0xededed];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationItem.title = @"需求详情";
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *sharBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenxiangqunmingpian"] style:UIBarButtonItemStylePlain target:self action:@selector(wqSharBtnCliek)];
    UIBarButtonItem *menuBarViewBtn = [[UIBarButtonItem alloc]initWithTitle:@"∙∙∙" style:UIBarButtonItemStylePlain target:self action:@selector(menuBarViewBtnClick)];
    [menuBarViewBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    // 是否群主
    if (self.isGroupManager) {
        self.navigationItem.rightBarButtonItems = @[sharBtn,menuBarViewBtn];
    }else {
        self.navigationItem.rightBarButtonItem = sharBtn;
    }
    
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setupTableView
- (void)setupTableView {
    
    moneyString = [[NSString alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    WQorderHeadView *orderHeadView = [[WQorderHeadView alloc] initWithFrame:CGRectMake(0, 0, 0, 107) titleString:self.response[@"category_level_1"]];
    self.orderHeadView = orderHeadView;
    
    [orderHeadView setHeadPortraitBlock:^{
        
        if (![self.response[@"truename"] boolValue]) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"实名用户匿名状态" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return ;
        }
        
        if (![WQDataSource sharedTool].verified) {
            // 快速注册的用户
            UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                                     message:@"实名认证后可查看用户信息"
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
        
        if ([WQDataSource sharedTool].verified && ![self.response[@"user_idcard_status"] isEqualToString:@"STATUS_VERIFIED"]) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"非实名认证用户" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return ;
        }
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
        // 是当前账户
        if ([self.response[@"user_id"] isEqualToString:im_namelogin]) {
            WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:self.response[@"user_id"]];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:self.response[@"user_id"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    // 评论的输入框
    WQCommentsView *commentsView = [[WQCommentsView alloc] init];
    self.commentsView = commentsView;
    commentsView.delegate = self;
    [self.view addSubview:commentsView];
    [commentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    self.tableView = tableView;
    tableView.tableHeaderView = orderHeadView;
    // 设置代理对象
    tableView.delegate = self;
    tableView.dataSource = self;
    // 设置自动行高和预估行高
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 10000;
    // 取消分割线
    // tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 滑动取消键盘
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    // 注册cell
    [tableView registerClass:[WQorderDetailsTableViewCell class] forCellReuseIdentifier:identifier];
    [tableView registerClass:[WQICanHelpTableViewCell class] forCellReuseIdentifier:identifierTwo];
    // [tableView registerClass:[WQNeedToReplyTableViewCell class] forCellReuseIdentifier:commentsIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"WQTopicCommentCell" bundle:nil] forCellReuseIdentifier:commentsIdentifier];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(ghNavigationBarHeight);
        make.bottom.equalTo(commentsView.mas_top);
    }];
    
}

#pragma mark - 加载UI数据
- (void)loadData {
    NSString *urlString = @"api/need/getneedinfo";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.params[@"nid"] = self.needId;
    self.params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    self.params[@"geo_lat"] = @([WQLocationManager defaultLocationManager].currentLocation.coordinate.latitude).description;
    self.params[@"geo_lng"] = @([WQLocationManager defaultLocationManager].currentLocation.coordinate.longitude).description;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD showErrorWithStatus:@"请检查网络连接后重试"];
            [SVProgressHUD dismissWithDelay:1];
            return ;
        }
        
        if (![response isKindOfClass:[NSDictionary class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }
        
        if (![response[@"success"] boolValue]) {
            [SVProgressHUD showErrorWithStatus:response[@"message"]];
            [SVProgressHUD dismissWithDelay:1];
            return;
        }
        
        NSLog(@"%@",response);
        
        NSString *urlString = [imageUrlString stringByAppendingString:response[@"user_pic"]];
        [self.orderHeadView.headPortraitImageView yy_setImageWithURL:[NSURL URLWithString:urlString] placeholder:[UIImage imageWithColor:[UIColor lightGrayColor]] options:YYWebImageOptionProgressive progress:nil transform:nil completion:nil];
        self.orderHeadView.userNameLabel.text = response[@"user_name"];
        //self.orderHeadView.timeLabel.text = response[@"finished_date"];
        NSString *pointsString = [NSString stringWithFormat:@"%@",response[@"user_creditscore"]];
        NSString *friendsString = [NSString stringWithFormat:@"%@",response[@"user_degree"]];
        
        
        self.bidModel = [WQGroupBidModel yy_modelWithJSON:response];
        
        NSInteger time = [[NSString stringWithFormat:@"%@",response[@"left_secends"]] integerValue];
        if (time < 0) {
            self.orderHeadView.timeLabel.text = [NSString stringWithFormat:@"已完成"];
        }else if (time < 3600) {
            self.orderHeadView.timeLabel.text = [NSString stringWithFormat:@"%zd分钟到期",time / 60];
        }else if (time / (60 * 60 * 24) >= 1) {
            self.orderHeadView.timeLabel.text = [NSString stringWithFormat:@"%zd天到期",time / (60 * 60 * 24)];
        }else{
            self.orderHeadView.timeLabel.text = [NSString stringWithFormat:@"%zd小时到期",time / 3600];
        }
        
        NSString *role_id = [userDefaults objectForKey:@"role_id"];
        if ([role_id isEqualToString:@"200"]) {
            // 如果是游客登录不显示信用分和几度好友
            self.orderHeadView.creditImageView.image = [UIImage imageNamed:@""];
            self.orderHeadView.creditLabel.hidden = YES;
            self.orderHeadView.aFewDegreesBackgroundLabel.hidden = YES;
        }
        
        if (![role_id isEqualToString:@"200"] && ![[WQDataSource sharedTool].loginStatus isEqualToString:@"STATUS_UNVERIFY"]) {
            // 实名认证的用户
            self.orderHeadView.aFewDegreesBackgroundLabel.text = [[WQTool friendship:[friendsString integerValue]] stringByAppendingString:@" "];
            self.orderHeadView.creditLabel.text = [pointsString stringByAppendingString:@"分"];
        }

        if ([response[@"user_idcard_status"] isEqualToString:@"STATUS_UNVERIFY"]) {
            // 快速注册的用户只显示信用分不显示几度好友
            self.orderHeadView.aFewDegreesBackgroundLabel.hidden = YES;
            //self.orderHeadView.creditPointsLabel.text = [pointsString stringByAppendingString:@"分"];
            self.orderHeadView.creditLabel.hidden = YES;
            self.orderHeadView.creditImageView.image = [UIImage imageNamed:@""];
        }else {
            if ([role_id isEqualToString:@"200"]) {
                // 如果是游客登录不显示信用分和几度好友
                self.orderHeadView.creditImageView.image = [UIImage imageNamed:@""];
                self.orderHeadView.creditLabel.hidden = YES;
                self.orderHeadView.aFewDegreesBackgroundLabel.hidden = YES;
            }else{
                self.orderHeadView.aFewDegreesBackgroundLabel.hidden = NO;
                self.orderHeadView.creditLabel.text = [pointsString stringByAppendingString:@"分"];
                self.orderHeadView.creditLabel.hidden = NO;
            }
        }
        
        if (![WQDataSource sharedTool].verified && ![response[@"user_idcard_status"] isEqualToString:@"STATUS_VERIFIED"]) {
            self.orderHeadView.creditImageView.image = [UIImage imageNamed:@""];
            self.orderHeadView.creditLabel.hidden = YES;
            self.orderHeadView.aFewDegreesBackgroundLabel.hidden = YES;
        }
        
        NSInteger distance = [[NSString stringWithFormat:@"%zd",[response[@"distance"] integerValue]] integerValue];
        if (distance > 10000) {
            NSInteger kmPosition = distance / 1000;
            self.orderHeadView.distanceLabel.text = [[NSString stringWithFormat:@"%zd",kmPosition] stringByAppendingString:@"千米"];
        }else {
            self.orderHeadView.distanceLabel.text = [[NSString stringWithFormat:@"%zd",distance] stringByAppendingString:@"米"];
        }
        
        [SVProgressHUD dismissWithDelay:1];
        moneyString = [NSString stringWithFormat:@"%@",response[@"money"]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"¥"
                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                 NSForegroundColorAttributeName:[UIColor colorWithHex:0x5288d8]}]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",response[@"money"]]
                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],
                                                                                 NSForegroundColorAttributeName:[UIColor colorWithHex:0x5288d8]}]];
        self.orderHeadView.moneyLabel.attributedText = str;
        NSArray *user_tag = response[@"user_tag"];
        if ([response[@"truename"] boolValue]) {
            switch (user_tag.count) {
                case 1:{
                    self.orderHeadView.tagOncLabel.hidden = NO;
                    self.orderHeadView.tagOncLabel.text = user_tag.firstObject;
                    self.orderHeadView.tagTwoLabel.hidden = YES;
                }
                    break;
                case 2:{
                    self.orderHeadView.tagOncLabel.hidden = NO;
                    self.orderHeadView.tagTwoLabel.hidden = NO;
                    self.orderHeadView.tagOncLabel.text = user_tag.firstObject;
                    self.orderHeadView.tagTwoLabel.text = user_tag.lastObject;
                }
                    break;
                case 0:{
                    self.orderHeadView.tagOncLabel.hidden = YES;
                    self.orderHeadView.tagTwoLabel.hidden = YES;
                }
                    break;
                default:
                    break;
            }
        }else {
            self.orderHeadView.tagOncLabel.hidden = YES;
            self.orderHeadView.tagTwoLabel.hidden = YES;
        }
        
        // 如果是BBS
        if ([response[@"category_level_1"] isEqualToString:@"BBS"]) {
            
        }
        
        self.response = response;
        WQHomeNearby *model = [WQHomeNearby yy_modelWithJSON:response];
        self.model = model;
        
        //[self.tableView reloadData];
        [self loadCommentsData];
    }];
}

// 获取评论数据
- (void)loadCommentsData {
    NSString *urlString = @"api/group/groupneedpostlist";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"gnid"] = self.gnid;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        
        if ([response[@"success"] boolValue]) {
            self.commentsListArray = [NSArray yy_modelArrayWithClass:[WQCommentAndReplyModel class] json:response[@"posts"]];
            [self.tableView reloadData];
        }

        if (!self.commentsListArray.count) {
            WQTopicDetailFooter * footer = [[NSBundle mainBundle] loadNibNamed:@"WQTopicDetailFooter" owner:self options:nil].lastObject;
            footer.frame = CGRectMake(0, 0, kScreenWidth, 130);
            self.tableView.tableFooterView = footer;
            MJRefreshAutoGifFooter * refreshFooter = (MJRefreshAutoGifFooter * )self.tableView.mj_footer;
            [refreshFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
            [refreshFooter setBackgroundColor:HEX(0xf3f3f3)];
        } else {
            self.tableView.tableFooterView = [UIView new];
            MJRefreshAutoGifFooter * refreshFooter = (MJRefreshAutoGifFooter * )self.tableView.mj_footer;
            [refreshFooter setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
            refreshFooter.stateLabel.textColor = HEX(0x999999);
            refreshFooter.stateLabel.textAlignment = NSTextAlignmentCenter;
            // 设置字体
            refreshFooter.stateLabel.font = [UIFont systemFontOfSize:16];
            [refreshFooter setBackgroundColor:HEX(0xf3f3f3)];
        }
        
    }];
}

#pragma mark - 领取
- (void)wqToReceiveBtnClike:(WQorderDetailsTableViewCell *)orderDetailsTableViewCell {
    NSString *urlString = @"api/need/bidandfinishneed";
    NSMutableDictionary *toReceiveParams = [NSMutableDictionary dictionary];
    toReceiveParams[@"nid"] = self.needId;
    toReceiveParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    toReceiveParams[@"truename"] = @"true";
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:toReceiveParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        self.response = response;
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            [self loadData];
            self.alreadyReceiveView.hidden = NO;
            self.alreadyReceiveView.moneyString = moneyString;
        }else{
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",response[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
        orderDetailsTableViewCell.whetherOrNotToReceive = [response[@"success"] boolValue];
    }];
}

#pragma mark - WQCommentsViewDelegate
- (void)wqCommentsTextField:(WQCommentsView *)commentsView commentsContentString:(NSString *)commentsContent {
    NSString *urlString = @"api/group/creategroupneedpost";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"gnid"] = self.gnid;
    params[@"content"] = commentsContent;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        
        if ([response[@"success"] boolValue]) {
            [commentsView.commentsTextField resignFirstResponder];
            commentsView.commentsTextField.text = nil;
            [self loadCommentsData];
        }
    }];
}

- (void)WQTopicCommentCellD:(WQTopicCommentCell *)cell addCommentWithId:(NSString *)tid {
    WQCommentDetailController * vc = [[WQCommentDetailController alloc] init];
//    vc.model = cell.model;
    NSArray * second = cell.model.comments;
    vc.pid = cell.model.id;
    
    if (second.count) {
        vc.secondnaryComments = [NSArray yy_modelArrayWithClass:[WQGroupReplyModel class] json:second].mutableCopy;
    }
    vc.commenting = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- WQorderDetailsTableViewCellDelegate
- (void)wqdeleteBtnClike {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"删除中…"];
    NSString *urlString = @"api/group/deletegroupneed";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"gnid"] = self.gnid;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD showErrorWithStatus:@"请检查网络连接后重试"];
            [SVProgressHUD dismissWithDelay:1];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        
        if ([response[@"success"] boolValue]) {
            [SVProgressHUD dismissWithDelay:0.2];
            if (self.needsDeleteSuccessfulBlock) {
                self.needsDeleteSuccessfulBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [SVProgressHUD showErrorWithStatus:@"请检查网络连接后重试"];
            [SVProgressHUD dismissWithDelay:1];
        }
    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([self.response[@"category_level_1"] isEqualToString:@"BBS"]) {
            return 1;
        }else {
            return 2;
        }
    }else {
        if (self.commentsListArray.count <= 0) {
            // 取消分割线
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }else {
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        return self.commentsListArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([self.response[@"category_level_1"] isEqualToString:@"BBS"]) {
            WQorderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            self.orderDetailsTableViewCell = cell;
            cell.model = self.model;
            cell.delegate = self;
            cell.isGroup = YES;
            cell.isYourOwn = NO;
            cell.isGroupManager = self.isGroupManager;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        if (indexPath.row == 0) {
            WQorderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.model = self.model;
            cell.delegate = self;
            cell.isGroupManager = self.isGroupManager;
            cell.isGroup = YES;
            cell.isYourOwn = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            WQICanHelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTwo forIndexPath:indexPath];
            cell.model = self.model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            // 取消分割线
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            cell.delegate = self;
            return cell;
        }
    }else {
        WQTopicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentsIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.model = self.commentsListArray[indexPath.row];
        cell.delegate = self;
        
        UILongPressGestureRecognizer * longPressGesture =         [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        [cell addGestureRecognizer:longPressGesture];
        
        return cell;
    }
}

- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pointr = [recognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pointr];
        self.index = indexPath;
        WQTopicCommentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        CGPoint point = [recognizer locationInView:cell];
        CGRect r = CGRectMake(point.x, point.y, 0, 0);
        UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(handleCopyCell:)];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
        UIMenuItem *itDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(handleDeleteCell:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        if ([cell.model.user_id isEqualToString:im_namelogin] || [WQDataSource sharedTool].isAdmin) {
            [menu setMenuItems:[NSArray arrayWithObjects:itCopy, itDelete,  nil]];
        }else {
            [menu setMenuItems:[NSArray arrayWithObjects:itCopy, nil]];
        }
        [menu setTargetRect:r inView:cell];
        [menu setMenuVisible:YES animated:YES];
    }
}

// 复制
- (void)handleCopyCell:(id)sender {
    WQTopicCommentCell *cell = [_tableView cellForRowAtIndexPath:self.index];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = cell.commentLabel.text;
}

// 删除
- (void)handleDeleteCell:(id)sender {
    WQCommentAndReplyModel *model = _commentsListArray[self.index.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urlString = @"api/group/deletegroupneedpost";
    params[@"pid"] = model.id;
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
        if ([response[@"success"] integerValue]) {
            [self loadCommentsData];
        }else {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        WQCommentDetailController * vc = [[WQCommentDetailController alloc] init];
        vc.isNeedsVC = YES;
        WQCommentAndReplyModel * model = self.commentsListArray[indexPath.row];
        vc.pid = model.id;
        vc.model = model;
        NSArray * second = model.comments;
        if (second.count) {
            vc.secondnaryComments = [NSArray yy_modelArrayWithClass:[WQGroupReplyModel class] json:second].mutableCopy;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return UITableViewAutomaticDimension;
        }
        if (indexPath.row == 1) {
            return 110;
        }
    }else {
        // return UITableViewAutomaticDimension;
        WQTopicCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQTopicCommentCell"];
        cell.addHeight = 0;
        cell.model = self.commentsListArray[indexPath.row];
        return 90 + cell.addHeight;
    }

    return UITableViewAutomaticDimension;
}



- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    for (UIView * view in cell.contentView.subviews) {
        if ([view isKindOfClass:[WQCommentTextView class]]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - WQAlreadyReceiveViewDelegate
- (void)shutDownBtnClikeWQAlreadyReceiveView:(WQAlreadyReceiveView *)alreadyReceiveView {
    self.alreadyReceiveView.hidden = YES;
    self.orderDetailsTableViewCell.redEnvelopeImageView.hidden = NO;
    self.orderDetailsTableViewCell.redEnvelopeLabel.hidden = NO;
}

#pragma mark - 监听通知
// 键盘弹出
- (void)keyboardWasShown:(NSNotification*)noti {
    __weak typeof(self) weakSelf = self;
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.commentsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.view);
            make.height.offset(50);
            make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-rect.size.height);
        }];
    }];
}
// 键盘消失
- (void)keyBoardWillHidden:(NSNotification *)noti {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.commentsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.offset(50);
        }];
    }];
}

// 滑动或者点击屏幕时隐藏分享
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.sharMenuView.hidden = YES;
    self.detailsSharView.hidden = YES;
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
}

#pragma mark - sharMenuViewDelagate
// 点击屏幕隐藏分享菜单
- (void)WQSharMenuViewHidden {
    self.sharMenuView.hidden = YES;
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
}
- (void)wqICanHelpTableViewCell:(WQICanHelpTableViewCell *)cell askBtnClike:(UIButton *)askBtn {

            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *userName = [userDefaults objectForKey:@"true_name"];
            NSString *userPic = [userDefaults objectForKey:@"pic_truename"];

        WQChaViewController *chatController =
        [[WQChaViewController alloc] initWithConversationChatter:self.response[@"user_id"]
                                                conversationType:EMConversationTypeChat
                                                          needId:self.needId
                                                     needOwnerId:self.bidModel.user_id
                                                        fromName:userName
                                                         fromPic:userPic
                                                          toName:self.bidModel.user_name
                                                           toPic:self.bidModel.user_pic
                                                      isFromTemp:YES
                                                      isTrueName:self.bidModel.truename
                                                   isBidTureName:YES];
        
        [self.navigationController pushViewController:chatController animated:YES];

}

- (void)wqSharBtnCliek {
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
    // 第三方分享
#pragma mark - 友盟分享
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请注册/登录后查看更多" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return ;
    }
    __weak typeof(self) weakSelf = self;
    //显示分享面板
    [WQSingleton sharedManager].platname = @"WQ";
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        if(platformType == UMSocialPlatformType_Sina){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Sina shareTypeIndex:0];
        }else if(platformType == UMSocialPlatformType_Sms){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Sms shareTypeIndex:1];
        }else if (platformType == UMSocialPlatformType_QQ){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_QQ shareTypeIndex:2];
        }else if (platformType == UMSocialPlatformType_Qzone){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Qzone shareTypeIndex:3];
        }else if (platformType == UMSocialPlatformType_WechatSession){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_WechatSession shareTypeIndex:4];
        }else if (platformType == UMSocialPlatformType_WechatTimeLine){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_WechatTimeLine shareTypeIndex:5];
        }else if (platformType == WQCopyLink){
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            NSString *copyLink = [NSString stringWithFormat:@"http://wanquan.belightinnovation.com/front/share/need?nid=%@",self.model.id];
            pasteboard.string = copyLink;
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"已复制至剪切板" andAnimated:YES andTime:1];
        }else if (platformType == WQQuanZi){
            WQGroupChooseSharGroupViewController *vc = [[WQGroupChooseSharGroupViewController alloc] init];
            vc.nid = self.needId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

#pragma mark -- 三个点的响应事件
- (void)menuBarViewBtnClick {
    NSString *titleName = self.isTop?@"取消置顶":@"置顶";
    WQActionSheet *actionSheet = [[WQActionSheet alloc]initWithTitles:@[titleName,@"删除"]];
    actionSheet.delegate = self;
    [actionSheet show];
}

- (void)clickedButton:(WQActionSheet *)sheetView ClickedName:(NSString *)name
{
    if ([name isEqualToString:@"删除"]) {
        
        WQAlertController *alertVC = [WQAlertController initWQAlertControllerWithTitle:nil message:@"确定删除主题？" style:UIAlertControllerStyleAlert titleArray:@[@"取消",@"确认"] alertAction:^(NSInteger index) {
            if (index) {
                [self wqdeleteBtnClike];
            }
        }];
        [alertVC showWQAlert];
        
    }else{
        [self wqAtTopBtnClick];
    }
    
}

#pragma mark -- WQGroupDemandForDetailsSharViewDelegate
// 置顶
- (void)wqAtTopBtnClick{
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
    
    NSString *urlString = @"api/group/settopgroupneed";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"gnid"] = self.gnid;
    if (self.isTop) {
        params[@"settop"] = @"false";
    }else {
        params[@"settop"] = @"true";
    }
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD showWithStatus:@"网络请求出错..."];
            [SVProgressHUD dismissWithDelay:1.3];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        
        NSString *str;
        if ([response[@"success"] boolValue]) {
            
            if (self.settopSuccessBlock) {
                self.settopSuccessBlock();
            }

            if (self.isTop) {
                str = @"已取消置顶";
                
                self.isTop = !self.isTop;
            }else {
                str = @"置顶成功";
                
                self.isTop = !self.isTop;
            }
        }else {
            if (self.isTop) {
                str = @"取消置顶失败";
            }else {
                str = @"置顶失败";
            }
        }
        [UIAlertController wqAlertWithController:self addTitle:nil andMessage:str andAnimated:YES andTime:1];
    }];
}

//分享不同的内容到平台platformType
- (void)shareWithPlatformType:(UMSocialPlatformType)platformType shareTypeIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    switch (index) {
        case 0:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_Sina];
            break;
        case 1:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_Sms];
            break;
        case 2:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_QQ];
            break;
        case 3:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
            break;
        case 4:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
            break;
        case 5:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
            break;
        default:
            break;
    }
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareWebpageObject *shareObject;
    if ([self.response[@"category_level_1"] isEqualToString:@"BBS"]) {
        NSString *str = @"读BBS领红包";
        NSString *spaceString = @"   ";
        NSString *joiningTogetherString = [str stringByAppendingString:spaceString];
        NSString *contentString = [joiningTogetherString stringByAppendingString:[NSString stringWithFormat:@"%@",self.response[@"content"]]];
        //创建网页内容对象
        NSString* thumbURL = @"https://wanquan.belightinnovation.com/metronic_v4.5.2/theme/assets/pages/img/admin-logo.png";
        shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"%@",self.response[@"subject"]] descr:contentString thumImage:thumbURL];
    }else {
        NSString *money = @"需求酬金:¥";
        NSString *moneySplice = [money stringByAppendingString:[NSString stringWithFormat:@"%@",self.response[@"money"]]];
        NSString *theBlankSpace = @"   ";
        NSString *inTheEndString = [moneySplice stringByAppendingString:[NSString stringWithFormat:@"%@",theBlankSpace]];
        NSString *moneySplicecontent = [inTheEndString stringByAppendingString:[NSString stringWithFormat:@"%@",self.response[@"content"]]];
        //创建网页内容对象
        NSString* thumbURL = @"https://wanquan.belightinnovation.com/metronic_v4.5.2/theme/assets/pages/img/admin-logo.png";
        shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"%@",self.response[@"subject"]] descr:moneySplicecontent thumImage:thumbURL];
    }
    
    //设置网页地址
    NSString *shardString = @"http://wanquan.belightinnovation.com/front/share/need?nid=";
    shareObject.webpageUrl = [shardString stringByAppendingString:[NSString stringWithFormat:@"%@",self.model.id]];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

- (void)alertWithError:(NSError *)error {
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n",(int)error.code];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    //[alert show];
}

- (void)setPinterstInfo:(UMSocialMessageObject *)messageObj {
    messageObj.moreInfo = @{@"source_url": @"http://www.umeng.com",
                            @"app_name": @"U-Share",
                            @"suggested_board_name": @"UShareProduce",
                            @"description": @"U-Share: best social bridge"};
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
    }
    return _params;
}
- (WQAlreadyReceiveView *)alreadyReceiveView {
    if (!_alreadyReceiveView) {
        _alreadyReceiveView = [[WQAlreadyReceiveView alloc] init];
        _alreadyReceiveView.delegate = self;
        _alreadyReceiveView.hidden = YES;
        [self.view addSubview:_alreadyReceiveView];
        
        [_alreadyReceiveView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _alreadyReceiveView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
