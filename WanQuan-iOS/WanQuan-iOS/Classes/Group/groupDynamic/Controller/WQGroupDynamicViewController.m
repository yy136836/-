//
//  WQGroupDynamicViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupDynamicViewController.h"
#import "WQGroupInformationHeaderView.h"
#import "WQGroupDynamicTableViewCell.h"
#import "WQAddTopicController.h"
#import "WQTopicDetailController.h"
#import "WQAddneedController.h"
#import "WQGroupDemandForDetailsViewController.h"
#import "WQShareFriendListController.h"
#import "WQGroupDynamicHomeModel.h"
#import "WQGroupInformationViewController.h"
#import "WQUserProfileController.h"
#import "WQGroupMembersController.h"
#import "UMSocialUIManager.h"
#import "UMSocialSinaHandler.h"
#import "WQThemeImageView.h"
#import "WQThemeImageCollectionViewCell.h"
#import "WQGroupSharPopupWindowView.h"
#import "WQShowGroupInputView.h"
#import "WQGroupDynamicVisitorsLoginView.h"
#import "WQGroupDynamicNavView.h"
#import "WQTopicArticleController.h"
#import "WQGroupShareController.h"
#import "WQShareInvitationCodeController.h"
#import "WQPlacedTopTableViewCell.h"
#import "WQGroupActivitiesDetailsViewController.h"
#import "WQGroupBaseInfo.h"
#import "WQTopicStickOrDeleteController.h"

static NSString *identifier = @"identifier";
static NSString *cellid = @"twoIdentifier";

@interface WQGroupDynamicViewController () <UITableViewDelegate ,UITableViewDataSource,UIGestureRecognizerDelegate,UIScrollViewDelegate,UIPopoverPresentationControllerDelegate,AwesomeMenuDelegate,WQGroupInformationHeaderViewDelegate,WQGroupDynamicTableViewCellDelegate,WQGroupSharPopupWindowViewDelegate,WQShowGroupInputViewDelegate,WQGroupShareControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
// 头部试图
@property (nonatomic, strong) WQGroupInformationHeaderView *headerView;
// 添加分享菜单默认隐藏
@property (nonatomic, strong) WQGroupSharPopupWindowView *groupSharPopupWindowView;
@property (nonatomic, strong) WQShowGroupInputView *showGroupInputView;
@property (nonatomic, strong) WQGroupDynamicVisitorsLoginView *groupDynamicVisitorsLoginView;
@property (nonatomic, strong) WQGroupDynamicNavView *navView;
@property (nonatomic, strong) AwesomeMenu *menu;
// 群介绍
@property (nonatomic, copy) NSString *groupIntroduce;
@property (nonatomic, assign) NSInteger start;

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, strong) id response;

/**
 invite_code true string 邀请码
 invite_disable true boolean 是否禁用邀请码
 */
@property (nonatomic, retain) WQGroupBaseInfo * baseInfo;

@property (nonatomic, retain)WQGroupShareController * popOverVC;

/**
 置顶的标题
 */
@property (nonatomic, strong) NSMutableArray *topSubjectMarrAy;

@property (nonatomic, strong) NSMutableArray *topModelMarray;

@end

@implementation WQGroupDynamicViewController {
    UITableView *ghTableView;
    // 不是置顶的模型数组
    NSMutableArray *listModelMarrAy;
    NSMutableArray *typeMarray;
    NSMutableArray *gaidMarray;
    WQLoadingView *loadingView;
    WQLoadingError *loadingError;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationItem.title = @"圈主页";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem *rightBusinessCardBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"quanziqunmingpian"] style:UIBarButtonItemStylePlain target:self action:@selector(headerViewTapGes)];
    // 两个按钮的间距
    rightBusinessCardBtn.imageInsets = UIEdgeInsetsMake(0, 0, 0, -22);
    UIBarButtonItem *rightSharBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenxiangqunmingpian"] style:UIBarButtonItemStylePlain target:self action:@selector(sharBarBtnClike:)];
    self.navigationItem.rightBarButtonItems = @[rightSharBtn,rightBusinessCardBtn];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self setNeedsStatusBarAppearanceUpdate];
  
    NSInteger i = ghTableView.contentOffset.y;
    if (i >= 100) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x333333]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName : [UIColor colorWithHex:0x333333] }];
        self.navigationItem.title = @"圈主页";
        WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
        UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = left;
    }else {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0xffffff]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName : [UIColor colorWithHex:0xffffff] }];
        self.navigationItem.title = @"圈主页";
        WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
        UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = left;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self loadGroupIntroduce];
    // 添加AwesomeMenu按钮
    [self setupAwesomeMenu];
    gaidMarray = [NSMutableArray array];
    typeMarray = [NSMutableArray array];
    self.topModelMarray = [NSMutableArray array];
    _dataArray = @[].mutableCopy;
