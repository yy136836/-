//
//  WQorderViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/2.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQorderViewController.h"
#import "UMSocialUIManager.h"
#import "UMSocialSinaHandler.h"
#import "WQNearbyroboneViewController.h"
#import "WQHomeNearby.h"
#import "WQHomeNearbyTagModel.h"
#import "WQChaViewController.h"
#import "WQMessageViewController.h"
#import "WQfeedbackViewController.h"
#import "WQorderHeadView.h"
#import "WQorderBottomView.h"
#import "WQorderDetailsTableViewCell.h"
#import "WQUserProfileController.h"
#import "WQSharMenuView.h"
#import "WQGroupChooseSharGroupViewController.h"
#import "WQAlreadyReceiveView.h"
#import "WQLoginPopupWindow.h"
#import "WQLogInController.h"
#import "WQRegisteredViewController.h"
#import "WQDynamicDetailsCommentTableViewCell.h"
#import "WQDynamicLevelSecondaryModel.h"
#import "WQDynamicLevelOncCommentModel.h"
#import "WQTextInputViewWithOutImage.h"
#import "WQCommentDetailsViewController.h"
#import "WQTopicDetailFooter.h"
#import "WQDataEmptyView.h"

static NSString *cellID = @"cellid";
static NSString *commentIdentifier = @"commentIdentifier";

@interface WQorderViewController ()<UITableViewDelegate,UITableViewDataSource,WQorderBottomViewDelegate,WQorderDetailsTableViewCellDelegate,UIScrollViewDelegate,WQSharMenuViewDelegate,WQAlreadyReceiveViewDelegate,WQLoginPopupWindowDelegate,UIGestureRecognizerDelegate,WQDynamicDetailsCommentTableViewCellDelegate,WQTextInputViewWithOutImageDelegate,UITextViewDelegate>
{
    NSIndexPath *cureIndex;
}
@property (nonatomic, strong) WQHomeNearby *homemodel;
@property (nonatomic, strong) WQorderHeadView *orderHeadView;
@property (nonatomic, strong) WQorderBottomView *orderBottomView;
@property (nonatomic, strong) WQorderDetailsTableViewCell *cell;
// 添加分享菜单默认隐藏
@property (nonatomic, strong) WQSharMenuView *sharMenuView;
@property (nonatomic, strong) WQAlreadyReceiveView *alreadyReceiveView;
@property (nonatomic, strong) WQLoginPopupWindow *loginPopupWindow;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSDictionary *response;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *contentString;
@property (nonatomic, copy) NSString *moneyString;
@property (nonatomic, copy) NSString *needsId;

/**
 底部评论输入框
 */
@property (nonatomic, strong) WQTextInputViewWithOutImage *textInputViewWithOutImage;

/**
 评论id
 */
@property (nonatomic, copy) NSString *midString;

@property (nonatomic, assign) BOOL isOnccommen;

@property (nonatomic, assign) BOOL iBid;

@property (nonatomic, strong) NSArray *comments;

@end

@implementation WQorderViewController {
    NSUserDefaults *userDefaults;
    WQLoadingView *loadingView;
}

- (instancetype)initWithUserId:(WQHomeNearbyTagModel *)homeNearbyTagModel add:(NSString *)distance {
    if (self = [super init]) {
        self.distance = distance;
        self.homeNearbyTagModel = homeNearbyTagModel;
        self.needsId = homeNearbyTagModel.id;
    }
    return self;
}

