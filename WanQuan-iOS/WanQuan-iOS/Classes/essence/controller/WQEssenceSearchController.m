//
//  WQEssenceSearchController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/26.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQEssenceSearchController.h"
#import "WQEssenceModel.h"
#import "WQEssencewCell.h"
#import "WQEssencewWithOutImageCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "WQEssenceDetailController.h"

@interface WQEssenceSearchController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, retain) UISearchBar * searchBar;
@property (nonatomic, retain) UITableView * mainTable;
@property (nonatomic, retain) NSMutableArray * essenceArray;
@end

@implementation WQEssenceSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _essenceArray = @[].mutableCopy;
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_searchBar becomeFirstResponder];
}


#pragma mark - UI
- (void)setupUI {
    self.navigationController.navigationBar.translucent = YES;
    self.view.backgroundColor = WQ_BG_LIGHT_GRAY;

    [self setupSearchBar];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem new];
    _mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, kScreenWidth, kScreenHeight - NAV_HEIGHT)];
    [self.view addSubview: _mainTable];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _mainTable.backgroundColor = WQ_BG_LIGHT_GRAY;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@(self.navigationController.navigationBar.height + 20));
        make.bottom.equalTo(@0);
    }];
    self.navigationItem.hidesBackButton = YES;
    if(@available(iOS 11.0, *)) {
        _mainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _mainTable.estimatedSectionFooterHeight = 0;
        _mainTable.estimatedSectionHeaderHeight = 0;
        _mainTable.estimatedRowHeight = 0;
        [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(@(56 + 20));
            make.bottom.equalTo(@0);
        }];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(@(44 + [UIApplication sharedApplication].statusBarFrame.size.height));
            make.bottom.equalTo(@0);
        }];
    }
    
    _mainTable.tableFooterView = [UIView new];
    _mainTable.tableHeaderView = [UIView new];
    [_mainTable registerNib:[UINib nibWithNibName:@"WQEssencewCell" bundle:nil]
     forCellReuseIdentifier:@"WQEssencewCell"];
    [_mainTable registerNib:[UINib nibWithNibName:@"WQEssencewWithOutImageCell" bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:@"WQEssencewWithOutImageCell"];
    _mainTable.rowHeight = UITableViewAutomaticDimension;
    _mainTable.estimatedRowHeight = 175;
 
    
}


- (void)setupSearchBar {
    _searchBar = [[UISearchBar alloc] init];
    self.navigationItem.titleView = _searchBar;
    _searchBar.translucent = NO;
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.showsCancelButton = NO;
    _searchBar.placeholder = @"搜索文章";
    _searchBar.showsCancelButton = YES;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    for (UIView *subview in _searchBar.subviews) {
        
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
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQEssenceModel * model = _essenceArray[indexPath.row];
    if (model.choicest_article.cover_pic.length) {
        WQEssencewCell * cell = [_mainTable dequeueReusableCellWithIdentifier:@"WQEssencewCell"];
        if (indexPath.row < _essenceArray.count) {
            cell.model = model;
        } else {
            cell.model = nil;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        if (indexPath.row == _essenceArray.count - 1) {
            cell.separatorInset = UIEdgeInsetsMake(0, MAXFLOAT, 0, 0);
        } else {
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        }
        return cell;
    } else {
        WQEssencewWithOutImageCell * cell = [_mainTable dequeueReusableCellWithIdentifier:@"WQEssencewWithOutImageCell"];
        if (indexPath.row < _essenceArray.count) {
            cell.model = model;
        } else {
            cell.model = nil;
        }
        if (indexPath.row == _essenceArray.count - 1) {
            cell.separatorInset = UIEdgeInsetsMake(0, MAXFLOAT, 0, 0);
        } else {
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WQEssenceDetailController * vc = [[WQEssenceDetailController alloc] init];
    //      TODOHanyang
    vc.model = self.essenceArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _essenceArray.count;
}






#pragma mark - SearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@", searchText);
//    self.searchText = searchText;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   ^{
                       [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                   });
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (!searchBar.text .isVisibleString) {
        return;
    }
    
    NSString * strURL = @"api/choicest/articlequery";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    param[@"keyword"] = _searchBar.text;
    param[@"limit"] = @(1000);
    [SVProgressHUD show];
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD showWithStatus:@"网络连接错误..."];
            [SVProgressHUD  dismissWithDelay:1.3];
            return;
        }
        [SVProgressHUD dismiss];
        [_essenceArray removeAllObjects];
        [_essenceArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[WQEssenceModel class]
                                                                       json:response[@"choicests"]].mutableCopy];
        _mainTable.emptyDataSetSource = self;
        _mainTable.emptyDataSetDelegate = self;
        [_mainTable reloadData];
    }];

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


- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.view endEditing:YES];
    [_searchBar resignFirstResponder];
}



@end
