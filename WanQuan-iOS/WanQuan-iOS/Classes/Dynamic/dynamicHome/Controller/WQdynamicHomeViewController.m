//
//  WQdynamicHomeViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQdynamicHomeViewController.h"
#import "WQCycleScrollView.h"
#import "WQdynamicTableViewCell.h"
#import "WQPeopleWhoAreInterestedInTableViewCell.h"
#import "WQdynamicSearchViewController.h"
#import "WQRelationsCircleSearchNvc.h"
#import "WQdynamicHomeModel.h"
#import "WQDynamicChannelOffPopupWindowView.h"
#import "WQdynamicContentView.h"
#import "WQmoment_statusModel.h"
#import "WQmoment_choicest_articleModel.h"
#import "WQUserProfileController.h"
#import "WQdynamicUserInformationView.h"
#import "WQTopicArticleController.h"
#import "WQPeopleWhoAreInterestedInModel.h"
#import "WQGroupInformationViewController.h"
#import "WQReleaseFriendsCircleViewController.h"
#import "WQdynamicToobarView.h"
#import "WQmyDynamicPopupWindowView.h"
#import "WQHomdScreeningViewController.h"
#import "WQdynamicDetailsViewConroller.h"
#import "WQPopupWindowEncourageView.h"
#import "WQEssenceDetailController.h"
#import "WQEssenceModel.h"
#import "WQEssenceDataEntity.h"
#import "WQLoginPopupWindow.h"
#import "WQLogInController.h"
#import "WQRefreshHeader.h"
#import "WQTextInputViewWithOutImage.h"
#import "UMSocialUIManager.h"
#import "WQActionSheet.h"
#import "WQfeedbackViewController.h"

static NSString *identifier = @"identifier";
static NSString *interestedInIdentifier = @"interestedInIdentifier";

@interface WQdynamicHomeViewController () <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,SDCycleScrollViewDelegate,WQdynamicTableViewCellDelegate,WQmyDynamicPopupWindowViewDelegate,WQPopupWindowEncourageViewDelegate,WQLoginPopupWindowDelegate,WQTextInputViewWithOutImageDelegate,WQPeopleWhoAreInterestedInTableViewCellDelegate,WQActionSheetDelegate>

/**
 底部评论输入框
 */
@property (nonatomic, strong) WQTextInputViewWithOutImage *textInputViewWithOutImage;

/**
 数据
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 导航栏左上角的弹窗
 */
@property (nonatomic, strong) WQmyDynamicPopupWindowView *myDynamicPopupWindowView;

/**
 鼓励的弹窗
 */
@property (nonatomic, strong) WQPopupWindowEncourageView *popupWindowEncourageView;

/**
 精选模型
 */
@property (nonatomic, strong) WQmoment_choicest_articleModel *articleModel;

/**
 动态模型
 */
@property (nonatomic, strong) WQmoment_statusModel *moment_statusModel;

/**
 打赏的某行的Id
 */
@property (nonatomic, copy) NSString *midString;

/**
 轮播图数据
 */
@property (nonatomic, strong) NSArray *bannerImagesArray;

/**
 状态
 */
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *role_id;

@end

@implementation WQdynamicHomeViewController {
    // 根视图
    UITableView *ghTableView;
    // 轮播图
    WQCycleScrollView *cycleScrollView;
    WQLoginPopupWindow *loginPopupWindow;
    WQLoadingView *loadingView;
    WQLoadingError *loadingError;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"动态";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shaixuandongtai"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnClick)];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shouyesousuo"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnClick)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    [self fetchCarousel];
    

}

- (void)tableViewScrollTop
{
    [WQTool scrollToTopRow:ghTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 复制链接
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(copyLink) name:WQSharCopyLink object:nil];
    // 删除成功的回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewDeals) name:WQdeleteSuccessful object:nil];
    // 键盘弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
    
    [self setUpView];
    [self loadList];
    [self pulldownrenovate];
}

