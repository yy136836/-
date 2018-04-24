//
//  WQMiriadeViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/10/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQMiriadeViewController.h"
#import "WQMiriadeTableViewCell.h"
#import "WQpublishViewTwoController.h"
#import "WQparticularsViewController.h"
#import "WQreplyView.h"
#import "WQreplyViewController.h"
#import "WQGroupReplyModel.h"
#import "WQMiriadeaModel.h"
#import "YYPhotoBrowseView.h"
#import "WQreplyModel.h"
#import "WQUserProfileController.h"
#import "WQRetweetStatusView.h"
#import "WQMiriadeVisitorsLoginView.h"
#import "WQLoginPopupWindow.h"
#import "WQRegisteredViewController.h"
#import "WQLogInController.h"
#import "WQlogonnRootViewController.h"
#import "WQRelationsCircleHomeViewController.h"
#import "WQTopPopupWindowView.h"
#import "WQHomdScreeningViewController.h"
#import "WQReleaseFriendsCircleViewController.h"
#import "WQPopupWindowEncourageView.h"
#import "WQTopicArticleController.h"
#import "WQmengcengView.h"
#import "WQTextInputViewWithOutImage.h"

static NSString *cellID = @"cellid";

#define gHframeHWXY 0
#define gHarrAyCount 0

@interface WQMiriadeViewController ()<UITableViewDelegate,UITableViewDataSource,AwesomeMenuDelegate,UITextFieldDelegate,WQMiriadeTableViewCellDelegate,WQLoginPopupWindowDelegate,WQTopPopupWindowViewDelegate,WQPopupWindowEncourageViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,WQTextInputViewWithOutImageDelegate>
@property (nonatomic, strong) WQreplyView *replyHeaderView;
@property (nonatomic, strong) WQLoginPopupWindow *loginPopupWindow;
@property (nonatomic, strong) WQTopPopupWindowView *topPopupWindowView;
@property (nonatomic, strong) WQPopupWindowEncourageView *popupWindowEncourageView;

/**
 评论的输入框
 */
@property (nonatomic, strong) WQTextInputViewWithOutImage *textInputViewWithOutImage;

/**
 键盘弹出的蒙板
 */
@property (nonatomic, strong) WQmengcengView *mengcengView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *shardTextField;
@property (nonatomic, strong) NSMutableDictionary *playTourParams;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableDictionary *caiParams;
@property (nonatomic, strong) NSMutableDictionary *commentsParams;
@property (nonatomic, strong) NSMutableDictionary *forwardingParams;
@property (nonatomic, strong) NSMutableDictionary *zanParams;
@property (nonatomic, strong) NSMutableDictionary *replyParams;            //消息提醒的参数
@property (nonatomic, strong) NSMutableArray *tableViewdetailOrderData;
@property (nonatomic, strong) NSMutableArray *replyArray;
@property (nonatomic, strong) NSMutableArray *imageIdArray;                //上传图片成功的ID数组
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentPageCount;
@property (nonatomic, copy) NSString *midString;                           //状态Id
@property (nonatomic, copy) void(^BtnshardTextFieldCliekBlick)(UIButton *);//评论输入内容
@property (nonatomic, copy) void(^commentTextFieldCliekBlick)();
@property (nonatomic, assign) BOOL haveNoMore;

@end

@implementation WQMiriadeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        //初始化游客登录UI
        [self setupTouristUI];
        self.navigationController.navigationBar.translucent = YES;
    }else{
        //初始化UI
        [self setupUI];
        // 添加AwesomeMenu按钮
        [self setupAwesomeMenu];
        // 下拉刷新
        [self pulldownrenovate];
        
        //注册键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wqDeleteSuccessful) name:WQdeleteSuccessful object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wqUpdateConstraints) name:WQUpdateConstraints object:nil];
    }
}

// 删除万圈成功
- (void)wqDeleteSuccessful {
    [self loadData];
}

