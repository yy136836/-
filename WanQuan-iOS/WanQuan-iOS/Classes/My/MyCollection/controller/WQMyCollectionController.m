//
//  WQMyCollectionController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/26.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQMyCollectionController.h"
#import "WQEssenceModel.h"
#import "WQFavoritesCell.h"
#import "WQFavoritesWithoutImageCell.h"
#import "WQFavoritesModel.h"
#import "WQEssenceDetailController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>


@interface WQMyCollectionController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, retain) UITableView * mainTable;
@property (nonatomic, retain) NSMutableArray * essenceArray;
@end

@implementation WQMyCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"我收藏的文章";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20],
                                                                      NSForegroundColorAttributeName : UIColor.blackColor}];
    self.navigationController.navigationBar.tintColor = HEX(0x000000);

    _essenceArray = @[].mutableCopy;
    [self fetchEssence];
}


- (void)setupUI {
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, kScreenWidth, kScreenHeight - NAV_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_mainTable];
    _mainTable.backgroundColor = WQ_BG_LIGHT_GRAY;
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mainTable registerNib:[UINib nibWithNibName:@"WQFavoritesCell" bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:@"WQFavoritesCell"];
    [_mainTable registerNib:[UINib nibWithNibName:@"WQFavoritesWithoutImageCell" bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:@"WQFavoritesWithoutImageCell"];
    _mainTable.showsVerticalScrollIndicator = NO;
    if(@available(iOS 11.0, *)) {
        _mainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _mainTable.estimatedSectionFooterHeight = 0;
        _mainTable.estimatedSectionHeaderHeight = 0;
        _mainTable.estimatedRowHeight = 0;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _mainTable.tableHeaderView = [UIView new];
    _mainTable.tableFooterView = [UIView new];
    _mainTable.estimatedRowHeight = 170;
    //    _mainTable.rowHeight = UITableViewAutomaticDimension;
    _mainTable.tableFooterView = [UIView new];
    
    _mainTable.emptyDataSetDelegate = self;
    _mainTable.emptyDataSetSource = self;
    
    
}

- (void)fetchEssence {
    
    
    //    TODOHanyang
    NSString * strURL = @"api/favorite/myfavoritelist";
    
    [SVProgressHUD show];
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    param[@"start"] = @(_essenceArray.count).description;
//    param[@"type"] = @"TYPE_CHOICEST_ARTICLE";
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            return ;
        }
        [_mainTable.mj_header endRefreshing];
        [_mainTable.mj_footer endRefreshing];
        if (!response[@"success"]) {
            return;
        }
        
        
        [SVProgressHUD dismiss];
        if ([response[@"favorites"] count] ) {
            
            
            [_essenceArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[WQFavoritesModel class]
                                                                          json:response[@"favorites"]].mutableCopy];
            if ([response[@"choicests"] count] % 20) {
                
                [_mainTable.mj_footer setState:MJRefreshStateNoMoreData];
            }
        } else {
            
            [_mainTable.mj_footer setState:MJRefreshStateNoMoreData];
        }
        
        [_mainTable reloadData];
    }];
    
}

- (void)loadMore {
    [self fetchEssence];
}

- (void)refresh {
    
    [_essenceArray removeAllObjects];
    [self fetchEssence];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WQFavoritesModel * model = _essenceArray[indexPath.row];
    if (model.favorite_pic) {
        WQFavoritesCell * cell = [_mainTable dequeueReusableCellWithIdentifier:@"WQFavoritesCell"];
        if (indexPath.row < _essenceArray.count) {
            cell.model = model;
        } else {
            cell.model = nil;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        WQFavoritesWithoutImageCell * cell = [_mainTable dequeueReusableCellWithIdentifier:@"WQFavoritesWithoutImageCell"];
        if (indexPath.row < _essenceArray.count) {
            cell.model = model;
        } else {
            cell.model = nil;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _essenceArray.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WQFavoritesModel * favoritesModel = _essenceArray[indexPath.row];
  
    if ([favoritesModel.favorite_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        WQEssenceModel * model = [WQEssenceModel new];
        model.favorited = YES;
        model.id = favoritesModel.favorite_target_id;
        WQEssenceDetailController * vc = [[WQEssenceDetailController alloc] init];
        vc.model = model;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)setupRefresh {
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self
                                                               refreshingAction:@selector(refresh)];
    [header setTitle:@" " forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor blackColor];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    //    NSArray *imageArray = [NSArray arrayWithObjects:
    //                           [UIImage imageNamed:@"tableview_pull_refresh"],
    //                           [UIImage imageNamed:@"tableview_pull_refresh"],
    //                           nil];
    NSArray *pullingImages = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"上拉箭头"],
                              [UIImage imageNamed:@"上拉箭头"],
                              nil];
    
    //    [header setImages:imageArray forState:MJRefreshStateIdle];
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    
    [header placeSubviews];
    self.mainTable.mj_header = header;
    MJRefreshAutoNormalFooter *freshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [freshFooter setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    [freshFooter setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [freshFooter setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
    freshFooter.stateLabel.textColor = HEX(0x999999);
    freshFooter.stateLabel.textAlignment = NSTextAlignmentCenter;
    // 设置字体
    freshFooter.stateLabel.font = [UIFont systemFontOfSize:16];
    _mainTable.mj_footer = freshFooter;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -44;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return WQ_BG_LIGHT_GRAY;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"jiazaibuchushuju"];
    
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

@end