//    topSubjectMarrAy = [NSMutableArray array];
    listModelMarrAy = [NSMutableArray array];
    //topGidMarrAy = [NSMutableArray array];
    
    [self setupNavView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMenuAlpha) name:WQmenuHidden object:nil];
}

#pragma mark -- 设置发布按钮透明度
- (void)setMenuAlpha {
    self.menu.alpha = 0.95;
}

#pragma mark -- 自定义导航栏
- (void)setupNavView {
    WQGroupDynamicNavView *navview = [[WQGroupDynamicNavView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    navview.alpha = 0;
    self.navView = navview;
    [self.view addSubview:navview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 如果需要竖着滑动生效.横着不生效
    if (ABS(scrollView.contentOffset.x) > ABS(scrollView.contentOffset.y)) {
        return;
    }
    
    YHValue resValue = YHValueMake(1, 0);
    YHValue conValue = YHValueMake(kScaleX(140), 64);
    self.navView.alpha = [NSObject resultWithConsult:scrollView.contentOffset.y andResultValue:resValue andConsultValue:conValue];

    NSInteger i = scrollView.contentOffset.y;
    if (i >= 100) {
        self.navigationItem.title = self.titleString;
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x333333]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName : [UIColor colorWithHex:0x333333] }];
        WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
        UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationItem.leftBarButtonItem = left;
    }else {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0xffffff]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName : [UIColor colorWithHex:0xffffff] }];
        self.navigationItem.title = @"圈主页";
        WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
        UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = left;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark -- 请求数据
- (void)loadList {
    NSString *urlString = @"api/group/querygrouptimeline";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"gid"] = self.gid;
    params[@"geo_lat"] = @([WQLocationManager defaultLocationManager].currentLocation.coordinate.latitude).description;
    params[@"geo_lng"] = @([WQLocationManager defaultLocationManager].currentLocation.coordinate.longitude).description;
    params[@"limit"] = @(20).description;
    params[@"start"] = @(self.start).description;
    params[@"act"] = @"true";

    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        
        if (ghTableView.mj_footer.isRefreshing) {
            [ghTableView.mj_footer endRefreshing];
        }
        if (ghTableView.mj_header.isRefreshing) {
            [ghTableView.mj_header endRefreshing];
        }
        
        if (error) {
            NSLog(@"%@",error);
            [loadingView dismiss];
            [loadingError show];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        
        if ([response[@"success"] boolValue]) {
            self.response = response;
            if (!_start) {
                [self.dataArray removeAllObjects];
            }
            
            if ((![response[@"list"] count]) || ((!_start )&& ([response[@"list"] count]!= 20))) {
                [ghTableView.mj_footer setState:MJRefreshStateNoMoreData];
            }
            
            NSArray * newData = response[@"list"];
            if (!newData.count) {
                [ghTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.dataArray addObjectsFromArray: [NSArray yy_modelArrayWithClass:[WQGroupDynamicHomeModel class]  json:response[@"list"]]];
            
            [self.topSubjectMarrAy removeAllObjects];
            [listModelMarrAy removeAllObjects];
            for (WQGroupDynamicHomeModel *model in self.dataArray) {
                // 是置顶
                if (model.isTop) {
                    [self.topModelMarray addObject:model];
                    
                    if (model.gaid.length) {
                        [gaidMarray addObject:model.gaid];
                    }else {
                        [gaidMarray addObject:@""];
                    }
                    [typeMarray addObject:model.type];
                    if ([model.type isEqualToString:@"TYPE_TOPIC"]) {
                        // 是主题
                        [self.topSubjectMarrAy addObject:model.subject];
                    }else if ([model.type isEqualToString:@"TYPE_ACTIVITY"]) {
                        // 是活动
                        [self.topSubjectMarrAy addObject:model.title];
//                        [self.topModelMarray addObject:model];
                    }else if ([model.type isEqualToString:@"TYPE_NEED"]){
                        // 是需求
                        [self.topSubjectMarrAy addObject:model.need_subject];
                    }
                    // 不是主题
//                    if (![model.type isEqualToString:@"TYPE_TOPIC"]) {
//                        [self.topSubjectMarrAy addObject:model.need_subject];
//                    }else if ([model.type isEqualToString:@"TYPE_ACTIVITY"]) {
//                        //  活动
//                        [self.topSubjectMarrAy addObject:model.title];
//                    }else {
//                        [self.topSubjectMarrAy addObject:model.subject];
//                    }
                }else {
                    [listModelMarrAy addObject:model];
                }
            }
            
            // 设置组的头像
            NSURL * imageURL = [NSURL URLWithString:WEB_IMAGE_HUGE_URLSTRING(response[@"pic"])];
            [[YYWebImageManager sharedManager] requestImageWithURL:imageURL options:YYWebImageOptionShowNetworkActivity progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                if (image) {
                    UIImage * blur = [image GPUImageBlur];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.headerView.groupBackgroundHeadPortraitImageView.image = blur;
                    });
                }
            }];
            [self.headerView.groupHeadPortraitImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_HUGE_URLSTRING(response[@"pic"])] options:YYWebImageOptionShowNetworkActivity];
            // 组名
            self.headerView.groupNameLabel.text = [NSString stringWithFormat:@"%@",response[@"name"]];
            self.titleString = [NSString stringWithFormat:@"%@",response[@"name"]];
            // 群主名
            self.headerView.groupManagerNamelLabel.text = [@"圈主: " stringByAppendingString: [NSString stringWithFormat:@"%@",response[@"owner_name"]] ];
            // 群人数
            self.headerView.numberLabel.text = [@"圈成员人数: " stringByAppendingString:[NSString stringWithFormat:@"%@",response[@"member_count"]]];
            
            if (self.dataArray.count) {
                if (listModelMarrAy.count) {
                    [ghTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(self.view);
                    }];
                }
                ghTableView.scrollEnabled = YES;
            }else {
                [ghTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.right.equalTo(self.view);
                    make.height.equalTo(@204);
                }];
                self.groupDynamicVisitorsLoginView.hidden = NO;
                [self.groupDynamicVisitorsLoginView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(ghTableView.mas_bottom);
                    make.bottom.right.left.equalTo(self.view);
                }];
                ghTableView.scrollEnabled = NO;
            }
            [ghTableView reloadData];
            [loadingView dismiss];
            [loadingError dismiss];
        }
    }];
}