- (void)wqUpdateConstraints {
    [self.textInputViewWithOutImage mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.textInputViewWithOutImage.inputHeight.constant > 30) {
            make.height.lessThanOrEqualTo(@130);
            make.height.greaterThanOrEqualTo(@50);
        }
    }];
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

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        self.navigationController.navigationBar.translucent = YES;
    }
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"好友圈";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *topPopupWindowViewBtn = [[UIBarButtonItem alloc]initWithTitle:@"∙∙∙" style:UIBarButtonItemStylePlain target:self action:@selector(topPopupWindowViewBtnClick)];
    [topPopupWindowViewBtn setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = topPopupWindowViewBtn;
    //uitextattributetextcolor替代方法
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
    self.navigationController.navigationBar.shadowImage = WQ_SHADOW_IMAGE;

    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 0;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xfafafa]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = WQ_SHADOW_IMAGE;
    
    // 代理置空，否则会崩
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark - 初始化游客登录UI
- (void)setupTouristUI {
    WQMiriadeVisitorsLoginView *visitorsLoginView = [[WQMiriadeVisitorsLoginView alloc] init];
    [self.view addSubview:visitorsLoginView];
    [visitorsLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        // make.edges.equalTo(self.view);
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
    
    WQLoginPopupWindow *loginPopupWindow = [[WQLoginPopupWindow alloc] init];
    loginPopupWindow.delegate = self;
    self.loginPopupWindow = loginPopupWindow;
    loginPopupWindow.hidden = YES;
    [self.view addSubview:loginPopupWindow];
    [loginPopupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 去登录的点击事件
    [visitorsLoginView setLoginBtnClickBlock:^{
        
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
    WQLogInController *vc = [[WQLogInController alloc] init];
    //WQlogonnNavViewController *nav = [[WQlogonnNavViewController alloc] initWithRootViewController:vc];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wqRegisteredBtnClick:(WQLoginPopupWindow *)loginPopupWindow {
    WQRegisteredViewController *vc = [[WQRegisteredViewController alloc] init];
    vc.isLogin = NO;
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

#pragma mark - 监听通知
- (void)keyboardWasShown:(NSNotification*)noti {
    
    __weak typeof(self) weakSelf = self;
    [self setBtnshardTextFieldCliekBlick:^(UIButton *sender) {
        if (sender) {
            weakSelf.mengcengView.hidden = NO;
            [weakSelf.mengcengView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.right.left.equalTo(weakSelf.view);
                make.bottom.equalTo(weakSelf.shardTextField.mas_top);
            }];
            weakSelf.shardTextField.placeholder = @"输入转发内容不超过100字";
            NSDictionary *userInfo = noti.userInfo;
            CGRect rect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
            CGRect textRect = weakSelf.shardTextField.frame;
            textRect.origin.y = rect.origin.y - 40;
            textRect.size.height = 40;
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.shardTextField.frame = textRect;
                [weakSelf.view layoutIfNeeded];
            }];
        }
    }];
    
    [self setCommentTextFieldCliekBlick:^{
        weakSelf.mengcengView.hidden = NO;
        [weakSelf.mengcengView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.textInputViewWithOutImage.mas_top);
        }];
        NSDictionary *userInfo = noti.userInfo;
        CGRect rect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        [weakSelf.textInputViewWithOutImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-rect.size.height);
            make.right.left.equalTo(weakSelf.view);
            make.height.greaterThanOrEqualTo(@50);
            make.height.lessThanOrEqualTo(@50);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [weakSelf.view layoutIfNeeded];
        }];
    }];

}

- (void)keyBoardWillHidden:(NSNotification *)noti {
    
    self.mengcengView.hidden = YES;
    
    CGRect textRect = self.shardTextField.frame;
    textRect.size.height = gHframeHWXY;
    textRect.origin.y = self.view.frame.size.height;
    self.shardTextField.text = @"";
    self.shardTextField.placeholder = nil;
    self.shardTextField.frame = textRect;
    [self.textInputViewWithOutImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(50);
        make.height.offset(50);
    }];
    [self.view layoutIfNeeded];
}