- (instancetype)initWithNeedsId:(NSString *)needsId{
    if (self = [super init]) {
        self.needsId = needsId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setupUI];
    [self loadCommentsList];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 键盘弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 监听通知
- (void)keyboardWasShown:(NSNotification*)noti {
    __weak typeof(self) weakSelf = self;
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [weakSelf.textInputViewWithOutImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-rect.size.height);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
}

- (void)keyBoardWillHidden:(NSNotification *)noti {
    [self.textInputViewWithOutImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(100);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)loadCommentsList {
    NSString *urlString = @"api/need/comment/getNeedComment1List";
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"need_id"] = self.needsId;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismissWithDelay:0.3];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        [SVProgressHUD dismissWithDelay:0.3];
        
        self.comments = [NSArray yy_modelArrayWithClass:[WQDynamicLevelOncCommentModel class] json:response[@"comments"]];
        
        if (!self.comments.count) {
//            WQTopicDetailFooter * footer = [[NSBundle mainBundle] loadNibNamed:@"WQTopicDetailFooter" owner:self options:nil].lastObject;
//            footer.label.text = @"";
//            footer.frame = CGRectMake(0, 0, kScreenWidth, 123);
//            self.tableview.tableFooterView = footer;
            
            WQDataEmptyView *footerView = [[WQDataEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 73)];
            footerView.textLabel.text = @"如果对此需求有疑问或想直接分享答案可以写在这里";
            self.tableview.tableFooterView = footerView;
        }else{
            self.tableview.tableFooterView = nil;
        }
        
        [self.tableview reloadData];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 代理置空，否则会崩
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        // 只有在二级页面生效
        if ([self.navigationController.viewControllers count] == 2) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
    @{NSFontAttributeName:[UIFont systemFontOfSize:20],
    NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    self.navigationItem.title = @"需求详情";
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fenxiangqunmingpian"] style:UIBarButtonItemStylePlain target:self action:@selector(numberClick:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    

    
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;

    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - 初始化UI
- (void)setupUI {
    WQorderHeadView *orderHeadView = [[WQorderHeadView alloc] initWithFrame:CGRectMake(0, 0, 0, 107) titleString:self.response[@"category_level_1"]];
    self.orderHeadView = orderHeadView;
    [self.view addSubview:orderHeadView];
    __weak typeof(self) weakSelf = self;
    // 编辑头像进入个人信息页
    [orderHeadView setHeadPortraitBlock:^{
        if ([[userDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
            self.loginPopupWindow.hidden = NO;
            [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(self.loginPopupWindow);
                make.height.offset(kScaleX(200));
            }];
            
            [UIView animateWithDuration:0.25 animations:^{
                [self.loginPopupWindow layoutIfNeeded];
            }];
            return;
        }
        
        if (![self.response[@"truename"] boolValue]) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"实名用户匿名状态" preferredStyle:UIAlertControllerStyleAlert];
            
            [weakSelf presentViewController:alertVC animated:YES completion:^{
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
        
        NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
        // 是当前账户
        if ([self.response[@"user_id"] isEqualToString:im_namelogin]) {
            WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:weakSelf.response[@"user_id"]];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else {
            WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:weakSelf.response[@"user_id"]];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    UITableView *tableView = [[UITableView alloc] init];
    self.tableview = tableView;
//    if (!self.isHome) {
//        tableView.backgroundColor = [UIColor colorWithHex:0xffffff];
//    }else {
//        tableView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
//    }
    tableView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    // 设置自动行高
    tableView.rowHeight = UITableViewAutomaticDimension;
    // 设置预估行高
    tableView.estimatedRowHeight = 1000;
    [tableView registerClass:[WQorderDetailsTableViewCell class] forCellReuseIdentifier:cellID];
    [tableView registerClass:[WQDynamicDetailsCommentTableViewCell class] forCellReuseIdentifier:commentIdentifier];
    tableView.tableHeaderView = orderHeadView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
        make.bottom.equalTo(self.view.mas_bottom).offset(-74);
    }];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ghStatusCellMargin)];
    footerView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    tableView.tableFooterView = footerView;
    
    [self.view addSubview:self.alreadyReceiveView];
    self.alreadyReceiveView.hidden = YES;
    [_alreadyReceiveView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSLog(@"%d",self.isIPickUpTheOrder);
    if (!self.isIPickUpTheOrder) {
        WQorderBottomView *orderBottomView = [[WQorderBottomView alloc] init];
        orderBottomView.delegate = self;
        self.orderBottomView = orderBottomView;
        [self.view addSubview:orderBottomView];
        [orderBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.height.offset(74);
        }];
        if (self.homeNearbyTagModel && [self.homeNearbyTagModel.status isEqualToString: @"STATUS_FNISHED"]) {
            orderBottomView.askBtn.enabled = NO;
            orderBottomView.helpBtn.enabled = NO;
//            [orderBottomView.helpBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(orderBottomView.askBtn.mas_left);
//            }];
        }

    }
    
    if (!self.isHome) {
        [tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(ghNavigationBarHeight);
            make.bottom.equalTo(self.orderBottomView.mas_top);
        }];
    }else {
        [tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(ghNavigationBarHeight);
            make.bottom.equalTo(self.orderBottomView.mas_top);
        }];
    }
    
    // 添加分享菜单默认隐藏
    /*
    WQSharMenuView *sharMenuView = [[WQSharMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    sharMenuView.isGroupFriends = NO;
    sharMenuView.delegate = self;
    self.sharMenuView = sharMenuView;
    sharMenuView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:sharMenuView];
//    [self.view addSubview:sharMenuView];
//    [sharMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
//        //make.left.bottom.right.equalTo(self.view);
//        //make.top.equalTo(self.view).offset(ghNavigationBarHeight);
//        make.edges.equalTo(self.view);
//    }];
    */
    WQLoginPopupWindow *loginPopupWindow = [[WQLoginPopupWindow alloc] init];
    loginPopupWindow.delegate = self;
    self.loginPopupWindow = loginPopupWindow;
    loginPopupWindow.hidden = YES;
    [self.view addSubview:loginPopupWindow];
    [loginPopupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    loadingView = [[WQLoadingView alloc] init];
    [loadingView show];
    [self.view addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 评论的输入框
    self.textInputViewWithOutImage = [[NSBundle mainBundle] loadNibNamed:@"WQTextInputViewWithOutImage" owner:self options:nil].lastObject;
    [self.view addSubview:self.textInputViewWithOutImage];
    self.textInputViewWithOutImage.delegate = self;
    self.textInputViewWithOutImage.inputtextView.placeholder = @"聊聊您的想法";
    self.textInputViewWithOutImage.inputtextView.delegate = self;
    self.textInputViewWithOutImage.userInteractionEnabled = YES;
    [self.textInputViewWithOutImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(100);
        make.height.lessThanOrEqualTo(@130);
        make.height.greaterThanOrEqualTo(@50);
    }];
}

#pragma mark -- WQLoginPopupWindowDelegate
- (void)wqLoginBtnClick:(WQLoginPopupWindow *)loginPopupWindow {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
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
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
    //WQRegisteredViewController *vc = [[WQRegisteredViewController alloc] init];
    //vc.isLogin = NO;
    WQLogInController *vc = [[WQLogInController alloc] initWithTouristLoginStatus:regist];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)wqTranslucentAreaClick:(WQLoginPopupWindow *)loginPopupWindow {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
}

#pragma mark - 加载UI数据
- (void)loadData {
    NSString *urlString = @"api/need/getneedinfo";
    self.params[@"nid"] = self.needsId;
    _params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    self.params[@"geo_lat"] = [userDefaults objectForKey:@"geo_lat"];
    self.params[@"geo_lng"] = [userDefaults objectForKey:@"geo_lng"];
    
    __weak typeof(self) weakSelf = self;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [loadingView dismiss];
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
        self.orderHeadView.moneyLabel.hidden = NO;
        if ([response[@"category_level_1"] isEqualToString:@"BBS"]) {
            self.orderHeadView.moneyLabel.hidden = YES;
            [self.orderBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            
            }];
            [self.tableview mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.left.bottom.equalTo(self.view);
                make.top.equalTo(self.view).offset(ghNavigationBarHeight);
            }];
        }
        
        [self showBottomState:response];
        //self.canBid = [response[@"can_bid"] boolValue];
        //NSString *urlString = [imageUrlString stringByAppendingString:response[@"user_pic"]];
        [self.orderHeadView.headPortraitImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(response[@"user_pic"])] options:YYWebImageOptionShowNetworkActivity];
        self.orderHeadView.userNameLabel.text = response[@"user_name"];
        //self.orderHeadView.timeLabel.text = response[@"finished_date"];
        NSString *pointsString = [NSString stringWithFormat:@"%@",response[@"user_creditscore"]];
        NSString *friendsString = [NSString stringWithFormat:@"%@",response[@"user_degree"]];
        
        NSString *role_id = [userDefaults objectForKey:@"role_id"];
        if ([role_id isEqualToString:@"200"]) {
            // 如果是游客登录不显示信用分和几度好友
            self.orderHeadView.creditImageView.image = [UIImage imageNamed:@""];
            self.orderHeadView.creditLabel.hidden = YES;
            self.orderHeadView.aFewDegreesBackgroundLabel.hidden = YES;
        }
        
        /*if ([[WQDataSource sharedTool].loginStatus isEqualToString:@"STATUS_UNVERIFY"]) {
         // 快速注册的用户只显示信用分不显示几度好友
         self.orderHeadView.friendsLabel.hidden = YES;
         self.orderHeadView.creditPointsLabel.text = [pointsString stringByAppendingString:@"分"];
         }*/
        
        if (![role_id isEqualToString:@"200"] && ![[WQDataSource sharedTool].loginStatus isEqualToString:@"STATUS_UNVERIFY"]) {
            // 实名认证的用户
            self.orderHeadView.aFewDegreesBackgroundLabel.text = [[WQTool friendship:[friendsString integerValue]] stringByAppendingString:@" "];
            self.orderHeadView.creditLabel.text = [pointsString stringByAppendingString:@"分"];
        }
        
        if ([response[@"user_idcard_status"] isEqualToString:@"STATUS_UNVERIFY"]) {
            // 快速注册的用户只显示信用分不显示几度好友
            self.orderHeadView.aFewDegreesBackgroundLabel.hidden = YES;
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
        
        self.subject = response[@"subject"];
        self.moneyString = [NSString stringWithFormat:@"%@", response[@"money"]] ;
        self.contentString = response[@"content"];
        NSInteger distance = [[NSString stringWithFormat:@"%zd",[response[@"distance"] integerValue]] integerValue];
        if (distance > 10000) {
            NSInteger kmPosition = distance / 1000;
            self.orderHeadView.distanceLabel.text = [[NSString stringWithFormat:@"%zd",kmPosition] stringByAppendingString:@"千米"];
        }else {
            self.orderHeadView.distanceLabel.text = [[NSString stringWithFormat:@"%zd",distance] stringByAppendingString:@"米"];
        }
//        self.orderHeadView.distanceLabel.text = self.distance;
        
        NSInteger time = [[NSString stringWithFormat:@"%@",response[@"left_secends"]] integerValue];
        
        
        
        self.orderHeadView.timeLabel.text = [WQTool getFinishTime:time];
        
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
                    [self.orderHeadView.timeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(11, 11));
                        make.left.equalTo(self.orderHeadView.tagOncLabel.mas_left);
                        make.top.equalTo(self.orderHeadView.tagOncLabel.mas_bottom).offset(ghStatusCellMargin);
                    }];
                }
                    break;
                case 2:{
                    self.orderHeadView.tagOncLabel.hidden = NO;
                    self.orderHeadView.tagTwoLabel.hidden = NO;
                    self.orderHeadView.tagOncLabel.text = user_tag.firstObject;
                    self.orderHeadView.tagTwoLabel.text = user_tag.lastObject;
                    
                    [self.orderHeadView.timeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(11, 11));
                        make.left.equalTo(self.orderHeadView.tagOncLabel.mas_left);
                        make.top.equalTo(self.orderHeadView.tagOncLabel.mas_bottom).offset(ghStatusCellMargin);
                    }];
                }
                    break;
                case 0:{
                    self.orderHeadView.tagOncLabel.hidden = YES;
                    self.orderHeadView.tagTwoLabel.hidden = YES;
                    // 非匿名没标签,把到期时间网上挪
                    [self.orderHeadView.timeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(11, 11));
                        make.left.equalTo(self.orderHeadView.userNameLabel.mas_left);
                        make.top.equalTo(self.orderHeadView.userNameLabel.mas_bottom).offset(ghStatusCellMargin);
                    }];
                }
                    break;
                default:
                    break;
            }
        }else {
            self.orderHeadView.tagOncLabel.hidden = YES;
            self.orderHeadView.tagTwoLabel.hidden = YES;
            
            // 匿名不显示标签,把到期时间网上挪
            [self.orderHeadView.timeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(11, 11));
                make.left.equalTo(self.orderHeadView.userNameLabel.mas_left);
                make.top.equalTo(self.orderHeadView.userNameLabel.mas_bottom).offset(ghStatusCellMargin);
            }];
        }
        
        // 如果是BBS的话隐藏底部View
        if ([response[@"category_level_1"] isEqualToString:@"BBS"]) {
            self.orderBottomView.hidden = YES;
        }
        
        self.response = response;
        WQHomeNearby *model = [WQHomeNearby yy_modelWithJSON:response];
        self.homemodel = model;
        [self.tableview reloadData];

        [loadingView dismiss];
    }];
}

