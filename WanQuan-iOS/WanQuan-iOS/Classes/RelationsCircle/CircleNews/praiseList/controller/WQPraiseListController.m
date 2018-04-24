//
//  WQPraiseListController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/19.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQPraiseListController.h"
#import "WQPrasiseListCell.h"
#import "WQPraiseListModel.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "WQPraiseListHeader.h"

NSString * PrasiseListCellIdenty = @"WQPrasiseListCell";

@interface WQPraiseListController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, retain) UITableView * mainTable;
@property (nonatomic, retain) NSMutableArray * praiseList;
@end

@implementation WQPraiseListController

- (void)viewDidLoad {
    [super viewDidLoad];
    _praiseList = @[].mutableCopy;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我收到的赞";
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.tintColor = [UIColor blackColor];
    [self setupUI];
    [self loadPraiseList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                                                      NSForegroundColorAttributeName : [UIColor blackColor]}];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)setupUI {
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, kScreenWidth, kScreenHeight - NAV_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:_mainTable];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.tableFooterView = [UIView new];
    _mainTable.tableHeaderView = [UIView new];
    _mainTable.showsVerticalScrollIndicator = NO;
    _mainTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _mainTable.emptyDataSetSource = self;
    _mainTable.emptyDataSetDelegate = self;
    _mainTable.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    _mainTable.separatorColor = HEX(0xeeeeee);
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _praiseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQPrasiseListCell * cell = [tableView dequeueReusableCellWithIdentifier:PrasiseListCellIdenty];
    
    if (!cell) {
        cell = [[WQPrasiseListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:PrasiseListCellIdenty];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _praiseList[indexPath.row];
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     WQPrasiseListCell * cell = [[WQPrasiseListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:PrasiseListCellIdenty];
    
    
    return 130 + cell.addHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WQPraiseListHeader * header = [[NSBundle mainBundle] loadNibNamed:@"WQPraiseListHeader"
                                                                owner:nil
                                                              options:nil].lastObject;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)loadPraiseList {
    NSString * strURL = @"api/message/querylikemessage";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    
    __weak typeof(self) weakself = self;
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost
         urlString:strURL
        parameters:param
        completion:^(id response, NSError *error) {
        if (error) {
            return ;

        }
        
        if (![response[@"success"] boolValue]) {
            return;
        }
            NSLog("%@",response);
        self.praiseList = [NSArray yy_modelArrayWithClass:[WQPraiseListModel class] json:response[@"messages"]].mutableCopy;
        [weakself.mainTable reloadData];
    }];

}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma DZNEmpty
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return HEX(0xf3f3f3);
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    
    return [UIImage imageNamed:@"wuxiaoxi"];
    
}


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableAttributedString * str  = [[NSMutableAttributedString alloc] init];
    NSDictionary * att = @{NSForegroundColorAttributeName:HEX(0x999999),
                           NSFontAttributeName:[UIFont systemFontOfSize:14],
                           NSParagraphStyleAttributeName:paragraphStyle};
    
    NSString * noResult = @"\n 还没有新的赞";
    
    
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:noResult attributes:att]];
    [str setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:6],
                         NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, 1)];
    
    return str;
}

//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    return [[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
//}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -44;
}

@end