#pragma mark - 下拉刷新
- (void)pulldownrenovate {
//    __weak typeof(self) weakSelf = self;
//    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf loadData];
//        if (self.replyArray.count > gHarrAyCount) {
//            return ;
//        }
//        [weakSelf replyHeaderupLoad];
//    }];
//    [weakSelf.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewDeals];
    }];
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDeals)];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    //[header setTitle:@"最后刷新时间" forState:MJRefreshStateNoMoreData];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor blackColor];
    
    NSArray *imageArray = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"tableview_pull_refresh"],
                           [UIImage imageNamed:@"tableview_pull_refresh"],
                           nil];
    NSArray *pullingImages = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"上拉箭头"],
                              [UIImage imageNamed:@"上拉箭头"],
                              nil];
    /*NSArray *refreshingImages = [NSArray arrayWithObjects:
     [UIImage imageNamed:@"上拉箭头"],
     [UIImage imageNamed:@"上拉箭头"],
     nil];
     [header setImages:refreshingImages forState:MJRefreshStateRefreshing];*/
    [header setImages:imageArray forState:MJRefreshStateIdle];
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    [header placeSubviews];
    //header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    // 上拉加载
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
    // 设置文字
    [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    // 设置字体
    footer.stateLabel.textColor = HEX(0x999999);
    footer.stateLabel.textAlignment = NSTextAlignmentCenter;
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:16];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreDeals];
    }];
    // 设置footer
    self.tableView.mj_footer = footer;
    // 开始隐藏底部刷新
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark 加载新数据
- (void)loadNewDeals {
    self.currentPage = 0;
    self.currentPageCount = 20;
    [self loadData];
    //[self replyHeaderupLoad];
}

#pragma mark 加载更多数据
- (void)loadMoreDeals {
    //    self.currentPage += 1;
    if (_haveNoMore) {
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_footer setState:MJRefreshStateNoMoreData];
        return;
    }
    self.currentPageCount += 20;
    [self loadData];
}

#pragma mark - 初始化UI
- (void)setupUI {
    UITableView *tableView = [[UITableView alloc]init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[WQMiriadeTableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:tableView];
    tableView.showsVerticalScrollIndicator = NO;
    // 设置自动行高
    tableView.rowHeight = UITableViewAutomaticDimension;
    // 设置预估行高
    tableView.estimatedRowHeight = 350;
    
    self.replyHeaderView = [[WQreplyView alloc]initWithFrame:CGRectMake(gHframeHWXY, gHframeHWXY, gHframeHWXY, gHframeHWXY)];
    __weak typeof(self) weakSelf = self;
    //点击查看回复消息
    [_replyHeaderView setViewReplyBtnClikeBlock:^{
        WQreplyViewController *replyVc = [[WQreplyViewController alloc]init];
        [weakSelf replyHeaderupLoad];
        replyVc.tableViewdetailOrderData = weakSelf.replyArray;
        [weakSelf.navigationController pushViewController:replyVc animated:YES];
    }];
    
    tableView.tableHeaderView = _replyHeaderView;

    _replyHeaderView.hidden = YES;
    //自动布局
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    //转发评论的输入框
    [self.view addSubview:self.shardTextField];
    
    // 顶部弹窗
    WQTopPopupWindowView *topPopupWindowView = [[WQTopPopupWindowView alloc] init];
    topPopupWindowView.userInteractionEnabled = YES;
    UITapGestureRecognizer *topPopupWindowViewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topPopupWindowViewClick)];
    [topPopupWindowView addGestureRecognizer:topPopupWindowViewtap];
    topPopupWindowView.delegate = self;
    self.topPopupWindowView = topPopupWindowView;
    topPopupWindowView.hidden = YES;
    [self.view addSubview:topPopupWindowView];
    [topPopupWindowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
    
    // 鼓励的弹窗
    WQPopupWindowEncourageView *popupWindowEncourageView = [[WQPopupWindowEncourageView alloc] init];
    popupWindowEncourageView.delegate = self;
    self.popupWindowEncourageView = popupWindowEncourageView;
    popupWindowEncourageView.hidden = YES;
    [self.view addSubview:popupWindowEncourageView];
    [popupWindowEncourageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
    
    // 键盘弹出的蒙板
    WQmengcengView *mengcengView = [[WQmengcengView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    mengcengView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mengcengViewClick)];
    [mengcengView addGestureRecognizer:tap];
    mengcengView.hidden = YES;
    self.mengcengView = mengcengView;
    [[UIApplication sharedApplication].keyWindow addSubview:mengcengView];
    
    // 评论的输入框
    self.textInputViewWithOutImage = [[NSBundle mainBundle] loadNibNamed:@"WQTextInputViewWithOutImage" owner:self options:nil].lastObject;
    [self.view addSubview:self.textInputViewWithOutImage];
    self.textInputViewWithOutImage.delegate = self;
    self.textInputViewWithOutImage.inputtextView.delegate = self;
    [self.textInputViewWithOutImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(50);
    }];
}