- (void)showBottomState:(NSDictionary *)dict
{
    //：STATUS_BIDDING(待接单);STATUS_BIDDED（进行中）;STATUS_FNISHED（已完成）
    NSLog(@"%@",dict);

    if ([dict[@"status"]  isEqualToString:@"STATUS_BIDDING"] &&
        [dict[@"has_bid"] intValue] !=1) {//自己可以抢  订单未开始
        [self.orderBottomView.helpBtn setTitle:@"我能帮助" forState:UIControlStateDisabled];
        self.orderBottomView.helpBtn.enabled = YES;
    }else if ([dict[@"status"]  isEqualToString:@"STATUS_BIDDING"] && 
              [dict[@"has_bid"] intValue] ==1){//不能抢 订单未开始
        [self.orderBottomView.helpBtn setTitle:@"已抢单" forState:UIControlStateDisabled];
        self.orderBottomView.helpBtn.enabled = NO;
    }else if ([dict[@"status"]  isEqualToString:@"STATUS_BIDDED"]){ //订单开始
        [self.orderBottomView.helpBtn setTitle:@"已被选定为接单人" forState:UIControlStateDisabled];
        self.orderBottomView.helpBtn.enabled = NO;
    }else if ([dict[@"status"]  isEqualToString:@"STATUS_FNISHED"]){
        [self.orderBottomView.helpBtn setTitle:@"已完成" forState:UIControlStateDisabled];
        self.orderBottomView.helpBtn.enabled = NO;
    }

    
}