- (void)loadGroupIntroduce {
    NSString *urlString = @"api/group/getgroupinfo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"gid"] = self.gid;
    
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        _baseInfo = [WQGroupBaseInfo yy_modelWithJSON:response];
        
        NSLog(@"%@",response);
        self.groupIntroduce = response[@"description"];
        
    }];
}

#pragma mark -- 初始化TableView
- (void)setupTableView {
    self.view.backgroundColor = [UIColor colorWithHex:0xededed];
    
    ghTableView = [[UITableView alloc] init];
    // 设置tableview的边距
    ghTableView.backgroundColor = [UIColor colorWithHex:0xededed];
    // 设置代理对象
    ghTableView.delegate = self;
    ghTableView.dataSource = self;
    // 设置自动行高和预估行高
    ghTableView.rowHeight = UITableViewAutomaticDimension;
    ghTableView.estimatedRowHeight = 250;
    if (@available(iOS 11.0,*)) {
        ghTableView.estimatedSectionHeaderHeight = 0;
        ghTableView.estimatedSectionFooterHeight = 0;
        ghTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    // 取消分割线&滚动条
    ghTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ghTableView.showsVerticalScrollIndicator = NO;
    // 注册cell
    [ghTableView registerClass:[WQGroupDynamicTableViewCell class] forCellReuseIdentifier:identifier];
    [ghTableView registerClass:[WQPlacedTopTableViewCell class] forCellReuseIdentifier:cellid];
    if (@available(iOS 11.0, *)) {
        ghTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // 设置头部试图
    WQGroupInformationHeaderView *headerView = [[WQGroupInformationHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScaleX(204))];
    headerView.delegate = self;
    self.headerView = headerView;
    ghTableView.tableHeaderView = headerView;
    [self.view addSubview:ghTableView];
    [ghTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    WQGroupDynamicVisitorsLoginView *groupDynamicVisitorsLoginView = [[WQGroupDynamicVisitorsLoginView alloc] init];
    self.groupDynamicVisitorsLoginView.hidden = YES;
    self.groupDynamicVisitorsLoginView = groupDynamicVisitorsLoginView;
    [self.view addSubview:groupDynamicVisitorsLoginView];
    [groupDynamicVisitorsLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0);
        make.bottom.right.left.equalTo(self.view);
    }];
    
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDynamic)];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor blackColor];
    header.lastUpdatedTimeLabel.hidden = YES;
    
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
    MJRefreshAutoNormalFooter *freshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDynamic)];
    // 设置文字
    [freshFooter setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    [freshFooter setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [freshFooter setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    // 设置字体
    freshFooter.stateLabel.textColor = HEX(0x999999);
    freshFooter.stateLabel.textAlignment = NSTextAlignmentCenter;
    // 设置字体
    freshFooter.stateLabel.font = [UIFont systemFontOfSize:16];
    ghTableView.mj_footer = freshFooter;
    
    // 添加分享菜单默认隐藏
    WQGroupSharPopupWindowView *groupSharPopupWindowView = [[WQGroupSharPopupWindowView alloc] init];
    self.groupSharPopupWindowView = groupSharPopupWindowView;
    groupSharPopupWindowView.hidden = YES;
    groupSharPopupWindowView.isWQGroupDynamicVC = YES;
    groupSharPopupWindowView.delegate = self;
    [self.view addSubview:groupSharPopupWindowView];
    [groupSharPopupWindowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
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
        [weakSelf refreshDynamic];
    }];
    [loadingError dismiss];
    [self.view addSubview:loadingError];
    [loadingError mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    // 加载数据
    [self loadList];
}

// 圈名片的Barbtn点击事件
- (void)headerViewTapGes {
    WQGroupInformationViewController *vc = [[WQGroupInformationViewController alloc] init];
    vc.gid = self.gid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma make - AwesomeMenu按钮
- (void)setupAwesomeMenu {
    //中间的startItem
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc]
                                  initWithImage:[UIImage imageNamed:@"fabuanniuchenghaoyouquan"]
                                  highlightedImage:[UIImage imageNamed:@"quanzifabuanniuzhankai"]
                                  ContentImage:[UIImage imageNamed:@"fabuanniuchenghaoyouquan"]
                                  highlightedContentImage:[UIImage imageNamed:@"fabuanniuchenghaoyouquan"]];
    
    //添加其他几个按钮
    AwesomeMenuItem *item0 = [[AwesomeMenuItem alloc]
                              initWithImage:[UIImage imageNamed:@"quanzizhutianniu"]
                              highlightedImage:nil
                              ContentImage:[UIImage imageNamed:@"quanzizhutianniu"]
                              highlightedContentImage:[UIImage imageNamed:@"quanzizhutianniu"]];
    
    AwesomeMenuItem *item1 = [[AwesomeMenuItem alloc]
                              initWithImage:[UIImage imageNamed:@"quanzixuqiuanniu"]
                              highlightedImage:nil
                              ContentImage:[UIImage imageNamed:@"quanzixuqiuanniu"]
                              highlightedContentImage:[UIImage imageNamed:@"quanzixuqiuanniu"]];
    
    NSArray *items = @[item0, item1];
    
    //创建菜单按钮
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem menuItems:items];
    self.menu = menu;
    [self.view addSubview:menu];
    
    //禁止转动
    menu.rotateAddButton = NO;
    //弹出范围
    menu.menuWholeAngle = -1;
    menu.farRadius = 100.0f;
    menu.endRadius = 100.0f;
    menu.nearRadius = 80.0f;
    //设置约束
    menu.startPoint = CGPointMake(0, 0);
    
    [menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-50);
        make.bottom.equalTo(self.view).offset(kScaleX(-55));
    }];
    
    //设置代理对象
    menu.delegate = self;
    
    //设置透明度
    menu.alpha = 0.95;
}