#pragma mark -- 顶部弹窗的响应事件
- (void)topPopupWindowViewClick {
    self.topPopupWindowView.hidden = YES;
}

#pragma mark -- 蒙板的响应事件
- (void)mengcengViewClick {
    [self.view endEditing:YES];
}

#pragma mark - 请求数据
- (void)loadData {
    NSString *urlString = @"api/moment/query";
    self.params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    self.params[@"start_id"] = @(self.currentPage).description;
    self.params[@"count"] = @(self.currentPageCount).description;
    __weak typeof(self) weakSelf = self;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        


        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (error) {
            NSLog(@"%@",error);

            if (weakSelf.currentPageCount != 20) {
                weakSelf.currentPageCount -= 20;
            }
            // 加载新数据
            [self loadNewDeals];
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        
        if ([response[@"success"] boolValue]) {
            NSInteger lastCount = self.modelArray.count;
            if (!self.currentPage) {
                lastCount = -1;
            }
            
            weakSelf.modelArray = [NSArray yy_modelArrayWithClass: NSClassFromString(@"WQMiriadeaModel") json:response[@"moments"]];
            NSInteger newCount = self.modelArray.count;
            
            
            if ((_modelArray.count % 20 && _modelArray.count < 20) || (lastCount == newCount)) {
                _haveNoMore = YES;
            }
            
            [weakSelf.tableView.mj_header endRefreshing] ;
            [weakSelf.tableView.mj_footer endRefreshing];
            //weakSelf.tableView.mj_footer.hidden = weakSelf.tableViewdetailOrderData.count >= 500000;
            weakSelf.tableView.mj_footer.hidden = weakSelf.modelArray.count == weakSelf.tableViewdetailOrderData.count;
            [weakSelf.tableView reloadData];
            // 没有好友的提示他没好友好
            NSString *friend_count = response[@"friend_count"];
            if ([friend_count integerValue] <= 1) {
                weakSelf.tableView.mj_footer.hidden = YES;
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"添加好友可查看万圈更多内容" preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
                return ;
            }
        }
    }];
    
}

