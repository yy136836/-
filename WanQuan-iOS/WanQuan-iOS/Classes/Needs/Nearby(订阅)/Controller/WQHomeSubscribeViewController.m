//
//  WQHomeSubscribeViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/1.
//  Copyright © 2016年 WQ. All rights reserved.
//


#import "WQHomeSubscribeViewController.h"
#import "WQorderViewController.h"
#import "WQUserProfileController.h"
#import "WQHomeNearbyTagModel.h"
#import "WQdetailsConrelooerViewController.h"
#import "WQAddneedController.h"
#import  <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "WQLogInController.h"
#import "WQHomeNearbyTableViewCell.h"

static NSString *cellID = @"cellid";


NSString * noLoginText          = @"\n\n订阅需求分类\n不要错过你关心的问题\n";
NSString * noSubscribeText      = @"\n\n订阅需求分类\n不错过擅长解答的问题\n";
NSString * noNeedText           = @"\n\n订阅的分类下暂时没有需求\n";


NSString * noLoginTitle         = @"立即登录";
NSString * noSubscribeTitle     = @"开始订阅";
NSString * noNeedTitle          = @"订阅更多";


@interface WQHomeSubscribeViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableDictionary *params;
@property(nonatomic,strong)NSMutableArray *tableViewdetailOrderData;
@property(nonatomic,assign)CLLocationCoordinate2D location;
/** 当前页码*/
@property (nonatomic)NSInteger currentPage;
@property (nonatomic)NSInteger currentPageCount;

@property (nonatomic, assign) BOOL haveSubscribe;

@end

@implementation WQHomeSubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
//    if ([role_id isEqualToString:@"200"]) {
//        //初始化游客登录UI
//        [self setupTouristUI];
//    }else{
        [self setupUI];
    if (![role_id isEqualToString:@"200"]) {
        
        [self pulldownrenovate];
    }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WQlongitudeuptodateNotifacation:) name:WQlongitudeuptodateNotifacation object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:WQorderReceivingsucceedin object:nil];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if (![role_id isEqualToString:@"200"]) {
        
        [self loadNewDeals];

    }

}

#pragma mark - 初始化游客登录UI
- (void)setupTouristUI {
    WQTouristView *touristView = [[WQTouristView alloc]init];
    
    [self.view addSubview:touristView];
    
    [touristView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 下拉刷新
- (void)pulldownrenovate {

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
    [header setImages:imageArray forState:MJRefreshStateIdle];
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    [header placeSubviews];
    self.tableView.mj_header = header;
    // 上拉加载
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
    // 设置文字
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    footer.stateLabel.textColor = HEX(0x999999);
    footer.stateLabel.textAlignment = NSTextAlignmentCenter;
    footer.stateLabel.font = [UIFont systemFontOfSize:16];
    self.tableView.mj_footer = footer;
   

    // 设置footer
    self.tableView.mj_footer = footer;
//     开始隐藏底部刷新
//    self.tableView.mj_footer.hidden = YES;
////    self.tableView.mj_header.hidden = YES;
}

#pragma mark 加载新数据
- (void)loadNewDeals {
    _tableView.mj_footer.hidden = NO;
    self.currentPage = 0;
    self.currentPageCount = 20;
    [self loadData];
}

#pragma mark 加载更多数据
- (void)loadMoreDeals {
    // self.currentPage += 1;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        //游客登录
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请注册/登录后查看更多" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        [self.tableView.mj_footer endRefreshing];
        return ;
    }
    self.currentPageCount += 20;
    [self loadData];
}

#pragma mark - 初始化UI
- (void)setupUI {
    UITableView *tableView = [[UITableView alloc]init];
    [tableView registerClass:[WQHomeNearbyTableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:tableView];
    
    //取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-64);
    }];
    
    tableView.dataSource = self;
    tableView.delegate = self;

    tableView.emptyDataSetSource = self;
    tableView.emptyDataSetDelegate = self;
    tableView.estimatedRowHeight = 165;
    self.tableView = tableView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = [UIView new];
}

#pragma mark - 通知方法
- (void)WQlongitudeuptodateNotifacation:(NSNotification *)notificaton {
    NSDictionary *dict = notificaton.userInfo;
    self.location = [dict[WQuptodateKey] MKCoordinateValue];
    self.params[@"geo_lat"] = @(self.location.latitude).description?:@"";
    self.params[@"geo_lng"] = @(self.location.longitude).description?:@"";
    [self loadData];
}