#pragma make - AwesomeMenu按钮Delegate
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx {
    switch (idx) {
        case 0:{
            WQAddTopicController *vc = [[WQAddTopicController alloc] init];
            vc.gid = self.gid;
            
            [vc setReleaseSuccessBlock:^{
                [self loadList];
                if (self.topSubjectMarrAy.count) {
                    [ghTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }else {
                    if (listModelMarrAy.count) {
                        [ghTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    }else {
                        return ;
                    }
                }
            }];
            
            [self.navigationController
             wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
                 transition.animationType =  WXSTransitionAnimationTypePointSpreadPresent;
                 transition.animationTime = 1;
                 transition.backGestureEnable = NO;
             }];
        }
            break;
        case 1:{
            WQAddneedController *vc = [[WQAddneedController alloc] init];
            vc.gid = self.gid;
            vc.type = NeedControllerTypeGroup;
            [self.navigationController
             wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
                 transition.animationType =  WXSTransitionAnimationTypePointSpreadPresent;
                 transition.animationTime = 1;
                 transition.backGestureEnable = NO;
             }];
        }
            break;
            
        default:
            break;
    }
}
- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu {
    //切换图像
    menu.contentImage = [UIImage imageNamed:@"Slice"];
    //更改透明度
    [UIView animateWithDuration:.25 animations:^{
        menu.alpha = 0.8;
    }];
}
- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu {
    //切换图像
    menu.contentImage = [UIImage imageNamed:@"fabu"];
    //更改透明度
    [UIView animateWithDuration:.25 animations:^{
        menu.alpha = 0.8;
    }];
}