#pragma make - 加载通知数据
- (void)replyHeaderupLoad {
    NSString *urlString = @"api/moment/noticelist";
    self.replyParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    
    __weak typeof(self) weakSelf = self;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_replyParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        weakSelf.replyArray = [NSMutableArray yy_modelArrayWithClass:[WQreplyModel class] json:response[@"results"]].mutableCopy;
        
        NSMutableArray *array = [NSMutableArray array];
        for (id dict in response[@"results"]) {
            [array addObject:dict];
        }
        
        if (array.count > gHarrAyCount) {
            _replyHeaderView.hidden = NO;
            CGRect replyHeaderViewframe = _replyHeaderView.frame;
            CGFloat h = 100;
            CGFloat w = gHframeHWXY;
            CGFloat x = gHframeHWXY;
            CGFloat y = gHframeHWXY;
            replyHeaderViewframe.size.height = h;
            replyHeaderViewframe.size.width = w;
            replyHeaderViewframe.origin.x = x;
            replyHeaderViewframe.origin.y = y;
            _replyHeaderView.frame = replyHeaderViewframe;
        }else {
            _replyHeaderView.hidden = YES;
            CGRect replyHeaderViewframe = _replyHeaderView.frame;
            CGFloat h = gHframeHWXY;
            CGFloat w = gHframeHWXY;
            CGFloat x = gHframeHWXY;
            CGFloat y = gHframeHWXY;
            replyHeaderViewframe.size.height = h;
            replyHeaderViewframe.size.width = w;
            replyHeaderViewframe.origin.x = x;
            replyHeaderViewframe.origin.y = y;
            _replyHeaderView.frame = replyHeaderViewframe;
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark -- 评论的响应事件
- (void)WQTextInputViewWithOutImage:(WQTextInputViewWithOutImage *)view sendComment:(UIButton *)sendButton {
    // 判断输入的字是否是回车，即按下return
    if ([view.inputtextView.text isEqualToString:@"\n"]){
        // 在这里做你响应return键的代码
        if ([view.inputtextView.text isEqualToString:@""]) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
        return ;
    }
        sendButton.enabled = NO;
         NSString *urlString = @"api/moment/status/sendcomment";
        self.commentsParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        _commentsParams[@"content"] = view.inputtextView.text;
        _commentsParams[@"mid"] = self.midString;
        [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_commentsParams completion:^(id response, NSError *error) {
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
            BOOL whetherTread = [response[@"success"]boolValue];
            if (whetherTread) {
                sendButton.enabled = YES;
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"发送成功"];
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
            }else {
                sendButton.enabled = YES;
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
                [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"发送不成功，请重试"];
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
            }
            [self loadData];
        }];
}

#pragma mark -- WQPopupWindowEncourageViewDelegate
- (void)wqSubmitBtnClike:(WQPopupWindowEncourageView *)encourageView moneyString:(NSString *)moneyString {
    [self.popupWindowEncourageView.moneyTextField endEditing:YES];
    // 打赏提交的响应事件
    [self PlayTourDetermineBtnClikeMoneyString:moneyString];
}

- (void)wqCancelBtn:(WQPopupWindowEncourageView *)encourageView {
    // 打赏取消的响应事件
    encourageView.hidden = YES;
    [self.popupWindowEncourageView.moneyTextField endEditing:YES];
}

#pragma mark - 点击赞代理方法
- (void)wqMiriadeTableViewCellDelegate:(WQMiriadeTableViewCell *)miriadeTableViewCellDelegate {
    NSString *urlString = @"api/moment/status/likeordislike";
    self.zanParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    _zanParams[@"like"] = @"true";
    _zanParams[@"mid"] = self.midString;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_zanParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        BOOL whetherlike = [response[@"success"]boolValue];
        if (!whetherlike) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",response[@"message"]]];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        } else {
            [WQAlert showAlertWithTitle:nil message:WQ_ZAN_MESSAGE duration:1];
        }
        [self loadData];
    }];
}

#pragma mark -- 外链的响应事件
- (void)wqLinksContentViewClick:(WQMiriadeTableViewCell *)miriadeTableViewCell {
    WQTopicArticleController *vc = [[WQTopicArticleController alloc] init];
    vc.URLString = miriadeTableViewCell.miriadeaModel.link_url;
    vc.NavTitle = miriadeTableViewCell.miriadeaModel.link_txt;

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 转发外链的响应事件
- (void)wqForwardingLinksContentViewClick:(WQMiriadeTableViewCell *)miriadeTableViewCell linkURLString:(NSString *)linkURLString {
    WQTopicArticleController *vc = [[WQTopicArticleController alloc] init];
    vc.URLString = linkURLString;
    vc.NavTitle = miriadeTableViewCell.miriadeaModel.link_txt;

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击踩代理方法
- (void)wqRetweetBtnDelegate:(WQMiriadeTableViewCell *)retweetBtnClike {
    NSString *urlString = @"api/moment/status/likeordislike";
    self.caiParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    _caiParams[@"like"] = @"false";
    _caiParams[@"mid"] = self.midString;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_caiParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        BOOL whetherTread = [response[@"success"] boolValue];
        if (whetherTread == gHarrAyCount) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
            [SVProgressHUD showErrorWithStatus:response[@"message"]];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }
        [self loadData];
    }];
}