#pragma mark - 反馈
- (void)fankuiBtnClike {
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        self.loginPopupWindow.hidden = NO;
        [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.loginPopupWindow);
            make.height.offset(kScaleX(200));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.loginPopupWindow layoutIfNeeded];
        }];
        return;
    }
    
    WQfeedbackViewController *feedbackVc = [WQfeedbackViewController new];
    feedbackVc.feedbackType = TYPE_NEED;
    [self.navigationController pushViewController:feedbackVc animated:YES];
}

#pragma mark - WQorderBottomViewDelegate 
// 询问
- (void)WQorderBottomView:(WQorderBottomView *)orderBottomView askBtnClike:(UIButton *)askBtn {
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if (self.homeNearbyTagModel && [self.homeNearbyTagModel.status isEqualToString: @"STATUS_FNISHED"]) {
        return;
    }
    
    if ([role_id isEqualToString:@"200"]) {
        // 游客登录
//        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"即时会话请登录" preferredStyle:UIAlertControllerStyleAlert];
//        
//        [self presentViewController:alertVC animated:YES completion:^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [alertVC dismissViewControllerAnimated:YES completion:nil];
//            });
//        }];
//        return ;
        self.loginPopupWindow.hidden = NO;
        [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.loginPopupWindow);
            make.height.offset(kScaleX(200));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.loginPopupWindow layoutIfNeeded];
        }];
    }else{
        NSString *userName = [userDefaults objectForKey:@"true_name"];
        NSString *userPic = [userDefaults objectForKey:@"pic_truename"];
        if([self.response[@"user_id"] isEqualToString:[EMClient sharedClient].currentUsername]){
            EaseConversationListViewController *chatList = [[EaseConversationListViewController alloc] initWithNid:self.homeNearbyTagModel.id needOwnerId:self.homeNearbyTagModel.user_id isFromTemp:NO bidUserList:nil];
            [self.navigationController pushViewController:chatList animated:YES];
        }else{
            
            if (self.fromTemp) {
                EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:_homemodel.user_id type:EMConversationTypeChat createIfNotExist:NO];
                
                __block EMMessage * currentMessage;
                
                [conversation loadMessagesStartFromId:nil count:10000 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
                    
                    for (EMMessage * message in aMessages) {
                        if ([message.ext[@"nid"] isEqualToString:_homemodel.id] && (![message.ext[@"is_bidding"] boolValue])) {
                            currentMessage = message;
                            break;
                        }
                    }
                    
                    NSDictionary * ext = @{};
                    
                    if (currentMessage) {
                        ext = currentMessage.ext;
                    }
                    
                    WQChaViewController *chatController = [[WQChaViewController alloc] initWithConversationChatter:_homemodel.user_id conversationType:EMConversationTypeChat needId:_homemodel.id needOwnerId:_homemodel.user_id  fromName:userName fromPic:userPic toName:ext[@"to_name"] toPic:ext[@"to_name"] isFromTemp:ext[@"is_bidding"] isTrueName:ext[@"istruename"]isBidTureName:ext[@"isBidTureName"]];
                    if (![_homemodel.can_bid boolValue]) {
                        chatController.tempChatBiding = YES;
                    }
                    [self.navigationController pushViewController:chatController animated:YES];
                }];
            } else {
                EaseMessageViewController *chatController =
                [[EaseMessageViewController alloc] initWithConversationChatter:self.response[@"user_id"]
                                                              conversationType:EMConversationTypeChat
                                                                        needId:self.homeNearbyTagModel.id
                                                                   needOwnerId:self.homeNearbyTagModel.user_id
                                                                      fromName:userName
                                                                       fromPic:userPic
                                                                        toName:self.homeNearbyTagModel.user_name
                                                                         toPic:self.homeNearbyTagModel.user_pic
                                                                    isFromTemp:YES
                                                                    isTrueName:self.homeNearbyTagModel.truename
                                                                 isBidTureName:YES];
                
            [self.navigationController pushViewController:chatController animated:YES];
            /*WQChaViewController *chatController = [[WQChaViewController alloc] initWithConversationChatter:self.imHuanxinid conversationType:EMConversationTypeChat needId:self.homeNearbyTagModel.id needOwnerId:self.homeNearbyTagModel.user_id fromName:userName fromPic:userPic toName:self.homeNearbyTagModel.user_name toPic:self.homeNearbyTagModel.user_pic isFromTemp:YES isTrueName:self.homeNearbyTagModel.truename isBidTureName:YES];
             [weakSelf.navigationController pushViewController:chatController animated:YES];*/
            }
        }
    }
}
// 帮助
- (void)WQorderBottomView:(WQorderBottomView *)orderBottomView helpBtnClike:(UIButton *)helpBtn {
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    
    BOOL sholdHide = [role_id isEqualToString:@"200"];
    
    if (sholdHide) {
//        [WQAlert showAlertWithTitle:nil message:@"请登录后操作" duration:1.5];
//        return;
        self.loginPopupWindow.hidden = NO;
        [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.loginPopupWindow);
            make.height.offset(kScaleX(200));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.loginPopupWindow layoutIfNeeded];
        }];
        return;
    }
    
    
    if (self.homeNearbyTagModel && [self.homeNearbyTagModel.status isEqualToString: @"STATUS_FNISHED"]) {
        return;
    }
    WQNearbyroboneViewController *nearbyroboneVc = [[WQNearbyroboneViewController alloc]init];
    nearbyroboneVc.stringuserId = self.homemodel.id;
    [self.navigationController pushViewController:nearbyroboneVc animated:YES];
}