#pragma mark - 请求数据
- (void)loadData {
    //NSString *str =  [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSString *urlString = @"api/need/queryneedhearted";
    self.params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    self.params[@"start_id"] = @(self.currentPage).description;
    self.params[@"count"] = @(self.currentPageCount).description;
    
    CGFloat longti = [WQLocationManager defaultLocationManager].currentLocation.coordinate.longitude;
    CGFloat lati = [WQLocationManager defaultLocationManager].currentLocation.coordinate.latitude;
    
    //    NSString * latiD = @(DefaultLati()).description;
    //
    //    NSString * lontiD = @(DefaultLonti()).description;
    self.params[@"geo_lat"] = @(lati).description.length?@(lati).description:@(LATI_D).description;
    self.params[@"geo_lng"] =  @(longti).description.length?@(longti).description:@(LONTI_D).description;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (error) {
            NSLog(@"%@",error);

            if (self.currentPageCount != 20) {
                self.currentPageCount -= 20;
            }
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        NSInteger lastCount = self.tableViewdetailOrderData.count;
        if (self.currentPageCount == 20) {
            [self.tableViewdetailOrderData removeAllObjects];
        }
        self.haveSubscribe = [response[@"has_hearted_category"] boolValue];
        self.tableViewdetailOrderData = [NSArray yy_modelArrayWithClass:[WQHomeNearbyTagModel class] json:response[@"needs"]].mutableCopy;

        NSInteger nowaCount = self.tableViewdetailOrderData.count;
        
//        [(MJRefreshAutoNormalFooter *)(_tableView.mj_footer) setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
        if (nowaCount == lastCount) {
            [_tableView.mj_footer setState:MJRefreshStateNoMoreData];
//            self.tableView.mj_footer.hidden = YES;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
    }];
}

#pragma mark - tableView数据源
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WQHomeNearbyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *distance = [NSString stringWithFormat:@"%.0f",cell.homeNearbyTagModel.distance];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    if ([cell.homeNearbyTagModel.user_id isEqualToString:im_namelogin]) {
        WQdetailsConrelooerViewController *vc = [[WQdetailsConrelooerViewController alloc]initWithmId:cell.homeNearbyTagModel.id wqOrderType:WQHomePushToDetailsVc];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        //订单信息的控制器
        WQorderViewController *orderVc = [[WQorderViewController alloc]initWithUserId:self.tableViewdetailOrderData[indexPath.row] add:distance];
        //    WQorderViewController *orderVc = [[WQorderViewController alloc] initWithNeedsId:cell.homeNearbyTagModel.id];
        orderVc.user_degree = cell.homeNearbyTagModel.user_degree;
        orderVc.distance = distance;
        orderVc.creditPoints = cell.homeNearbyTagModel.user_creditscore;
        [self.navigationController pushViewController:orderVc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 165;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewdetailOrderData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQHomeNearbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WQHomeNearbyTagModel *model = self.tableViewdetailOrderData[indexPath.row];
    cell.homeNearbyTagModel = model;
    __weak typeof(self) weakSelf = self;
    __weak typeof(cell) weakCell = cell;
    [cell setHeadBtnClikeBlock:^{
        NSString *user_id = weakCell.homeNearbyTagModel.user_id;
        BOOL truename = weakCell.homeNearbyTagModel.truename;
        if (truename == false) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"实名用户匿名状态" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popViewControllerAnimated:YES];
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
                                                                          WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:user_id];
                                                                          [self.navigationController pushViewController:vc animated:YES];
                                                                      }];
            [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
            [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
            
            [alertController addAction:cancelButton];
            [alertController addAction:destructiveButton];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
        if ([WQDataSource sharedTool].verified && ![cell.homeNearbyTagModel.user_idcard_status isEqualToString:@"STATUS_VERIFIED"]) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"非实名认证用户" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return ;
        }
        
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:user_id];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
- (NSMutableArray *)tableViewdetailOrderData  {
    if (!_tableViewdetailOrderData) {
        _tableViewdetailOrderData = [[NSMutableArray alloc]init];
    }
    return _tableViewdetailOrderData;
}



#pragma mark DZNdeleagte


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -40;
}


/**
 Tells the delegate that the empty dataset view was tapped.
 Use this method either to resignFirstResponder of a textfield or searchBar.
 
 @param scrollView A scrollView subclass informing the delegate.
 @param view the view tapped by the user
 */
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
    } else  {
        vc = [[WQAddneedController alloc] init];
        ((WQAddneedController *)vc).type = NeedControllerTypeSubScription;
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
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:noLoginText attributes:att]];
    } else if(!self.haveSubscribe) {
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:noSubscribeText attributes:att]];
    } else {
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:noNeedText attributes:att]];
    }
    [str setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:6],
                         NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, 2)];
    
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
        image = [UIImage imageNamed:@"dingyue1"];
    } else if(!self.haveSubscribe) {
        image = [UIImage imageNamed:@"dingyue1"];
    } else {
        image = [UIImage imageNamed:@"dingyuegengduo"];
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
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:noLoginTitle attributes:att]];
    } else if(!self.haveSubscribe) {
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:noSubscribeTitle attributes:att]];
    } else {
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:noNeedTitle attributes:att]];
    }
    return str;
}


/**
 Asks the data source for a background image to be used for the specified button state.
 There is no default style for this call.
 
 @param scrollView A scrollView subclass informing the data source.
 @param state The state that uses the specified image. The values are described in UIControlState.
 @return An attributed string for the dataset button title, combining font, text color, text pararaph style, etc.
 */
//- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    
//}



- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    
    
    
    UIImage * str ;
//    NSDictionary * att = @{NSForegroundColorAttributeName:HEX(0x5d2a89),
//                           NSFontAttributeName:[UIFont systemFontOfSize:15]};
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    
    if ([role_id isEqualToString:@"200"]) {
        str = [UIImage imageNamed:@"立即登录"];
    } else if(!self.haveSubscribe) {
        str = [UIImage imageNamed:@"开始订阅"];
    } else {
        str = [UIImage imageNamed:@"订阅更多"];
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

@end