#pragma mark - 评论代理方法
- (void)wqCommentBtnDelegate:(WQMiriadeTableViewCell *)commentBtnClike {
    [self.textInputViewWithOutImage.inputtextView setValue:@"输入评论内容" forKey:@"placeholder"];
    [self.textInputViewWithOutImage.inputtextView becomeFirstResponder];
    
    if (self.commentTextFieldCliekBlick) {
        self.commentTextFieldCliekBlick();
    }
}

#pragma mark - 打赏的代理方法
- (void)wqsetPlayTourBtnDelegate:(WQMiriadeTableViewCell *)wqsetPlayTourBtnClike {
    self.popupWindowEncourageView.hidden = NO;
    [self.popupWindowEncourageView.moneyTextField becomeFirstResponder];
}

#pragma mark -- 顶部弹窗
- (void)topPopupWindowViewBtnClick {
    self.topPopupWindowView.hidden = !self.topPopupWindowView.hidden;
}

#pragma mark -- WQTopPopupWindowViewDelegate
- (void)dynamicBtnClickTopPopupWindowView:(WQTopPopupWindowView *)topPopupWindowView {
    topPopupWindowView.hidden = YES;
    WQHomdScreeningViewController *vc = [[WQHomdScreeningViewController alloc] init];
    vc.isMyDynamic = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)participateBtnClickTopPopupWindowView:(WQTopPopupWindowView *)topPopupWindowView {
    topPopupWindowView.hidden = YES;
    WQHomdScreeningViewController *vc = [[WQHomdScreeningViewController alloc] init];
    vc.isMyDynamic = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)PlayTourDetermineBtnClikeMoneyString:(NSString *)moneyString {
    NSString *urlString = @"api/moment/status/rewardstatus";
    self.playTourParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    _playTourParams[@"money"] = moneyString;
    _playTourParams[@"mid"] = self.midString;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_playTourParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"ecode"] boolValue]) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
            [SVProgressHUD showErrorWithStatus:@"\n   余额不足请充值  \n"];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
            return;
        }
        BOOL whetherTread = [response[@"success"]boolValue];
        if (whetherTread) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"谢谢您的鼓励" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            self.popupWindowEncourageView.hidden = YES;
        }else{
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:response[@"message"]  preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
        [self loadData];
    }];
}

// 点击文字进入详情
- (void)wqContentLabelClike:(WQMiriadeTableViewCell *)miriadeTableViewCell {
    WQparticularsViewController *particularsVc = [[WQparticularsViewController alloc] initWithmId:miriadeTableViewCell.miriadeaModel.id];
    
    // 删除需求成功刷新数据
//    [particularsVc setDeleteSuccessfulBlock:^{
//        [self loadData];
//    }];
    
    particularsVc.creditPoints = miriadeTableViewCell.miriadeaModel.user_creditscore;
    [self.navigationController pushViewController:particularsVc animated:YES];
}