#pragma mark - 领取
- (void)wqToReceiveBtnClike:(WQorderDetailsTableViewCell *)orderDetailsTableViewCell {
    if ([[userDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        self.loginPopupWindow.hidden = NO;
        [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.loginPopupWindow);
            make.height.offset(kScaleX(200));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.loginPopupWindow layoutIfNeeded];
        }];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSString *urlString = @"api/need/bidandfinishneed";
    NSMutableDictionary *toReceiveParams = [NSMutableDictionary dictionary];
    toReceiveParams[@"nid"] = self.needsId;
    toReceiveParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    toReceiveParams[@"truename"] = @"true";
    __weak typeof(self) weakself = self;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:toReceiveParams completion:^(id response, NSError *error) {
        
        __strong typeof(weakself) strongself = weakself;
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        strongself.response = response;
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            // [self.tableview reloadData];
            //[self loadData];
            weakSelf.cell.whetherOrNotToReceive = YES;
            weakSelf.alreadyReceiveView.hidden = NO;
            weakSelf.cell.redEnvelopeImageView.image = nil;
            weakSelf.cell.redEnvelopeImageView.hidden = YES;
            weakSelf.cell.redEnvelopeLabel.hidden = YES;
            weakSelf.alreadyReceiveView.moneyString = self.moneyString;
            
        }else{
            weakSelf.cell.whetherOrNotToReceive = NO;
            /*UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",response[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];*/
        }

    }];
}


