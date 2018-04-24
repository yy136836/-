//
//  WQHomeSearchViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/23.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQHomeSearchViewController.h"
#import "WQTabBarController.h"
#import "WQHomeNearbyTableViewCell.h"
#import "WQdetailsConrelooerViewController.h"
#import "WQorderViewController.h"
#import "WQUserProfileController.h"
#import  <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "WQTopSearchCollectionViewCell.h"

static NSString *identifier = @"identifier";

@interface WQHomeSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, retain) UITableView * tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentPageCount;
@property (nonatomic, retain) NSMutableDictionary * params;
@property (nonatomic, retain) NSMutableArray<WQHomeNearbyTagModel *> * tableViewdetailOrderData;
@property (nonatomic, retain) NSMutableDictionary * informationParams;
@property (nonatomic, strong) UICollectionView *collectionView;
// 热门搜索
@property (nonatomic, strong) UILabel *hotLalabel;
@property (nonatomic, copy) void(^informationBlock)();
@property (nonatomic, assign) BOOL ismyaccount;


@end


NSString * cellID = @"cellid";

@implementation WQHomeSearchViewController {
    NSArray *hotSearchArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _params = @{}.mutableCopy;
    hotSearchArray = [[NSArray alloc] init];
    _tableViewdetailOrderData = @[].mutableCopy;
    self.navigationController.navigationBar.translucent = YES;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupUI];
    [self loadList];
//    [self pulldownrenovate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    WQTabBarController *tabBarVC = (WQTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([tabBarVC isKindOfClass:[WQTabBarController class]]) {
        tabBarVC.tabBar.hidden = NO;
    }
    [_searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    WQTabBarController *tabBarVC = (WQTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([tabBarVC isKindOfClass:[WQTabBarController class]]) {
        tabBarVC.tabBar.hidden = NO;
    }
}

- (void)setupUI {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth / 3 * 2, 44)];
    self.navigationItem.titleView = _searchBar;
    _searchBar.translucent = NO;
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.showsCancelButton = NO;
    _searchBar.placeholder = @"搜索需求";
    _searchBar.showsCancelButton = YES;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    for (UIView *subview in _searchBar.subviews) {

        for (UIView *tempView in subview.subviews) {
            if ([tempView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {

                UIButton *btn = (UIButton*)tempView;
                dispatch_after(0.1, dispatch_get_global_queue(0, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    });
                });
            }
        }
    }
//
//
//    [[UISearchBar appearance] setTintColor:[UIColor blackColor]];

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    [tableView registerNib:[UINib nibWithNibName:@"WQHomeNearbyTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    [tableView registerClass:NSClassFromString(@"WQHomeNearbyTableViewCell") forCellReuseIdentifier:cellID];
    tableView.tableHeaderView = nil;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    //取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView = tableView;
//    _tableView.contentInset = UIEdgeInsetsMake(-(self.navigationController.navigationBar.height), 0, 0, 0);
    
    // 热门搜索
    UILabel *hotLalabel = [UILabel labelWithText:@"热门搜索" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    self.hotLalabel = hotLalabel;
    [self.view addSubview:hotLalabel];
    [hotLalabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(79);
        make.left.equalTo(self.view).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor colorWithHex:0xffffff];
    // 禁止滑动
    collectionView.scrollEnabled = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[WQTopSearchCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hotLalabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
        make.left.equalTo(self.view).offset(kScaleY(ghSpacingOfshiwu));
        make.right.equalTo(self.view).offset(kScaleY(-ghSpacingOfshiwu));
        make.bottom.equalTo(self.view);
    }];
}

- (void)loadList {
    NSString *urlString = @"/api/need/queryneedsuggest";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        hotSearchArray = response[@"need_name_keyword_suggest"];
        [self.collectionView reloadData];
    }];
}

#pragma mark -- UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_searchBar endEditing:YES];
    self.hotLalabel.hidden = YES;
    self.collectionView.hidden = YES;
    self.params[@"key_word"] = hotSearchArray[indexPath.item];
    self.searchBar.text = hotSearchArray[indexPath.item];
    [self loadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return hotSearchArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScaleY(105), kScaleX(30));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQTopSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.titleString = hotSearchArray[indexPath.item];
    
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBar endEditing:YES];
    [self.view endEditing:YES];
}

