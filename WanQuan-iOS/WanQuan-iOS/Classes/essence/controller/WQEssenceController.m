//
//  WQEssenceController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQEssenceController.h"
#import "WQEssencewCell.h"
#import "WQEssencewWithOutImageCell.h"
#import "WQEssenceModel.h"
#import "WQCycleScrollView.h"
#import "WQEssenceArticleModel.h"
#import "WQEssenceCarouselModel.h"
#import "WQEssenceDetailController.h"
#import <UIScrollView+EmptyDataSet.h>
#import "WQEssenceSearchController.h"
#import "WQRefresh.h"


@interface WQEssenceController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, retain) NSMutableArray * bannerImagesArray;
@property (nonatomic, retain) NSMutableArray * bannerTitles;
@property (nonatomic, retain) UITableView * mainTable;
@property (nonatomic, retain) NSMutableArray * essenceArray;
@property (nonatomic, retain) NSMutableArray * carouselArray;

//@property (nonatomic, retain) dispatch_group_t reloadGroup;
@end

@implementation WQEssenceController {
    WQCycleScrollView *cycleScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WQ_BG_LIGHT_GRAY;
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    _bannerImagesArray = @[].mutableCopy;
    _bannerTitles = @[].mutableCopy;
    _essenceArray = @[].mutableCopy;
    
    [self setupUI];
    
    if (_mainTable.mj_header) {
        [_mainTable.mj_header beginRefreshing];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"精选";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20],
                                                                      NSForegroundColorAttributeName : UIColor.blackColor}];
    self.navigationController.navigationBar.tintColor = HEX(0x000000);
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shouyesousuo"]
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(searchOnclick)];
    self.navigationItem.rightBarButtonItem = rightItem;


}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)setupUI {
    self.view.backgroundColor = WQ_BG_LIGHT_GRAY;
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, kScreenWidth, kScreenHeight - NAV_HEIGHT - TAB_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_mainTable];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mainTable registerNib:[UINib nibWithNibName:@"WQEssencewCell" bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:@"WQEssencewCell"];
    [_mainTable registerNib:[UINib nibWithNibName:@"WQEssencewWithOutImageCell" bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:@"WQEssencewWithOutImageCell"];
    _mainTable.showsVerticalScrollIndicator = NO;
    _mainTable.backgroundColor = WQ_BG_LIGHT_GRAY;
    if(@available(iOS 11.0, *)) {
        _mainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _mainTable.estimatedSectionFooterHeight = 0;
        _mainTable.estimatedSectionHeaderHeight = 0;
        _mainTable.estimatedRowHeight = 0;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _mainTable.estimatedRowHeight = 175;
    
    MJWeakSelf
    WQRefreshHeader *header = [WQRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf refresh];
    }];

    self.mainTable.mj_header = header;

    
}

- (void)fetchEssence {
    
    
    //    TODOHanyang
    NSString * strURL = @"api/choicest/getlist";
    
//    [SVProgressHUD show];
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    param[@"start"] = @(_essenceArray.count).description;
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    //    dispatch_group_enter(_reloadGroup);
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        
        
        if (error) {
            [_mainTable.mj_header endRefreshing];
            [SVProgressHUD showWithStatus:@"网络连接错误"];
            [SVProgressHUD dismissWithDelay:1.3];
            return ;
        }
        [_mainTable.mj_header endRefreshing];
        [_mainTable.mj_footer endRefreshing];
        if (![response[@"success"] boolValue]) {
            [_mainTable.mj_header endRefreshing];

            [SVProgressHUD showWithStatus:@"网络连接错误"];
            [SVProgressHUD dismissWithDelay:1.3];
            return ;
            return;
        }
        
        
//        [SVProgressHUD dismiss];
        
        
        
        if ([response[@"choicests"] count] ) {
            
            MJWeakSelf
            _mainTable.mj_footer = [WQRefreshFooter footerWithRefreshingBlock:^{
                [weakSelf loadMore];
            }];
            
            [_essenceArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[WQEssenceModel class]
                                                                          json:response[@"choicests"]].mutableCopy];
            //        } else {
            [_mainTable reloadData];
            if ([response[@"choicests"] count] % 20) {
                
                [_mainTable.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            
            [_mainTable.mj_footer endRefreshingWithNoMoreData];
        }
        
        //        if (_reloadGroup) {
        //            dispatch_group_leave(_reloadGroup);

        //        }
        
        if (!_essenceArray.count) {
            if (!_mainTable.emptyDataSetSource) {
                _mainTable.emptyDataSetSource = self;
            }
            if ( !_mainTable.emptyDataSetDelegate) {
                _mainTable.emptyDataSetDelegate = self;
            }
        } else {
            if (!_mainTable.emptyDataSetSource) {
                _mainTable.emptyDataSetSource = nil;
            }
            if ( !_mainTable.emptyDataSetDelegate) {
                _mainTable.emptyDataSetDelegate = nil;
            }
        }

    }];
}


- (void)fetchCarousel {
    NSString * strURL = @"api/choicest/getcarousel";
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    
    //    dispatch_group_enter(_reloadGroup);
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
        for (WQEssenceModel * essenceModel in _bannerImagesArray) {
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
        _mainTable.tableHeaderView = cycleScrollView;

    }];
}
#pragma mark - 搜索
/**
 search - 搜索
 */
- (void)searchOnclick  {
    WQEssenceSearchController * vc = [[WQEssenceSearchController alloc] init];
    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nc animated:NO completion:nil];
}
#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQEssenceModel * model;
    if (indexPath.row < _essenceArray.count) {
         model = _essenceArray[indexPath.row];
    }
    if (model.choicest_article.cover_pic.length) {
        WQEssencewCell * cell = [_mainTable dequeueReusableCellWithIdentifier:@"WQEssencewCell"];
        if (indexPath.row < _essenceArray.count) {
            cell.model = model;
        } else {
            cell.model = nil;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        WQEssencewWithOutImageCell * cell = [_mainTable dequeueReusableCellWithIdentifier:@"WQEssencewWithOutImageCell"];
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
    WQEssenceDetailController * vc = [[WQEssenceDetailController alloc] init];
    if (_essenceArray.count > indexPath.row) {
        vc.model = self.essenceArray[indexPath.row];
    }
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - refresh
- (void)loadMore {
    [self fetchEssence];
}

- (void)refresh {
    [_essenceArray removeAllObjects];
    [_carouselArray removeAllObjects];
    //    _reloadGroup = dispatch_group_create();
    //
    //    dispatch_group_notify(_reloadGroup, dispatch_get_main_queue(), ^{
    _mainTable.tableHeaderView = cycleScrollView;
    //        _reloadGroup = nil;
    //    });
    
    
    
    [self fetchEssence];
    [self fetchCarousel];
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    WQEssenceDetailController * vc = [[WQEssenceDetailController alloc] init];
    vc.model = _bannerImagesArray[index];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - DZNEmpty

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

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.view endEditing:YES];
}




@end