#pragma mark - AwesomeMenu按钮
- (void)setupAwesomeMenu {
    UIButton *sendBtn = [[UIButton alloc]init];
    [sendBtn setImage:[UIImage imageNamed:@"fabuanniuchenghaoyouquan"] forState:0];
    [self.view addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) { 
        make.bottom.equalTo(self.view).offset(kScaleX(-55));
        make.right.equalTo(self.view).offset(kScaleX(-30));
    }];
    [sendBtn addTarget:self action:@selector(sendBtnClike) forControlEvents:UIControlEventTouchUpInside];
    
    //中间的startItem
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc]
                                  initWithImage:[UIImage imageNamed:@"publish"]
                                  highlightedImage:[UIImage imageNamed:@"publish"]
                                  ContentImage:[UIImage imageNamed:@"publish"]
                                  highlightedContentImage:nil];
    
    //添加其他几个按钮
    AwesomeMenuItem *item0 = [[AwesomeMenuItem alloc]
                              initWithImage:[UIImage imageNamed:@"publish_subject"]
                              highlightedImage:nil
                              ContentImage:[UIImage imageNamed:@"publish_subject"]
                              highlightedContentImage:[UIImage imageNamed:@"publish_subject"]];
    
    AwesomeMenuItem *item1 = [[AwesomeMenuItem alloc]
                              initWithImage:[UIImage imageNamed:@"publish_crowd_funding"]
                              highlightedImage:nil
                              ContentImage:[UIImage imageNamed:@"publish_crowd_funding"]
                              highlightedContentImage:[UIImage imageNamed:@"publish_crowd_funding"]];
    
    NSArray *items = @[item0, item1];
    
    //创建菜单按钮
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem menuItems:items];
    //[self.view addSubview:menu];
    
    //禁止转动
    menu.rotateAddButton = NO;
    //弹出范围
    menu.menuWholeAngle = -M_PI_2;
    //设置约束
    menu.startPoint = CGPointMake(gHframeHWXY, gHframeHWXY);
    
    //[menu mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.right.mas_equalTo(self.view.mas_right).mas_offset(-50);
        //make.bottom.equalTo(self.view).offset(-100);
    //}];
    
    //设置代理对象
    menu.delegate = self;
    
    //设置透明度
    menu.alpha = 0.5;
}

#pragma mark - 发主题按钮点击事件
- (void)sendBtnClike {
    
    if (![WQDataSource sharedTool].isVerified) {
        // 快速注册的用户
        UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"实名认证后可发布万圈"
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
    
    //WQpublishViewTwoController *vc = [[WQpublishViewTwoController alloc]init];
    WQReleaseFriendsCircleViewController *vc = [[WQReleaseFriendsCircleViewController alloc] init];
    [self.navigationController
     wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
         transition.animationType =  WXSTransitionAnimationTypePointSpreadPresent;
         transition.animationTime = 1;
         transition.backGestureEnable = NO;
     }];
    
    // 发布成功的回调,拿新数据
    [vc setReleaseSuccessBlock:^{
        [self loadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
}

#pragma mark - AwesomeMenu按钮Delegate
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx {
    switch (idx) {
        case 0:{
            WQpublishViewTwoController *vc = [[WQpublishViewTwoController alloc]init];
            [self.navigationController
             wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
                 transition.animationType =  WXSTransitionAnimationTypePointSpreadPresent;
                 transition.animationTime = 1;
                 transition.backGestureEnable = NO;
             }];
        }
            break;
        case 1:
    
            break;
            
        default:
            break;
    }
}
- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu {
    //切换图像
    menu.contentImage = [UIImage imageNamed:@"cancel_publish"];
    //更改透明度
    [UIView animateWithDuration:.25 animations:^{
        menu.alpha = 1;
    }];
}
- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu {
    //切换图像
    menu.contentImage = [UIImage imageNamed:@"publish"];
    //更改透明度
    [UIView animateWithDuration:.25 animations:^{
        menu.alpha = 0.5;
    }];
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.shardTextField) {
        if ([textField.text isEqualToString:@""]) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return YES;
        }
        if (textField.text.length > 100) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请控制评论字数少于100字" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return YES;
        }
        
        NSString *urlString = @"api/moment/status/forwardstatus";
        self.forwardingParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        _forwardingParams[@"content"] = textField.text;
        _forwardingParams[@"mid"] = self.midString;
        _forwardingParams[@"pic"] = @"[]";
        [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_forwardingParams completion:^(id response, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                return ;
            }
            if ([response isKindOfClass:[NSData class]]) {
                response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            }
            NSLog(@"%@",response);
            BOOL success = [response[@"success"]boolValue];
            if (success) {
                [self loadData];
                [textField resignFirstResponder];
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"转发成功" preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
            }else {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
            }
        }];
    }
    return YES;
}

#pragma mark - TableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WQMiriadeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WQparticularsViewController *particularsVc = [[WQparticularsViewController alloc] initWithmId:cell.miriadeaModel.id];
    
    // 删除需求成功刷新数据