#pragma mark -- 初始化View
- (void)setUpView {
    ghTableView = [[UITableView alloc] init];
    if(@available(iOS 11.0, *)) {
        ghTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        ghTableView.estimatedSectionFooterHeight = 0;
        ghTableView.estimatedSectionHeaderHeight = 0;
        ghTableView.estimatedRowHeight = 0;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ghTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    // 设置代理对象
    ghTableView.delegate = self;
    ghTableView.dataSource = self;
    // 取消分割线&滚动条
    ghTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ghTableView.showsVerticalScrollIndicator = NO;
    // 设置自动行高和预估行高
    ghTableView.rowHeight = UITableViewAutomaticDimension;
    ghTableView.estimatedRowHeight = 400;
    // 注册cell
    [ghTableView registerClass:[WQdynamicTableViewCell class] forCellReuseIdentifier:identifier];
    [ghTableView registerClass:[WQPeopleWhoAreInterestedInTableViewCell class] forCellReuseIdentifier:interestedInIdentifier];
    [self.view addSubview:ghTableView];
    ghTableView.contentInset = UIEdgeInsetsMake(0, 0, TAB_HEIGHT, 0);
    [ghTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
    }];
    
    // 加号的按钮
    UIButton *addBtn = [[UIButton alloc]init];
    [addBtn setImage:[UIImage imageNamed:@"fabuanniuchenghaoyouquan"] forState:0];
    [addBtn addTarget:self action:@selector(addBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-(35 + TAB_HEIGHT));
        make.right.equalTo(self.view).offset(-20);
    }];
    
//    // 导航栏左上角的弹窗
//    WQmyDynamicPopupWindowView *myDynamicPopupWindowView = [[WQmyDynamicPopupWindowView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, kScreenWidth, kScreenHeight - NAV_HEIGHT)];
//    myDynamicPopupWindowView.delegate = self;
//    self.myDynamicPopupWindowView = myDynamicPopupWindowView;
//    myDynamicPopupWindowView.hidden = YES;
//   // [[UIApplication sharedApplication].keyWindow addSubview:myDynamicPopupWindowView];
    
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
    
    // 登录的弹窗
    loginPopupWindow = [[WQLoginPopupWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    loginPopupWindow.delegate = self;
    loginPopupWindow.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:loginPopupWindow];
    
    // 评论的输入框
    self.textInputViewWithOutImage = [[NSBundle mainBundle] loadNibNamed:@"WQTextInputViewWithOutImage" owner:self options:nil].lastObject;
    [self.view addSubview:self.textInputViewWithOutImage];
    self.textInputViewWithOutImage.delegate = self;
    self.textInputViewWithOutImage.inputtextView.placeholder = @"聊聊您的想法";
    self.textInputViewWithOutImage.inputtextView.delegate = self;
    self.textInputViewWithOutImage.userInteractionEnabled = YES;
    [self.textInputViewWithOutImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.lessThanOrEqualTo(@130);
        make.height.greaterThanOrEqualTo(@50);
    }];
    
    WQDynamicChannelOffPopupWindowView *nelOffPopupWindowView = [[WQDynamicChannelOffPopupWindowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    nelOffPopupWindowView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:nelOffPopupWindowView];
    
    NSUserDefaults *ghUserDefaults = [NSUserDefaults standardUserDefaults];
    BOOL ischannelOff = [ghUserDefaults objectForKey:@"dynamicChannelOff"];
    // 之前显示过
    if (!ischannelOff) {
        nelOffPopupWindowView.hidden = NO;
        [ghUserDefaults setObject:@"YES" forKey:@"dynamicChannelOff"];
    }
    
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
        [weakSelf loadNewDeals];
    }];
    [loadingError dismiss];
    [self.view addSubview:loadingError];
    [loadingError mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
    }];
}

#pragma mark - 下拉刷新
- (void)pulldownrenovate {
    ghTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewDeals];
    }];
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDeals)];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
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
    [header setImages:imageArray forState:MJRefreshStateIdle];
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    [header placeSubviews];
    ghTableView.mj_header = header;
    // 上拉加载
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
    // 设置文字
    [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = HEX(0x999999);
    footer.stateLabel.textAlignment = NSTextAlignmentCenter;
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:16];
    // 设置footer
    ghTableView.mj_footer = footer;
    // 开始隐藏底部刷新
    ghTableView.mj_footer.hidden = YES;
}