#pragma mark -- WQGroupInformationHeaderViewDelegate
- (void)wqHeadPortraitImageViewClike:(WQGroupInformationHeaderView *)headerView {
    WQGroupInformationViewController *vc = [[WQGroupInformationViewController alloc] init];
    vc.gid = self.gid;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)wqNumberLabelClike:(WQGroupInformationHeaderView *)headerView {
    WQGroupMembersController *vc = [[WQGroupMembersController alloc] init];
    vc.gid = self.gid;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)wqGroupManagerNamelLabelTap:(WQGroupInformationHeaderView *)headerView {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    // 是自己
    if ([self.response[@"owner_id"] isEqualToString:im_namelogin]) {
        WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:self.response[@"owner_id"]];

        [self.navigationController pushViewController:vc animated:YES];
    }else {
        // 不是自己
        WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:self.response[@"owner_id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -- WQGroupDynamicTableViewCellDelegate
- (void)wqGroupDynamicTableViewCellHeadPortraitCliek:(WQGroupDynamicTableViewCell *)groupDynamicTableViewCell {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    // 是自己
    if ([groupDynamicTableViewCell.model.user_id isEqualToString:im_namelogin]) {
        WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:groupDynamicTableViewCell.model.user_id];

        [self.navigationController pushViewController:vc animated:YES];
    }else {
        // 不是自己
        WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:groupDynamicTableViewCell.model.user_id];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)wqLinksContentViewClick:(WQGroupDynamicTableViewCell *)groupDynamicTableViewCell {
    WQTopicArticleController *vc = [[WQTopicArticleController alloc] init];
    vc.URLString = groupDynamicTableViewCell.model.link_url;
    vc.NavTitle = groupDynamicTableViewCell.model.link_txt;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wqActlvltyViewClick:(WQGroupDynamicTableViewCell *)groupDynamicTableViewCell {
    if ([groupDynamicTableViewCell.model.type isEqualToString:@"TYPE_ACTIVITY"]) {
        WQGroupActivitiesDetailsViewController *vc = [[WQGroupActivitiesDetailsViewController alloc] init];
        vc.urlString = [[[[BASE_URL_STRING stringByAppendingString:@"front/activity/h5show?secretkey="] stringByAppendingString:[WQDataSource sharedTool].secretkey] stringByAppendingString:@"&activity_id="] stringByAppendingString:groupDynamicTableViewCell.model.gaid];
        vc.shareUrl = [NSString stringWithFormat:@"%@front/activity/h5show?activity_id=%@",BASE_URL_STRING,groupDynamicTableViewCell.model.gaid] ;
        vc.isAdmin = [self.response[@"isAdmin"] boolValue];
        vc.isTop = groupDynamicTableViewCell.model.isTop;
        vc.gaid = groupDynamicTableViewCell.model.gaid;
        vc.pic = groupDynamicTableViewCell.model.cover_pic_id;
        vc.title = groupDynamicTableViewCell.model.title;
        vc.addr = groupDynamicTableViewCell.model.addr;
        vc.time = groupDynamicTableViewCell.model.time;
        
        // 置顶 | 取消置顶成功
        [vc setSettopSuccessBlock:^{
            [self refreshDynamic];
        }];
        
        // 删除活动成功
        [vc setDeleteSuccessBlock:^{
            [self refreshDynamic];
        }];
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark -- UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WQGroupDynamicHomeModel *model = self.dataArray[indexPath.row];
    if (indexPath.section == 0) {
        // 置顶的活动
        if ([model.type isEqualToString:@"TYPE_ACTIVITY"]) {
            WQGroupActivitiesDetailsViewController *vc = [[WQGroupActivitiesDetailsViewController alloc] init];
            NSString *gaid = gaidMarray[indexPath.row];
            vc.urlString = [[[[BASE_URL_STRING stringByAppendingString:@"front/activity/h5show?secretkey="] stringByAppendingString:[WQDataSource sharedTool].secretkey] stringByAppendingString:@"&activity_id="] stringByAppendingString:gaid];
            vc.shareUrl = [NSString stringWithFormat:@"%@front/activity/h5show?activity_id=%@",BASE_URL_STRING,model.gaid] ;
            vc.isAdmin = [self.response[@"isAdmin"] boolValue];
            vc.isTop = YES;
            vc.gaid = gaid;
            WQGroupDynamicHomeModel *model = self.topModelMarray[indexPath.row];
            vc.pic = model.cover_pic_id;
            vc.title = model.title;
            vc.addr = model.addr;
            vc.time = model.time;
            // 置顶 | 取消置顶成功
            [vc setSettopSuccessBlock:^{
                [self refreshDynamic];
            }];
            
            // 删除活动成功
            [vc setDeleteSuccessBlock:^{
                [self refreshDynamic];
            }];
            
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        if ([model.type isEqualToString:@"TYPE_NEED"]) {
            WQGroupDemandForDetailsViewController *vc = [[WQGroupDemandForDetailsViewController alloc] init];
            
            // 群主成功删除需求,刷新数据
            [vc setNeedsDeleteSuccessfulBlock:^{
                [self refreshDynamic];
            }];
            
            [vc setSettopSuccessBlock:^{
                [self refreshDynamic];
            }];
            vc.isTop = YES;
            vc.gnid = model.gnid;
            vc.needId = model.need_id;
            if ([self.response[@"isAdmin"] boolValue] || [self.response[@"isOwner"] boolValue]) {
                vc.isGroupManager = YES;
            }else {
                vc.isGroupManager = NO;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            
            WQTopicDetailController *vc = [[WQTopicDetailController alloc] init];
            // 置顶获取取消置顶成功
            [vc setTopSuccessfulBlock:^{
                [self refreshDynamic];
            }];
            // 删除主题成功
            [vc setDeleteSuccessfulBlock:^{
                [self refreshDynamic];
            }];
            
            vc.tid = model.id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        WQGroupDynamicHomeModel *homeModel = listModelMarrAy[indexPath.row];
        
        // 活动
        if ([homeModel.type isEqualToString:@"TYPE_ACTIVITY"]) {
            WQGroupActivitiesDetailsViewController *vc = [[WQGroupActivitiesDetailsViewController alloc] init];
            
            vc.urlString = [[[[BASE_URL_STRING stringByAppendingString:@"front/activity/h5show?secretkey="] stringByAppendingString:[WQDataSource sharedTool].secretkey] stringByAppendingString:@"&activity_id="] stringByAppendingString:homeModel.gaid];
            vc.shareUrl = [NSString stringWithFormat:@"%@front/activity/h5show?activity_id=%@",BASE_URL_STRING,homeModel.gaid] ;
            vc.isAdmin = [self.response[@"isAdmin"] boolValue];
            vc.isTop = homeModel.isTop;
            vc.gaid = homeModel.gaid;
            WQGroupDynamicHomeModel *model = listModelMarrAy[indexPath.row];
            vc.pic = model.cover_pic_id;
            vc.title = model.title;
            vc.addr = model.addr;
            vc.time = model.time;
            
            // 置顶 | 取消置顶成功
            [vc setSettopSuccessBlock:^{
                [self refreshDynamic];
            }];
            
            // 删除活动成功
            [vc setDeleteSuccessBlock:^{
                [self refreshDynamic];
            }];
            
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        if ([homeModel.type isEqualToString:@"TYPE_NEED"]) {
            WQGroupDemandForDetailsViewController *vc = [[WQGroupDemandForDetailsViewController alloc] init];
            
            // 群主成功删除需求,刷新数据
            [vc setNeedsDeleteSuccessfulBlock:^{
                [self refreshDynamic];
            }];
            
            [vc setSettopSuccessBlock:^{
                [self refreshDynamic];
            }];
            vc.isTop = NO;
            vc.gnid = homeModel.gnid;
            vc.needId = homeModel.need_id;
            if ([self.response[@"isAdmin"] boolValue] || [self.response[@"isOwner"] boolValue]) {
                vc.isGroupManager = YES;
            }else {
                vc.isGroupManager = NO;
            }

            [self.navigationController pushViewController:vc animated:YES];
        }else {
            WQTopicDetailController *vc = [[WQTopicDetailController alloc] init];
            // 置顶获取取消置顶成功
            [vc setTopSuccessfulBlock:^{
                [self refreshDynamic];
            }];
            // 删除主题成功
            [vc setDeleteSuccessfulBlock:^{
                [self refreshDynamic];
            }];
            
            vc.tid = homeModel.id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    }else {
         return UITableViewAutomaticDimension;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.topSubjectMarrAy.count;
    }else {
        return listModelMarrAy.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WQPlacedTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
        cell.subjectString = self.topSubjectMarrAy[indexPath.row];
        
        NSString *type = typeMarray[indexPath.row];
        if ([type isEqualToString:@"TYPE_TOPIC"]) {
            // 主题
            [cell.tagBtn setTitle:@"置顶\n主题" forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"TYPE_ACTIVITY"]) {
            // 活动
            [cell.tagBtn setTitle:@"置顶\n活动" forState:UIControlStateNormal];
        }else if ([type isEqualToString:@"TYPE_NEED"]){
            // 需求
            [cell.tagBtn setTitle:@"置顶\n需求" forState:UIControlStateNormal];
        }
        return cell;
    }else {
        WQGroupDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = listModelMarrAy[indexPath.row];
        // 防止复用,把图片设置为nil
        cell.picView.cell.picImageView.image = nil;
        cell.picView.picArray = cell.model.pic;
        NSMutableArray *picArray = [NSMutableArray array];
        if (cell.model.pic.count > 3) {
            for (NSInteger i = 0; i < cell.model.pic.count; i++) {
                if (i == 3) {
                    cell.picView.picArray = picArray;
                    break ;
                }
                [picArray addObject:cell.model.pic[i]];
            }
        }else {
            [picArray removeAllObjects];
            cell.picView.picArray = cell.model.pic;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return ghStatusCellMargin;
    }else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ghStatusCellMargin)];
        lineView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
        
        return lineView;
    }else {
        return [UIView new];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return @"";
    }else {
        return @" ";
    }
}

#pragma mark - 分享的按钮响应事件
- (void)sharBarBtnClike:(UIBarButtonItem *)sender {
//    _popOverVC = [WQGroupShareController new];
//
//    _popOverVC.modalPresentationStyle = UIModalPresentationPopover;
//    _popOverVC.popoverPresentationController.barButtonItem = sender;
//    _popOverVC.popoverPresentationController.delegate = self;
//    _popOverVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
//    _popOverVC.delegate = self;
    
    
    
//    TODOHanyang
    BOOL canShareInvitationCode = !_baseInfo.invite_disable;
    
    if (canShareInvitationCode) {
        [WQSingleton sharedManager].platname = @"WQHY_INVITE";
    } else {
        [WQSingleton sharedManager].platname = @"WQHY";
    }
    [self sharBtnClike];
    
}

// 分享至第三方
- (void)sharBtnClike{
    self.groupSharPopupWindowView.hidden = YES;
    // 第三方分享
#pragma mark - 友盟分享
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请注册/登录后查看更多" preferredStyle:UIAlertControllerStyleAlert];
        [self.navigationController.visibleViewController presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return ;
    }
    __weak typeof(self) weakSelf = self;
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        if(platformType == UMSocialPlatformType_Sina){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Sina shareTypeIndex:0];
        }else if(platformType == UMSocialPlatformType_Sms){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Sms shareTypeIndex:1];
        }else if (platformType == UMSocialPlatformType_QQ){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_QQ shareTypeIndex:2];
        }else if (platformType == UMSocialPlatformType_Qzone){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Qzone shareTypeIndex:3];
        }else if (platformType == UMSocialPlatformType_WechatSession){//
            [weakSelf shareWithPlatformType:UMSocialPlatformType_WechatSession shareTypeIndex:4];
        }else if (platformType == UMSocialPlatformType_WechatTimeLine){//
            [weakSelf shareWithPlatformType:UMSocialPlatformType_WechatTimeLine shareTypeIndex:5];
        }else if (platformType == WQCopyLink){//
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            NSString *copyLink = [NSString stringWithFormat:@"http://wanquan.belightinnovation.com/front/share/group?gid=%@",self.gid];
            pasteboard.string = copyLink;
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"已复制至剪切板" andAnimated:YES andTime:1];
        }else if (platformType == WQFriend){//万圈好友
            [self friendsBtnClike:nil];
        }else if (platformType == WQFriedd_INVITE){//邀请码
            [self groupShareControllerShareInvitationCode];
        }
    }];
}



