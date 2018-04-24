//
//  WQSystemMessageController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQSystemMessageController.h"
#import "WQPushMessageTableViewCell.h"
#import "WQmessageHomeModel.h"
#import "WQTabBarController.h"
#import "WQUnreadMessageCenter.h"
#import "WQSystemMessageVisitorsLoginView.h"

static NSString *cellid = @"WQsystemMessageCollectionViewCellid";
@interface WQSystemMessageController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableArray *tableViewdetailOrderData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentPageCount;
@property (nonatomic, strong) WQSystemMessageVisitorsLoginView *systemMessageVisitorsLoginView;
@end
@implementation WQSystemMessageController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    self.navigationItem.title = @"系统消息";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
//    UIBarButtonItem *leftBarbtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector()];
//    self.navigationItem.leftBarButtonItem = leftBarbtn;
//    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;

}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
    [self pulldownrenovate];
    
    
    WQTabBarController * root = [[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[WQTabBarController class]]?[UIApplication sharedApplication].delegate.window.rootViewController:nil;
    
    if (root) {
        
        root.haveSystemInfoToDealWith = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WQShouldHideRedNotifacation object:nil];
    }
}

#pragma mark - 初始化UI
- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    // 设置自动行高
    tableView.rowHeight = UITableViewAutomaticDimension;
    // 设置预估行高
    tableView.estimatedRowHeight = 77;
    [tableView registerClass:[WQPushMessageTableViewCell class] forCellReuseIdentifier:cellid];
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
    
    WQSystemMessageVisitorsLoginView *systemMessageVisitorsLoginView = [[WQSystemMessageVisitorsLoginView alloc] init];
    self.systemMessageVisitorsLoginView = systemMessageVisitorsLoginView;
    systemMessageVisitorsLoginView.hidden = YES;
    [self.view addSubview:systemMessageVisitorsLoginView];
    [systemMessageVisitorsLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (void)pulldownrenovate {
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
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
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
}

#pragma mark 加载更多数据
- (void)loadMoreDeals {
    //    self.currentPage += 1;
    self.currentPageCount += 20;
    [self loadData];
}

#pragma mark - 请求数据
- (void)loadData {
    NSString *urlString = @"api/message/querysystemmessage";
    self.params[@"start_id"] = @(self.currentPage).description;
    self.params[@"count"] = @(self.currentPageCount).description;
    self.params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (self.currentPageCount != 20) {
                self.currentPageCount -= 20;
            }
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        
        self.tableViewdetailOrderData = [NSArray yy_modelArrayWithClass:[WQmessageHomeModel class] json:response[@"messages"]].mutableCopy;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.tableViewdetailOrderData.count < 1) {
            self.systemMessageVisitorsLoginView.hidden = NO;
        }else {
            [self.tableView reloadData];
            self.tableView.mj_footer.hidden = self.tableViewdetailOrderData.count >= 500000;
        }
    }];
}

#pragma mark - UITableViewDataSource
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 77;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewdetailOrderData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQPushMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.tableViewdetailOrderData[indexPath.row];
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

@end
