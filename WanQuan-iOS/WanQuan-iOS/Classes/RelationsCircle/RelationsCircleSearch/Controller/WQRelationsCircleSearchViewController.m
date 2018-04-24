//
//  WQRelationsCircleSearchViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/19.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQRelationsCircleSearchViewController.h"
#import "WQGroupListCell.h"
#import "WQGroupModel.h"
#import "WQGroupInformationViewController.h"
#import "WQGroupDynamicViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "WQGroupModel.h"

static NSString *identifier = @"groupListCell";

@interface WQRelationsCircleSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *SearchBar;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, strong) NSMutableArray *groupDescription;;
@property (nonatomic, strong) NSArray *recommendedList;

@property (nonatomic, assign) NSInteger limit;

@end

@implementation WQRelationsCircleSearchViewController {
    BOOL isSearch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupSearchView];
    [self loadRecommendedList];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.limit = 20;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    WQTabBarController *tabBarVC = (WQTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([tabBarVC isKindOfClass:[WQTabBarController class]]) {
        tabBarVC.tabBar.hidden = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    WQTabBarController *tabBarVC = (WQTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([tabBarVC isKindOfClass:[WQTabBarController class]]) {
        tabBarVC.tabBar.hidden = NO;
    }
}

#pragma mark -- 获取推荐群列表
- (void)loadRecommendedList {
    NSString *urlString = @"api/group/recommandgroup";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"start"] = @(0).description;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        self.recommendedList = [NSArray yy_modelArrayWithClass:[WQGroupModel class] json:response[@"groups"]];
        
        NSDictionary *dict = response[@"groups"];
        [self.groupDescription removeAllObjects];
        for (id i in dict) {
            [self.groupDescription addObject:i[@"description"]];
        }
        
        [self.tableView reloadData];
    }];
}

#pragma mark -- setupSearchView
- (void)setupSearchView {

//    UISearchController * vc = [[UISearchController alloc] initWithSearchResultsController:self];
    UISearchBar *SearchBar = [[UISearchBar alloc] init];
    self.SearchBar = SearchBar;
    SearchBar.delegate = self;
    SearchBar.showsCancelButton = NO;
//    SearchBar.scopeBarBackgroundImage
    SearchBar.searchBarStyle = UISearchBarStyleMinimal;
    SearchBar.placeholder = @"搜索圈子";
    self.navigationItem.titleView = SearchBar;
    SearchBar.showsCancelButton = YES;
    
    for (UIView *subview in SearchBar.subviews) {
        
        for (UIView *tempView in subview.subviews) {
            // 找到cancelButton
            if ([tempView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                // 在这里转化为UIButton, 设置其属性
                
                UIButton *btn = (UIButton*)tempView;
                dispatch_after(0.1, dispatch_get_global_queue(0, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    });
                });
            }
        }
    }
    if (@available(iOS 11.0, *)) {
         self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
   
    [SearchBar becomeFirstResponder];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = WQ_BG_LIGHT_GRAY;
    self.tableView = tableView;
    self.tableView.backgroundColor = WQ_BG_LIGHT_GRAY;
    [tableView registerClass:[WQGroupListCell class] forCellReuseIdentifier:identifier];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 上拉加载
    MJRefreshAutoNormalFooter *freshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
    // 设置文字
    [freshFooter setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    [freshFooter setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [freshFooter setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    // 设置字体
    freshFooter.stateLabel.textColor = HEX(0x999999);
    freshFooter.stateLabel.textAlignment = NSTextAlignmentCenter;
    // 设置字体
    freshFooter.stateLabel.font = [UIFont systemFontOfSize:16];
    self.tableView.mj_footer = freshFooter;
    tableView.mj_footer.hidden = YES;
}

#pragma mark 加载更多数据
- (void)loadMoreDeals {
    self.limit+=20;
//    [self.dataArray removeAllObjects];
    [self loadData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.SearchBar endEditing:YES];
}

#pragma mark - SearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@", searchText);
    self.searchText = searchText;
    self.params[@"name"] = self.searchText;
    if (searchText.length) {
        isSearch = YES;
        [self.dataArray removeAllObjects];
        [self loadData];
    }else {
        isSearch = NO;
        [self.dataArray removeAllObjects];
        [self loadRecommendedList];
    }
    //[self.SearchBar endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_SearchBar endEditing:YES];
    dispatch_after(0.5, dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.params[@"name"] = self.searchText;
    isSearch = YES;
    [self.dataArray removeAllObjects];
    [self loadData];
    [self.SearchBar endEditing:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    [searchBar setShowsCancelButton:YES animated:YES];

}

#pragma mark -- 请求数据
- (void)loadData {
    NSString *url = @"api/group/querygroup";
    self.params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    self.params[@"limit"] = @(self.limit).description;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:url parameters:self.params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            self.limit-=20;
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        NSLog(@"%@",response);
        self.dataArray = [NSArray yy_modelArrayWithClass:[WQGroupModel class] json:response[@"groups"]].mutableCopy;
    
        NSDictionary *dict = response[@"groups"];
        [self.groupDescription removeAllObjects];
        for (id i in dict) {
            [self.groupDescription addObject:i[@"description"]];
        }
        
        if (self.dataArray.count) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        self.tableView.mj_footer.hidden = self.dataArray.count >= 500000;
        [self.tableView reloadData];
    }];
}

#pragma mark -- UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 是不是已经加入该群
    WQGroupListCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell.model.isMember) {
        cell.wqAvatarImageViewClikeBlock();
        return;
    }
    
    WQGroupDynamicViewController *vc = [[WQGroupDynamicViewController alloc] init];
    vc.gid = cell.model.gid;
    vc.groupModel = cell.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (isSearch == NO) {
        return 45;
    }else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // 没有搜索过显示热门圈子
    if (isSearch == NO) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [UILabel labelWithText:@"热门圈子" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
        [backgroundView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backgroundView.mas_centerY);
            make.left.equalTo(backgroundView.mas_left).offset(kScaleY(ghSpacingOfshiwu));
        }];
        
        // 分割线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
        [backgroundView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0.5);
            make.right.left.bottom.equalTo(backgroundView);
        }];
        
        return backgroundView;
    }else {
        return [UIView new];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 没有搜索过显示热门圈子
    if (isSearch == NO) {
        return self.recommendedList.count;
    }else {
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!self.SearchBar.text.length) {
        cell.model = self.recommendedList[indexPath.row];
        cell.groupDescriptionString = self.groupDescription[indexPath.row];
    }else {
        cell.model = self.dataArray[indexPath.row];
        cell.groupDescriptionString = self.groupDescription[indexPath.row];
        cell.searchContent = self.searchText;
    }
    
    __weak typeof(cell) weakCell = cell;
    // 点击头像的事件
    [cell setWqAvatarImageViewClikeBlock:^{
        WQGroupInformationViewController *vc = [[WQGroupInformationViewController alloc] init];
        vc.gid = weakCell.model.gid;
        vc.groupModel = weakCell.model;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return kScaleX(75);
//}

#pragma mark - 懒加载
- (NSString *)searchText {
    if (!_searchText) {
        _searchText = [[NSString alloc] init];
    }
    return _searchText;
}

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)back {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -44;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return HEX(0xf3f3f3);
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

- (NSMutableArray *)groupDescription {
    if (!_groupDescription) {
        _groupDescription = [NSMutableArray array];
    }
    return _groupDescription;
}

- (NSArray *)recommendedList {
    if (!_recommendedList) {
        _recommendedList = [[NSArray alloc] init];
    }
    return _recommendedList;
}

@end