//    [particularsVc setDeleteSuccessfulBlock:^{
//        [self loadData];
//    }];
    
    particularsVc.creditPoints = cell.miriadeaModel.user_creditscore;
    [self.navigationController pushViewController:particularsVc animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQMiriadeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    // 防止复用,如果用户没有发表标题,标题会复用别的cell的
    //cell.retweetStatusView.contentLabel.text = @"  ";
    //WQMiriadeaModel *model = self.modelArray[indexPath.row];
    //cell.retweetStatusView.contentLabel.text = model.content;
    cell.delegate = self;
    __weak typeof(self) weakSelf = self;
    __weak typeof(cell) _weakCell = cell;
    [cell setMidStringBlock:^(NSString *str) {
        weakSelf.midString = str;
    }];
    cell.miriadeaModel = self.modelArray[indexPath.row];
    NSString *mid = cell.miriadeaModel.id;
    NSLog(@"%@",mid);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setShardClikeBlock:^(UIButton *sender) {
        [weakSelf.shardTextField becomeFirstResponder];
        if (weakSelf.BtnshardTextFieldCliekBlick) {
            weakSelf.BtnshardTextFieldCliekBlick(sender);
        }
    }];
    
    // 点击头像
    [cell setHeadPortraitBlock:^{
        
        if (!_weakCell.miriadeaModel.truename) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"无法查看二度好友信息" preferredStyle:UIAlertControllerStyleAlert];
            
            [weakSelf presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }];
            return ;
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
        // 是当前账户
        if ([_weakCell.miriadeaModel.user_id isEqualToString:im_namelogin]) {
            WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:_weakCell.miriadeaModel.user_id];

            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else {
            WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:_weakCell.miriadeaModel.user_id];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    return cell;
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
    }
    return _params;
}

- (NSMutableArray *)tableViewdetailOrderData {
    if (!_tableViewdetailOrderData) {
        _tableViewdetailOrderData = [[NSMutableArray alloc] init];
    }
    return _tableViewdetailOrderData;
}
//转发输入
- (UITextField *)shardTextField {
    if (!_shardTextField) {
        _shardTextField = [[UITextField alloc]initWithFrame:CGRectMake(gHframeHWXY, self.view.frame.size.height, self.view.frame.size.width, gHframeHWXY)];
    }
    _shardTextField.returnKeyType = UIReturnKeySend;
    _shardTextField.enablesReturnKeyAutomatically = YES;
    _shardTextField.borderStyle = UITextBorderStyleRoundedRect;
    _shardTextField.delegate = self;
    _shardTextField.returnKeyType = UIReturnKeyDone;
    return _shardTextField;
}
- (NSMutableDictionary *)forwardingParams {
    if (!_forwardingParams) {
        _forwardingParams = [[NSMutableDictionary alloc]init];
    }
    return _forwardingParams;
}
- (NSMutableDictionary *)zanParams {
    if (!_zanParams) {
        _zanParams = [[NSMutableDictionary alloc]init];
    }
    return _zanParams;
}
- (NSMutableDictionary *)caiParams {
    if (!_caiParams) {
        _caiParams = [[NSMutableDictionary alloc]init];
    }
    return _caiParams;
}

- (NSMutableDictionary *)commentsParams {
    if (!_commentsParams) {
        _commentsParams = [[NSMutableDictionary alloc]init];
    }
    return _commentsParams;
}
- (NSMutableArray *)imageIdArray {
    if (!_imageIdArray) {
        _imageIdArray = [NSMutableArray array];
    }
    return _imageIdArray;
}
- (NSMutableDictionary *)replyParams {
    if (!_replyParams) {
        _replyParams = [[NSMutableDictionary alloc]init];
    }
    return _replyParams;
}
- (NSMutableArray *)replyArray {
    if (!_replyArray) {
        _replyArray = [[NSMutableArray alloc]init];
    }
    return _replyArray;
}
- (NSMutableDictionary *)playTourParams {
    if (!_playTourParams){
        _playTourParams = [[NSMutableDictionary alloc]init];
    }
    return _playTourParams;
}

#pragma mark - 两秒后移除提示框
- (void)delayMethod {
    //两秒后移除提示框
    [SVProgressHUD dismiss];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