- (void)toReceive {
    
}

- (void)WQTextInputViewWithOutImage:(WQTextInputViewWithOutImage *)view sendComment:(UIButton *)sendButton {
    NSString *urlString = @"api/need/comment/createComments";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"content"] = view.inputtextView.text;
    params[@"need_id"] = self.needsId;
    if (!self.isOnccommen) {
        params[@"ori_comment_id"] = self.midString;
    }
    sendButton.enabled = NO;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            sendButton.enabled = YES;
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        //取消键盘第一响应者
        [view.inputtextView resignFirstResponder];
        view.inputtextView.text = nil;
        view.inputtextView.placeholder = @"聊聊您的想法";
        if ([response[@"success"] boolValue]) {
            sendButton.enabled = YES;
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"发送成功" andAnimated:YES andTime:1.5];
            [self loadCommentsList];
        }else {
            sendButton.enabled = YES;
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"发送不成功，请重试" andAnimated:YES andTime:1.5];
        }
    }];
}

- (void)wqCommentsBtnClick:(WQDynamicDetailsCommentTableViewCell *)cell {
    // 游客登录
    if ([[userDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        self.loginPopupWindow.hidden = NO;
        [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.loginPopupWindow);
            make.height.offset(kScaleX(200));
        }];

        [UIView animateWithDuration:0.25 animations:^{
            [self.loginPopupWindow layoutIfNeeded];
        }];
        return;
    }
    // 评论
//    self.isOnccommen = NO;
//    self.midString = cell.model.id;
//    [self.textInputViewWithOutImage.inputtextView becomeFirstResponder];
    
    WQCommentDetailsViewController *vc = [[WQCommentDetailsViewController alloc] init];
    vc.nid = self.needsId;
    vc.type = CommentDetaiTypeNeeds;
    vc.model = cell.model;
    vc.mid = cell.model.id;
    vc.isnid = YES;
    vc.isShowKeyBord = YES;
    [vc setSendSuccessCommentBlock:^{
        [self loadCommentsList];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (void)wqVisitorsLogIn:(WQDynamicDetailsCommentTableViewCell *)cell {
    // 游客登录
    if ([[userDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        self.loginPopupWindow.hidden = NO;
        [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.loginPopupWindow);
            make.height.offset(kScaleX(200));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.loginPopupWindow layoutIfNeeded];
        }];
        return;
    }
}

- (void)wqHeadBtnClike:(WQDynamicDetailsCommentTableViewCell *)cell {
    // 游客登录
    if ([[userDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        self.loginPopupWindow.hidden = NO;
        [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.loginPopupWindow);
            make.height.offset(kScaleX(200));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.loginPopupWindow layoutIfNeeded];
        }];
        return;
    }
    // 头像的响应事件
    WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:cell.model.user_id];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)commentsBtnClick {
    // 游客登录
    if ([[userDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        self.loginPopupWindow.hidden = NO;
        [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.loginPopupWindow);
            make.height.offset(kScaleX(200));
        }];

        [UIView animateWithDuration:0.25 animations:^{
            [self.loginPopupWindow layoutIfNeeded];
        }];
        return;
    }
    // 评论
    self.isOnccommen = YES;
    self.midString = self.needsId;
    [self.textInputViewWithOutImage.inputtextView becomeFirstResponder];
}