#pragma mark - SearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@", searchText);
    self.searchText = searchText;
    
    if ([searchBar.text isEqualToString:@""] || [searchBar.text length] == 0) {
        [self.tableViewdetailOrderData removeAllObjects];
        [self.tableView reloadData];
        self.hotLalabel.hidden = NO;
        self.collectionView.hidden = NO;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(0.25 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   ^{
                       [self.navigationController dismissViewControllerAnimated:NO
                                                                     completion:nil];
                   });
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    [searchBar setShowsCancelButton:YES animated:YES];

}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _params[@"key_word"] = [NSString stringWithFormat:@"%@",self.searchText];
    self.hotLalabel.hidden = YES;
    self.collectionView.hidden = YES;
//    [self loadNewDeals];
    [self loadData];
    [self.searchBar endEditing:YES];
}

#pragma mark - 下拉刷新
//- (void)pulldownrenovate {
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self loadNewDeals];
//    }];
//
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDeals)];
//    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
//    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
//    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
//
//    header.stateLabel.font = [UIFont systemFontOfSize:14];
//    header.stateLabel.textColor = [UIColor blackColor];
//
//    NSArray *imageArray = [NSArray arrayWithObjects:
//                           [UIImage imageNamed:@"tableview_pull_refresh"],
//                           [UIImage imageNamed:@"tableview_pull_refresh"],
//                           nil];
//    NSArray *pullingImages = [NSArray arrayWithObjects:
//                              [UIImage imageNamed:@"上拉箭头"],
//                              [UIImage imageNamed:@"上拉箭头"],
//                              nil];
//    /*NSArray *refreshingImages = [NSArray arrayWithObjects:
//     [UIImage imageNamed:@"上拉箭头"],
//     [UIImage imageNamed:@"上拉箭头"],
//     nil];
//     [header setImages:refreshingImages forState:MJRefreshStateRefreshing];*/
//    [header setImages:imageArray forState:MJRefreshStateIdle];
//    [header setImages:pullingImages forState:MJRefreshStatePulling];
//    [header placeSubviews];
//    //header.lastUpdatedTimeLabel.hidden = YES;
//    self.tableView.mj_header = header;
////    [self.tableView.mj_header beginRefreshing];
//    // 上拉加载
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
//    // 设置文字
//    [footer setTitle:@"" forState:MJRefreshStateIdle];
//    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
//    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
//    // 设置字体
//    footer.stateLabel.textColor = HEX(0x999999);
//    footer.stateLabel.textAlignment = NSTextAlignmentCenter;
//    // 设置字体
//    footer.stateLabel.font = [UIFont systemFontOfSize:16];
//
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSString *role_id = [userDefaults objectForKey:@"role_id"];
//        if ([role_id isEqualToString:@"200"]) {
//            // 游客登录
//            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请注册/登录后查看更多" preferredStyle:UIAlertControllerStyleAlert];
//
//            [self presentViewController:alertVC animated:YES completion:^{
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [alertVC dismissViewControllerAnimated:YES completion:nil];
//                });
//            }];
//            [self.tableView.mj_footer endRefreshing];
//            return ;
//        }
//        [self loadMoreDeals];
//    }];
//    // 设置footer
//    self.tableView.mj_footer = footer;
//    // 开始隐藏底部刷新
//    self.tableView.mj_footer.hidden = YES;
//}

#pragma mark 加载新数据
//- (void)loadNewDeals {
////    self.currentPage = 0;
////    self.currentPageCount = 20;
//    if (!_searchBar.text.length) {
//        [_tableView.mj_header endRefreshing];
//        [_tableView.mj_footer endRefreshing];
//        return;
//    }
//    [_tableViewdetailOrderData removeAllObjects];
//    [self loadData];
//}
//
//#pragma mark 加载更多数据
//- (void)loadMoreDeals {
//    [self loadData];
//}