#pragma mark 加载新数据
- (void)loadNewDeals {
    [self.dataArray removeAllObjects];
    [self loadList];
}

#pragma mark 加载更多数据
- (void)loadMoreDeals {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        // 游客登录
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请注册/登录后查看更多" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        [ghTableView.mj_footer endRefreshing];
        return ;
    }
    [self loadList];
}

#pragma mark -- 获取数据
- (void)loadList {
    NSString *urlString = @"api/moments/query";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"limit"] = @(20).description;
    params[@"start"] = @(self.dataArray.count).description;
    params[@"secretkey"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [loadingError show];
            [loadingView dismiss];
            [ghTableView.mj_header endRefreshing];
            [ghTableView.mj_footer endRefreshing];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        
        [self.dataArray addObjectsFromArray:[NSMutableArray yy_modelArrayWithClass:[WQdynamicHomeModel class] json:response[@"moments"]]];
        
        
        if (self.dataArray.count) {
            [ghTableView.mj_footer endRefreshing];
        } else {
            [ghTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [ghTableView.mj_header endRefreshing];
        [ghTableView reloadData];
        [loadingView dismiss];
        [loadingError dismiss];
        ghTableView.mj_footer.hidden = self.dataArray.count >= 500000;
    }];
}

- (void)fetchCarousel {
    NSString * strURL = @"api/choicest/getcarousel";
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            return ;
        }
        if (!response[@"success"]) {
            return;
        }
        _bannerImagesArray = [NSArray yy_modelArrayWithClass:[WQEssenceModel class] json:response[@"choicests"]].mutableCopy;
        
        NSMutableArray * images = @[].mutableCopy;
        NSMutableArray * titles = @[].mutableCopy;
        for (WQEssenceModel *essenceModel in self.bannerImagesArray) {
            [images addObject:WEB_IMAGE_LARGE_URLSTRING(essenceModel.choicest_article.carousel_pic)];
            [titles addObject:essenceModel.choicest_article.subject];
        }
        
        cycleScrollView = [WQCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150.0 / 375 * kScreenWidth) imageURLStringsGroup:images];
        cycleScrollView.titlesGroup = titles;
        if (images.count <= 1) {
            cycleScrollView.autoScroll = NO;
        }
        cycleScrollView.infiniteLoop = YES;
        cycleScrollView.autoScrollTimeInterval = 5;
        cycleScrollView.autoScroll = YES;
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView.titleLabelTextAlignment = NSTextAlignmentLeft;
        cycleScrollView.titleLabelTextFont = [UIFont systemFontOfSize:18];
        cycleScrollView.titleLabelTextColor = [UIColor whiteColor];
        cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        cycleScrollView.delegate = self;
        ghTableView.tableHeaderView = cycleScrollView;
    }];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    WQEssenceDetailController * vc = [[WQEssenceDetailController alloc] init];
    vc.model = self.bannerImagesArray[index];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 复制链接