- (void)wqtextcClick:(WQDynamicDetailsCommentTableViewCell *)cell {
//    WQDynamicDetailsCommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    WQCommentDetailsViewController *vc = [[WQCommentDetailsViewController alloc] init];
    vc.nid = self.needsId;
    vc.type = CommentDetaiTypeNeeds;
    vc.model = cell.model;
    vc.mid = cell.model.id;
    vc.isnid = YES;
    [vc setSendSuccessCommentBlock:^{
        [self loadCommentsList];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section != 0) {
        // 游客登录
        if ([[userDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
            self.loginPopupWindow.hidden = NO;
            [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(self.loginPopupWindow);
                make.height.offset(kScaleX(200));
            }];
            
            [UIView animateWithDuration:0.25 animations:^{
                [self.loginPopupWindow layoutIfNeeded];
            }];
            return;
        }
        WQDynamicDetailsCommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        WQCommentDetailsViewController *vc = [[WQCommentDetailsViewController alloc] init];
        vc.nid = self.needsId;
        vc.type = CommentDetaiTypeNeeds;
        vc.model = cell.model;
        vc.mid = cell.model.id;
        vc.isnid = YES;
        vc.isShowKeyBord = YES;
        [vc setSendSuccessCommentBlock:^{
            [self loadCommentsList];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return self.comments.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WQorderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        self.indexPath = indexPath;
        cell.isYourOwn = NO;
        cell.model = self.homemodel;
        cell.delegate = self;
        self.cell = cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        WQDynamicDetailsCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.praiseBtn.hidden = YES;
        cell.role_id = [userDefaults objectForKey:@"role_id"];
        cell.model = self.comments[indexPath.row];
        cell.nid = cell.model.id;
        UILongPressGestureRecognizer * longPressGesture =         [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        [cell addGestureRecognizer:longPressGesture];

        
        return cell;
    }
}

- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pointr = [recognizer locationInView:self.tableview];
        NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:pointr];
        cureIndex = indexPath;
        WQDynamicDetailsCommentTableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        CGPoint point = [recognizer locationInView:cell];
        CGRect r = CGRectMake(point.x, point.y, 0, 0);
        UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(handleCopyCell:)];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
        UIMenuItem *itDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(handleDeleteCell:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        if ([cell.model.user_id isEqualToString:im_namelogin]) {
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
    WQDynamicDetailsCommentTableViewCell *cell = [self.tableview cellForRowAtIndexPath:cureIndex];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = cell.replyLabel.text;
    // 规格
}

// 删除
- (void)handleDeleteCell:(id)sender {
    WQDynamicDetailsCommentTableViewCell *cell = [self.tableview cellForRowAtIndexPath:cureIndex];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urlString = @"api/need/comment/deleteNeedComment";
    params[@"comment_id"] = cell.model.id;
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
            [self loadCommentsList];
        }else {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
        }
    }];
}




- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    UILabel *textLabel = [UILabel labelWithText:@"评论" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    [backgroundView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backgroundView).offset(-ghSpacingOfshiwu);
        make.left.equalTo(backgroundView).offset(ghSpacingOfshiwu);
    }];
    
    UIView *headLineView = [[UIView alloc] init];
    headLineView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    [backgroundView addSubview:headLineView];
    [headLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(ghStatusCellMargin);
        make.left.right.top.equalTo(backgroundView);
    }];
    
    UIButton *commentsBtn = [[UIButton alloc] init];
    commentsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    commentsBtn.layer.cornerRadius = 5;
    commentsBtn.layer.masksToBounds = YES;
    commentsBtn.backgroundColor = [UIColor colorWithHex:0xf4f0ff];
    [commentsBtn setImage:[UIImage imageNamed:@"xiepinglun"] forState:UIControlStateNormal];
    [commentsBtn setTitleColor:[UIColor colorWithHex:0x9872ca] forState:UIControlStateNormal];
    [commentsBtn addTarget:self action:@selector(commentsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [commentsBtn setTitle:@" 写评论" forState:UIControlStateNormal];
    [backgroundView addSubview:commentsBtn];
    [commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 25));
        make.centerY.equalTo(textLabel.mas_centerY);
        make.right.equalTo(backgroundView.mas_right).offset(-ghSpacingOfshiwu);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [backgroundView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.right.bottom.equalTo(backgroundView);
    }];
    
    return backgroundView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 59.0;
    }else {
        return 0.0;
    }
    
}

// 滑动或者点击屏幕时隐藏分享
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.sharMenuView.hidden = YES;
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
}

#pragma mark - WQAlreadyReceiveViewDelegate
- (void)shutDownBtnClikeWQAlreadyReceiveView:(WQAlreadyReceiveView *)alreadyReceiveView {
    self.alreadyReceiveView.hidden = YES;
    [self loadData];
    //self.cell.redEnvelopeLabel.hidden = NO;
    //self.cell.redEnvelopeImageView.hidden = NO;
}

#pragma mark - sharMenuViewDelagate
// 点击屏幕隐藏分享菜单
- (void)WQSharMenuViewHidden {
    self.sharMenuView.hidden = YES;
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
}