#pragma mark -- WQShowGroupInputViewDelegate
// 弹窗的取消的点击事件
- (void)wqCancelBtnClike:(WQShowGroupInputView *)showGroupInputView {
    self.showGroupInputView.hidden = YES;
}
// 弹窗的提交的点击事件
- (void)wqSubmitBtnClike:(WQShowGroupInputView *)showGroupInputView {
    if (showGroupInputView.textView.text.length > 50) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请勿输入超50个字" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        return;
    }
    self.showGroupInputView.hidden = YES;
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在转发至万圈...."];
    NSString *urlString = @"api/moment/status/createstatus";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"content"] = self.showGroupInputView.textView.text;
    NSDictionary *dict = @{@"group_id":self.gid,@"group_pic":self.response[@"pic"],@"group_name":self.response[@"name"],@"group_desc":self.groupIntroduce};
    NSData *arrAypicData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    params[@"extras"] = [[NSString alloc] initWithData:arrAypicData encoding:NSUTF8StringEncoding];
    params[@"cate"] = @"CATE_GROUP";
    
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
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
            // [SVProgressHUD dismissWithDelay:0.2];
            [SVProgressHUD dismiss];
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"转发成功" preferredStyle:UIAlertControllerStyleAlert];
            
            [self.navigationController.visibleViewController presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }else {
            [SVProgressHUD showErrorWithStatus:@"请检查网络连接后重试"];
            [SVProgressHUD dismissWithDelay:1];
        }
    }];
}