- (void)loadData {
    NSString *urlString = @"api/need/queryneedlatest";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.params[@"geo_lat"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"geo_lat"];
    self.params[@"geo_lng"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"geo_lng"];
    
    
    self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
//    self.params[@"start_id"] = @(self.tableViewdetailOrderData.count).description;
//    self.params[@"count"] =  @"20";
    __weak typeof(self) weakSelf = self;
    
    if (!_searchBar.text.length) {
        return;
    }
    NSLog(@"%@",self.params);
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {

        
       weakSelf.tableView.emptyDataSetSource = self;
       weakSelf.tableView.emptyDataSetDelegate = self;
        
        
        if (error) {
            NSLog(@"%@",error);
//            [weakSelf.tableView.mj_header endRefreshing];
//            [weakSelf.tableView.mj_footer endRefreshing];
//            if (weakSelf.currentPageCount != 20) {
//                weakSelf.currentPageCount -= 20;
//            }
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
//        if (weakSelf.currentPageCount == 20) {
//            [weakSelf.tableViewdetailOrderData removeAllObjects];
//        }
        [weakSelf.tableViewdetailOrderData addObjectsFromArray: [NSMutableArray yy_modelArrayWithClass:[WQHomeNearbyTagModel class] json:response[@"needs"]].mutableCopy ];
        
//        if ( ![response[@"needs"] count]) {
//            weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
//        }
//        [weakSelf.tableView.mj_header endRefreshing];
//        [weakSelf.tableView.mj_footer endRefreshing];
//
        [weakSelf.tableView reloadData];
//        weakSelf.tableView.mj_footer.hidden = weakSelf.tableViewdetailOrderData.count >= 500000;
    }];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 165;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WQHomeNearbyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *distance = [NSString stringWithFormat:@"%.0f",cell.homeNearbyTagModel.distance];
    //订单信息的控制器
    WQHomeNearbyTagModel *model = self.tableViewdetailOrderData[indexPath.row];
    
    //if ([model.user_id isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@""]]) {
    //  [SVProgressHUD showErrorWithStatus:@"不允许参与自己发布的需求"];
    //[SVProgressHUD dismissWithDelay:1.5];
    //}
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    if ([cell.homeNearbyTagModel.user_id isEqualToString:im_namelogin]) {
        WQdetailsConrelooerViewController *vc = [[WQdetailsConrelooerViewController alloc]initWithmId:cell.homeNearbyTagModel.id wqOrderType:WQHomePushToDetailsVc];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        WQorderViewController *orderVc = [[WQorderViewController alloc]initWithUserId:model add:distance];
        //    WQorderViewController *orderVc = [[WQorderViewController alloc] initWithNeedsId:cell.homeNearbyTagModel.id];
        orderVc.user_degree = cell.homeNearbyTagModel.user_degree;
        orderVc.distance = distance;
        orderVc.creditPoints = cell.homeNearbyTagModel.user_creditscore;
        [self.navigationController pushViewController:orderVc animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewdetailOrderData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WQHomeNearbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    __weak typeof(self) weakSelf = self;
    [cell setHeadBtnClikeBlock:^{
        
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
            return ;
        }
        
        WQHomeNearbyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *user_id = cell.homeNearbyTagModel.user_id;
        weakSelf.informationParams[@"uid"] = user_id;
        BOOL truename = cell.homeNearbyTagModel.truename;
        if (truename == false) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"真实用户匿名求助" preferredStyle:UIAlertControllerStyleAlert];
            
            [weakSelf presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }];
            return ;
        }
        [weakSelf information];
        [weakSelf setInformationBlock:^{
            if (weakSelf.ismyaccount) {
                WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:weakSelf.tableViewdetailOrderData[indexPath.row].user_id];

                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else {
                WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:weakSelf.tableViewdetailOrderData[indexPath.row].user_id];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
    }];
    
    
    //    TODO
    BOOL shouldShowRed = NO;
    //    发需求人的 id
    NSString * uid = cell.homeNearbyTagModel.user_id;
    //    需求的 id
    NSString * billId = cell.homeNearbyTagModel.id;
    //    我的 id
    //    NSString * myId =
    
    
    WQHomeNearbyTagModel *model = self.tableViewdetailOrderData[indexPath.row];
    cell.homeNearbyTagModel = model;
    
    return cell;
}

- (void)information {
    NSString *urlString = @"api/user/getbasicinfo";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.informationParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:urlString parameters:_informationParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        self.ismyaccount = [response[@"ismyaccount"]boolValue];
        if (self.informationBlock) {
            self.informationBlock();
        }
    }];
}




#pragma mark - 懒加载
- (NSString *)searchText {
    if (!_searchText) {
        _searchText = [[NSString alloc]init];
    }
    return _searchText;
}


#pragma mark - DZNEmpty


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -44;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return HEX(0xffffff);
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {

    return [UIImage imageNamed:@"sousuowuneirong"];
    
}


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableAttributedString * str  = [[NSMutableAttributedString alloc] init];
    NSDictionary * att = @{NSForegroundColorAttributeName:HEX(0x999999),
                           NSFontAttributeName:[UIFont systemFontOfSize:14],
                           NSParagraphStyleAttributeName:paragraphStyle};
    
    NSString * noResult = @"\n暂时没找到相关内容";
    
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:noResult attributes:att]];
    [str setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:6],
                         NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, 1)];
    
    return str;
}


- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.view endEditing:YES];
}

- (void)back {
    
    [self.view endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    });
}

@end