- (void)wqSharBtnCliek {
    self.sharMenuView.hidden = YES;
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
    // 第三方分享
    #pragma mark - 友盟分享
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
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType)  {
        if(platformType == UMSocialPlatformType_Sina){//
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Sina shareTypeIndex:0];
        }else if(platformType == UMSocialPlatformType_Sms){//
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Sms shareTypeIndex:1];
        }else if (platformType == UMSocialPlatformType_QQ){//
            [weakSelf shareWithPlatformType:UMSocialPlatformType_QQ shareTypeIndex:2];
        }else if (platformType == UMSocialPlatformType_Qzone){//
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Qzone shareTypeIndex:3];
        }else if (platformType == UMSocialPlatformType_WechatSession){//用 微信好友
            [weakSelf shareWithPlatformType:UMSocialPlatformType_WechatSession shareTypeIndex:4];
        }else if (platformType == UMSocialPlatformType_WechatTimeLine){//用  微信朋友圈
            [weakSelf shareWithPlatformType:UMSocialPlatformType_WechatTimeLine shareTypeIndex:5];
        }else if (platformType == WQCopyLink){//复制链接
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            NSString *copyLink = [NSString stringWithFormat:@"http://wanquan.belightinnovation.com/front/share/need?nid=%@",self.homeNearbyTagModel.id];
            pasteboard.string = copyLink;
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"已复制至剪切板" andAnimated:YES andTime:1];
        }else if (platformType ==WQQuanZi){//圈子
            [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
            WQGroupChooseSharGroupViewController *vc = [[WQGroupChooseSharGroupViewController alloc] init];
            vc.nid = self.needsId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)wqGroupBtnCliek {
    /*
    self.sharMenuView.hidden = YES;
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
    WQGroupChooseSharGroupViewController *vc = [[WQGroupChooseSharGroupViewController alloc] init];
    vc.nid = self.needsId;
    [self.navigationController pushViewController:vc animated:YES];
     */
}

// 弹出分享菜单
- (void)numberClick:(UIBarButtonItem *)sender {
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    
    if ([role_id isEqualToString:@"200"]) {
        self.tabBarController.tabBar.hidden = YES;
        self.loginPopupWindow.hidden = NO;
        [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.loginPopupWindow);
            make.height.offset(kScaleX(200));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.loginPopupWindow layoutIfNeeded];
        }];
        return;
    }
    
    [self wqSharBtnCliek];
    
    /*
    self.sharMenuView.hidden = !self.sharMenuView.hidden;
    if (_sharMenuView.hidden == NO) {
        [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 0;
    }else {
        [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
    }
     */
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
        NSString *contentString = [joiningTogetherString stringByAppendingString:[NSString stringWithFormat:@"%@",self.contentString]];
        //创建网页内容对象
        NSString* thumbURL = @"https://wanquan.belightinnovation.com/metronic_v4.5.2/theme/assets/pages/img/admin-logo.png";
        shareObject = [UMShareWebpageObject shareObjectWithTitle:self.subject descr:contentString thumImage:thumbURL];
    }else {
        NSString *money = @"需求酬金:¥";
        NSString *moneySplice = [money stringByAppendingString:[NSString stringWithFormat:@"%@",self.moneyString]];
        NSString *theBlankSpace = @"   ";
        NSString *inTheEndString = [moneySplice stringByAppendingString:[NSString stringWithFormat:@"%@",theBlankSpace]];
        NSString *moneySplicecontent = [inTheEndString stringByAppendingString:[NSString stringWithFormat:@"%@",self.contentString]];
        //创建网页内容对象
        NSString* thumbURL = @"https://wanquan.belightinnovation.com/metronic_v4.5.2/theme/assets/pages/img/admin-logo.png";
        shareObject = [UMShareWebpageObject shareObjectWithTitle:self.subject descr:moneySplicecontent thumImage:thumbURL];
    }
    
    
    //设置网页地址
    NSString *shardString = @"http://wanquan.belightinnovation.com/front/share/need?nid=";
    shareObject.webpageUrl = [shardString stringByAppendingString:[NSString stringWithFormat:@"%@",self.homeNearbyTagModel.id]];
    
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
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}

- (NSString *)subject {
    if (!_subject) {
        _subject = [[NSString alloc] init];
    }
    return _subject;
}

- (NSString *)contentString {
    if (!_contentString) {
        _contentString = [[NSString alloc] init];
    }
    return _contentString;
}

- (NSDictionary *)response {
    if (!_response) {
        _response = [[NSDictionary alloc] init];
    }
    return _response;
}
- (NSString *)needsId {
    if (!_needsId) {
        _needsId = [[NSString alloc] init];
    }
    return _needsId;
}
- (NSString *)user_degree {
    if (!_user_degree) {
        _user_degree = [[NSString alloc] init];
    }
    return _user_degree;
}
- (WQAlreadyReceiveView *)alreadyReceiveView {
    if (!_alreadyReceiveView) {
        _alreadyReceiveView = [[WQAlreadyReceiveView alloc] init];
        _alreadyReceiveView.delegate = self;
        _alreadyReceiveView.hidden = YES;
    }
    return _alreadyReceiveView;
}

@end