#pragma mark - WQGroupShareController

/**
 给好友分享群
 */
- (void)groupShareControllerShareToFriend {
     [_popOverVC dismissViewControllerAnimated:NO completion:nil];
    [self friendsBtnClike:nil];
}

/**
 分享圈子至第三方
 */
- (void)groupShareControllerShareToThird {
     [_popOverVC dismissViewControllerAnimated:NO completion:nil];
    [self sharBtnClike:nil];
}

#pragma mark - 分享邀请码

/**
 分享邀请码
 */
- (void)groupShareControllerShareInvitationCode {
    
    WQShareInvitationCodeController * vc = [WQShareInvitationCodeController new];
    vc.baseinfo = _baseInfo;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.popoverPresentationController.delegate = self;
//    vc.delegate = self;
  //  [_popOverVC dismissViewControllerAnimated:NO completion:^{
        [self presentViewController:vc animated:YES completion:nil];
    //}];
    
}



#pragma mark - WQGroupSharPopupWindowViewDelegate
// 点击屏幕隐藏分享菜单
- (void)WQSharMenuViewHidden:(WQGroupSharPopupWindowView *)groupSharPopupWindowView {
    self.groupSharPopupWindowView.hidden = YES;
   
}
// 分享至万圈好友
- (void)friendsBtnClike:(WQGroupSharPopupWindowView *)groupSharPopupWindowView {
    WQShareFriendListController * vc = [[WQShareFriendListController alloc] init];
    vc.gid = self.gid;
    vc.groupModel = self.groupModel;
    
    [self.navigationController pushViewController:vc animated:YES];
}
// 分享至万圈
- (void)groupBtnClike:(WQGroupSharPopupWindowView *)groupSharPopupWindowView {
    self.groupSharPopupWindowView.hidden = YES;
    self.showGroupInputView.hidden = NO;
    CGRect popupWindowView = self.showGroupInputView.frame;
    popupWindowView.origin.y = self.view.bounds.origin.y - 50;
    popupWindowView.size.height = kScreenHeight;
    popupWindowView.size.width = kScreenWidth;
    [UIView animateWithDuration:0.5 animations:^{
        self.showGroupInputView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
        self.showGroupInputView.frame = popupWindowView;
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
    
    NSString *moneySplicecontent = [NSString stringWithFormat:@"%@",self.groupIntroduce];
    //创建网页内容对象
    NSString *thumbURL = @"https://wanquan.belightinnovation.com/metronic_v4.5.2/theme/assets/pages/img/admin-logo.png";
    NSString *str = @"我在圈子「";
    NSString *str1 = @"」一起加入吧！";
    NSString *titleString = [str stringByAppendingString:[[NSString stringWithFormat:@"%@",self.response[@"name"]] stringByAppendingString:str1]];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleString descr:moneySplicecontent thumImage:thumbURL];
    
    //设置网页地址
    NSString *shardString = @"http://wanquan.belightinnovation.com/front/share/group?gid=";
    shareObject.webpageUrl = [shardString stringByAppendingString:[NSString stringWithFormat:@"%@",self.gid]];
    
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

- (void)loadMoreDynamic {
    _start = _dataArray.count;
    [self loadList];
}

- (void)refreshDynamic {
    _start = 0;
    [self loadList];
}

#pragma mark -- 懒加载
- (WQShowGroupInputView *)showGroupInputView {
    if (!_showGroupInputView) {
        _showGroupInputView = [[WQShowGroupInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0)];
        _showGroupInputView.backgroundColor = [UIColor colorWithHex:0Xb2b2b2];
        _showGroupInputView.delegate = self;
        [self.view addSubview:_showGroupInputView];
    }
    return _showGroupInputView;
}

- (NSMutableArray *)topSubjectMarrAy {
    if (!_topSubjectMarrAy) {
        _topSubjectMarrAy = [NSMutableArray array];
    }
    return _topSubjectMarrAy;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIPopoverPresentationControllerDelegate


// Called on the delegate when the popover controller will dismiss the popover. Return NO to prevent the
// dismissal of the view.
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    return YES;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

// -popoverPresentationController:willRepositionPopoverToRect:inView: is called on your delegate when the
// popover may require a different view or rectangle.
- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView  * __nonnull * __nonnull)view {
    
}


- (UIStatusBarStyle)preferredStatusBarStyle {

    
    YHValue resValue = YHValueMake(1, 0);
    YHValue conValue = YHValueMake(kScaleX(140), 64);
    
    NSInteger i = ghTableView.contentOffset.y;
    if (i >= 100) {
        return UIStatusBarStyleDefault;
    }else {
        return UIStatusBarStyleLightContent;
    }
}

@end