- (void)copyLink {
    UMShareMenuSelectionView *view = [[UMShareMenuSelectionView alloc] init];
    [view hiddenShareMenuView];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    // 万圈状态
    if ([self.type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        pasteboard.string = [[BASE_URL_STRING stringByAppendingString:@"front/momentStatus/momentStatusH5Show?&mid="] stringByAppendingString:self.moment_statusModel.id];
    }else if ([self.type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        // 精选状态
        pasteboard.string = [NSString stringWithFormat:@"%@front/choicest/articleh5show?choicest_id=%@",BASE_URL_STRING,self.articleModel.essenceId.length ? self.articleModel.essenceId : @"8feb4a1d891943aeb0d382269602ea2f"];
    }
    [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"已复制至剪切板" andAnimated:YES andTime:1];
}

#pragma mark -- 加号的响应事件
- (void)addBtnClike {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
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
    
    WQReleaseFriendsCircleViewController *vc = [[WQReleaseFriendsCircleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController
//     wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
//         transition.animationType = WXSTransitionAnimationTypePointSpreadPresent;
//         transition.animationTime = 1;
//         transition.backGestureEnable = NO;
//     }];
    
    // 发布成功的回调,拿新数据
    [vc setReleaseSuccessBlock:^{
        [self.dataArray removeAllObjects];
        [self loadNewDeals];
        [ghTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
}

- (void)WQTextInputViewWithOutImage:(WQTextInputViewWithOutImage *)view sendComment:(UIButton *)sendButton {
    
    // 万圈动态
    sendButton.enabled = NO;
    if ([self.type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        NSString *urlString = @"api/moment/status/sendcomment";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"content"] = view.inputtextView.text;
        params[@"mid"] = self.midString;
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
                [self loadList];
            }else {
                sendButton.enabled = YES;
                [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"发送不成功，请重试" andAnimated:YES andTime:1.5];
            }
        }];
    }else if ([self.type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        // 精选状态
        NSString *urlString = @"api/choicest/articlecreatecomment";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"content"] = view.inputtextView.text;
        params[@"choicest_id"] = self.midString;
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
                [self loadList];
            }else {
                sendButton.enabled = YES;
                [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"发送不成功，请重试" andAnimated:YES andTime:1.5];
            }
        }];
    }
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
        make.bottom.equalTo(self.view);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark -- WQPopupWindowEncourageViewDelegate
- (void)wqSubmitBtnClike:(WQPopupWindowEncourageView *)encourageView moneyString:(NSString *)moneyString {
    [self.popupWindowEncourageView.moneyTextField endEditing:YES];
    // 打赏提交的响应事件
    NSString *urlString;
    //= @"api/moment/status/rewardstatus";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"money"] = moneyString;
    // 万圈动态
    if ([self.type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        urlString = @"api/moment/status/rewardstatus";
        params[@"mid"] = self.midString;
    }else if ([self.type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        urlString = @"api/choicest/articlereward";
        params[@"choicest_id"] = self.midString;
    }
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"ecode"] boolValue]) {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"余额不足请充值" andAnimated:YES andTime:1.5];
            return;
        }
        BOOL whetherTread = [response[@"success"]boolValue];
        if (whetherTread) {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"谢谢您的鼓励" andAnimated:YES andTime:1.5];
            self.popupWindowEncourageView.hidden = YES;
        }else{
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
        }
    }];
}

- (void)wqCancelBtn:(WQPopupWindowEncourageView *)encourageView {
    // 打赏取消的响应事件
    encourageView.hidden = YES;
    self.popupWindowEncourageView.moneyTextField.text = @"";
    [self.popupWindowEncourageView.moneyTextField endEditing:YES];
}

#pragma mark -- WQdynamicTableViewCellDelegate
- (void)wqGroupNameClick:(WQessenceView *)essenceView cell:(WQdynamicTableViewCell *)cell {
    // 来自圈子的响应事件
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
    WQGroupInformationViewController *vc = [[WQGroupInformationViewController alloc] init];
    vc.gid = cell.model.moment_choicest_article.article_group_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wqContentLabelClick:(WQdynamicTableViewCell *)cell {
    // 万圈动态
    if ([cell.model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        WQdynamicDetailsViewConroller *vc = [[WQdynamicDetailsViewConroller alloc] init];
        vc.mid = cell.model.moment_status.id;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        WQEssenceDetailController *vc = [[WQEssenceDetailController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)wqUser_picImageViewClick:(WQdynamicTableViewCell *)cell {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
    // 头像的响应事件
    NSString *uid;
    if ([cell.model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        // 万圈状态
        uid = cell.model.moment_status.user_id;
    }else if ([cell.model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        // 精选状态
        uid = cell.model.moment_choicest_article.user_id;
    }
    WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:uid];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wqGuanzhuBtnClick:(WQdynamicTableViewCell *)cell {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
    // 关注的响应事件
    // 已关注
    if (cell.model.moment_choicest_article.user_followed) {
        // 取消关注
        NSString *urlString = @"api/user/follow/deletefollow";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"uid"] = cell.model.moment_choicest_article.user_id;
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
                cell.model.moment_choicest_article.user_followed = NO;
                cell.userInformationView.guanzhuBtn.backgroundColor = [UIColor whiteColor];
                [cell.userInformationView.guanzhuBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
                [cell.userInformationView.guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
            }else {
                [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
            }
        }];
    }else {
        NSString *urlString = @"api/user/follow/createfollow";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"uid"] = cell.model.moment_choicest_article.user_id;
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
                cell.model.moment_choicest_article.user_followed = YES;
                cell.userInformationView.guanzhuBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
                [cell.userInformationView.guanzhuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.userInformationView.guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
            }else {
                [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
            }
        }];
    }
}

- (void)wqLinksContentViewClick:(WQLinksContentView *)linksContentView cell:(WQdynamicTableViewCell *)cell {
    // 外链的响应事件
    WQTopicArticleController *vc = [[WQTopicArticleController alloc] init];
    vc.URLString = cell.model.moment_status.link_url;
    vc.NavTitle = cell.model.moment_status.link_txt;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma 赞
- (void)wqPraiseBtnClick:(WQdynamicToobarView *)yoobarView cell:(WQdynamicTableViewCell *)cell {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
    // 赞的响应事件
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urlString;
    // 万圈状态
    NSLog(@"%@",cell.model.moment_type);
    if ([cell.model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        urlString = @"api/moment/status/likeordislike";
        params[@"mid"] = cell.model.moment_status.id;
        params[@"like"] = @"true";
    }else if ([cell.model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        urlString = @"api/choicest/articlelike";
        params[@"choicest_id"] = cell.model.moment_choicest_article.id;
    }
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
            [yoobarView.praiseBtn setImage:[UIImage imageNamed:@"dynamicyidianzan"] forState:UIControlStateNormal];
            [yoobarView.praiseBtn setTitleColor:[UIColor colorWithHex:0xee9b11] forState:UIControlStateNormal];
            if ([cell.model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
                // 万圈状态
                cell.model.moment_status.can_like = NO;
                NSInteger i = [cell.model.moment_status.like_count integerValue];
                cell.model.moment_status.like_count = [NSString stringWithFormat:@"%zd",i + 1];
            }else if ([cell.model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
                // 精选状态
                cell.model.moment_choicest_article.can_like = NO;
                NSInteger i = [cell.model.moment_choicest_article.like_count integerValue];
                cell.model.moment_choicest_article.like_count = [NSString stringWithFormat:@"%zd",i + 1];
            }
            
            [WQAlert showAlertWithTitle:nil message:WQ_ZAN_MESSAGE duration:1];
            
            [ghTableView reloadData];
        }else {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
        }
    }];
}

- (void)wqCommentsBtnClick:(WQdynamicToobarView *)yoobarView cell:(WQdynamicTableViewCell *)cell {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
    self.type = cell.model.moment_type;
    // 评论的响应事件
    // 万圈动态
    if ([cell.model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        // 评论的数量
        if ([cell.model.moment_status.comment_count integerValue] == 0) {
            // 评论的数量为O时
            self.midString = cell.model.moment_status.id;
            [self.textInputViewWithOutImage.inputtextView becomeFirstResponder];
        }else {
            WQdynamicDetailsViewConroller *vc = [[WQdynamicDetailsViewConroller alloc] init];
            
            [vc setLikeBlock:^{
                [self loadNewDeals];
            }];
            
            //vc.isComment = YES;
            vc.mid = cell.model.moment_status.id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([cell.model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        // 评论的数量
        if (cell.model.moment_choicest_article.comment_count == 0) {
            // 评论的数量为O时
            self.midString = cell.model.moment_choicest_article.id;
            [self.textInputViewWithOutImage.inputtextView becomeFirstResponder];
        }else {
            WQEssenceDetailController *vc = [[WQEssenceDetailController alloc] init];
            vc.isComment = YES;
            vc.model = cell.model.moment_choicest_article;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)wqSharBtnClick:(WQdynamicToobarView *)yoobarView cell:(WQdynamicTableViewCell *)cell {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
    self.type = cell.model.moment_type;
    self.articleModel = cell.model.moment_choicest_article;
    self.moment_statusModel = cell.model.moment_status;
    // 分享的响应事件
    __weak typeof(self) weakSelf = self;
    //显示分享面板
    [WQSingleton sharedManager].platname = @"NORMAL";
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
            // 万圈状态
            if ([self.type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
                pasteboard.string = [[BASE_URL_STRING stringByAppendingString:@"front/momentStatus/momentStatusH5Show?&mid="] stringByAppendingString:self.moment_statusModel.id];
            }else if ([self.type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
                // 精选状态
                pasteboard.string = [NSString stringWithFormat:@"%@front/choicest/articleh5show?choicest_id=%@",BASE_URL_STRING,self.articleModel.essenceId.length ? self.articleModel.essenceId : @"8feb4a1d891943aeb0d382269602ea2f"];
            }
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"已复制至剪切板" andAnimated:YES andTime:1];

        }
    }];
}

- (void)wqCaiBtnClick:(WQdynamicToobarView *)toobarView cell:(WQdynamicTableViewCell *)cell {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
    // 踩的响应事件
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urlString = @"api/moment/status/likeordislike";
    params[@"mid"] = cell.model.moment_status.id;
    params[@"like"] = @"false";
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

            cell.model.moment_status.dislike_count++;
            [ghTableView reloadData];
        }else {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
        }
    }];
}
#pragma 三个点
- (void)wqBtnsClick:(WQdynamicToobarView *)toobarView cell:(WQdynamicTableViewCell *)cell {
    // 三个点的响应事件
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }else{
        self.type = cell.model.moment_type;
        // 万圈状态
        if ([cell.model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
            self.midString = cell.model.moment_status.id;
        } else if ([cell.model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
            // 精选状态
            self.midString = cell.model.moment_choicest_article.id;
        }
        WQActionSheet *actionSheet = [[WQActionSheet alloc]initWithTitles:toobarView.nameArray];
        actionSheet.delegate = self;
        actionSheet.dynamicCell = cell;
        [actionSheet show];
    }
}
#pragma mark - **************** 鼓励，举报  踩

- (void)clickedButton:(WQActionSheet *)sheetView ClickedName:(NSString *)name
{
    if ([name isEqualToString:@"鼓励"]){
        [self wqEencourageBtnClick:nil cell:sheetView.dynamicCell];
    }else if ([name isEqualToString:@"举报"]){
        WQfeedbackViewController *vc = [[WQfeedbackViewController alloc] init];
        vc.feedbackType = TYPE_MOMENT;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([name isEqualToString:@"踩"]){
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要踩这条动态吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"确定踩"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             [self wqCaiBtnClick:nil cell:sheetView.dynamicCell];
                                                             
                                                         }];
        [alert addAction:confirm];
        [alert addAction:cancle];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if ([name isEqualToString:@"我的动态"]) {//我的动态
        WQHomdScreeningViewController *vc = [[WQHomdScreeningViewController alloc] init];
        vc.isMyDynamic = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([name isEqualToString:@"我参与的"]){//我参与的
        WQHomdScreeningViewController *vc = [[WQHomdScreeningViewController alloc] init];
        vc.isMyDynamic = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}







- (void)wqEencourageBtnClick:(WQdynamicToobarView *)toobarView cell:(WQdynamicTableViewCell *)cell {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    // 鼓励的响应事件
    self.popupWindowEncourageView.hidden = NO;
    self.type = cell.model.moment_type;
    // 万圈状态
    if ([cell.model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        self.midString = cell.model.moment_status.id;
    } else if ([cell.model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        // 精选状态
        self.midString = cell.model.moment_choicest_article.id;
    }
    [self.popupWindowEncourageView.moneyTextField becomeFirstResponder];
}

#pragma mark -- WQPeopleWhoAreInterestedInTableViewCellDelegate
- (void)wqGuanzhuBtnTouristsClick:(WQPeopleWhoAreInterestedInTableViewCell *)cell {
    [self showLogin];
}

- (void)wqHeadPortraitClick:(WQPeopleWhoAreInterestedInTableViewCell *)cell {
    [self showLogin];
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WQdynamicHomeModel *model = self.dataArray[indexPath.row];
    // 万圈动态
    if ([model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        WQdynamicDetailsViewConroller *vc = [[WQdynamicDetailsViewConroller alloc] init];
        
        [vc setLikeBlock:^{
            [self loadNewDeals];
        }];
        
        vc.isComment = NO;
        vc.mid = model.moment_status.id;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        WQEssenceDetailController *vc = [[WQEssenceDetailController alloc] init];
        vc.isComment = NO;
        vc.model = model.moment_choicest_article;
        [self.navigationController pushViewController:vc animated:YES];
        
        [vc setFavSuccessBlock:^{
            [self loadList];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        WQPeopleWhoAreInterestedInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:interestedInIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        tableView.rowHeight = 202;
        NSMutableArray *arrayM = [NSMutableArray array];
        if (self.dataArray.count) {
            WQdynamicHomeModel *model = self.dataArray[2];
            for (WQPeopleWhoAreInterestedInModel *interestedInModel in model.moment_users) {
                [arrayM addObject:interestedInModel];
            }
            cell.dataArray = arrayM.copy;
        }
        return cell;
    }else {
//        WQdynamicTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        if (cell == nil) {
//            cell = [[WQdynamicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        }
        WQdynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        tableView.rowHeight = UITableViewAutomaticDimension;
        cell.delegate = self;
        
        cell.dynamicContentView.picImageview.image = nil;
        cell.dynamicContentView.imageView.image = nil;
        if (self.dataArray.count) {
            cell.model = self.dataArray[indexPath.row];
        }
        
        return cell;
    }
}

#pragma mark -- leftBarBtn响应事件
- (void)leftBarBtnClick {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
    WQActionSheet *ActionSheet = [[WQActionSheet alloc]initWithTitles:@[@"我的动态",@"我参与的"]];
    ActionSheet.delegate =self;
    [ActionSheet show];

}





#pragma mark -- rightBarBtn响应事件
- (void)rightBarBtnClick {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
    WQdynamicSearchViewController *vc = [[WQdynamicSearchViewController alloc] init];
    WQRelationsCircleSearchNvc *nav = [[WQRelationsCircleSearchNvc alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showLogin {
    [self.view bringSubviewToFront:loginPopupWindow];
    loginPopupWindow.hidden = NO;
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(kScaleX(200));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
        self.tabBarController.tabBar.hidden = YES;
    }];
}

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
    WQLogInController *vc = [[WQLogInController alloc] initWithTouristLoginStatus:regist];
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

#pragma mark -- 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark -- dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- 分享
- (void)shareWithPlatformType:(UMSocialPlatformType)platformType shareTypeIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    
    [SVProgressHUD show];
    
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
    // 万圈状态
    if ([self.type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象
        NSString *imageUrl;
        if (self.moment_statusModel.pic.count) {
            imageUrl = [imageUrlString stringByAppendingString:self.moment_statusModel.pic.firstObject];
        }else {
            imageUrl = @"https://wanquan.belightinnovation.com/metronic_v4.5.2/theme/assets/pages/img/admin-logo.png";
        }
        NSString *titleString = @"万圈动态 - 关注校友最新动态";
        NSString *contentString;
        if (self.moment_statusModel.content.length) {
            contentString = self.moment_statusModel.content;
        }else {
            contentString = @"您的好友发表了图片和链接,进入查看详情";
        }
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleString descr:contentString           thumImage:imageUrl];
        //设置网页地址
        shareObject.webpageUrl = [[BASE_URL_STRING stringByAppendingString:@"front/momentStatus/momentStatusH5Show?&mid="] stringByAppendingString:self.moment_statusModel.id];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType
                                            messageObject:messageObject
                                    currentViewController:self completion:^(id data, NSError *error) {
                                        [SVProgressHUD dismiss];
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
    }else if ([self.type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        // 精选状态
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象
        NSString *thumbURL = WEB_IMAGE_LARGE_URLSTRING(self.articleModel.essenceCover);
        NSString *titleString = [NSString stringWithFormat:@"万圈精选 - %@",self.articleModel.essenceSubject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleString
                                                                                 descr:self.articleModel.essenceDesc
                                                                             thumImage:thumbURL];
        
        //设置网页地址
        shareObject.webpageUrl = [NSString stringWithFormat:@"%@front/choicest/articleh5show?choicest_id=%@",BASE_URL_STRING,self.articleModel.essenceId.length ? self.articleModel.essenceId : @"8feb4a1d891943aeb0d382269602ea2f"];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType
                                            messageObject:messageObject
                                    currentViewController:self completion:^(id data, NSError *error) {
                                        
                                        [SVProgressHUD dismiss];
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

@end
