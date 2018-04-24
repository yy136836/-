//
//  WQRefreshTableViewController.m
//  WanQuan-iOS
//
//  Created by Shmily on 2018/4/16.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQRefreshTableViewController.h"

@interface WQRefreshTableViewController ()

@property (nonatomic, readonly) UITableViewStyle style;


@end

@implementation WQRefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _curepage = 1;
    _pageSize = 10;
    _showRefreshHeader = NO;
    _showRefreshFooter = NO;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        _style = style;
    }
    return self;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
        if(@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedRowHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        // 取消分割线&滚动条
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        // 设置自动行高和预估行高
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
        // 注册cell
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-50);
            make.top.equalTo(self.view).offset(NAV_HEIGHT);
        }];

        
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    
    return cell;
}



- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}



- (void)setShowRefreshHeader:(BOOL)showRefreshHeader
{
    if (_showRefreshHeader != showRefreshHeader) {
        _showRefreshHeader = showRefreshHeader;
        if (_showRefreshHeader) {
            
            MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewDidTriggerHeaderRefresh)];
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
            self.tableView.mj_header = header;
        }else{
            [self.tableView setMj_header:nil];
        }
    }
}

- (void)setShowRefreshFooter:(BOOL)showRefreshFooter
{
    if (_showRefreshFooter != showRefreshFooter) {
        _showRefreshFooter = showRefreshFooter;
        if (_showRefreshFooter) {
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewDidTriggerFooterRefresh)];
            // 设置文字
            [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
            [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
            [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
            footer.stateLabel.textColor = HEX(0x999999);
            footer.stateLabel.textAlignment = NSTextAlignmentCenter;
            // 设置字体
            footer.stateLabel.font = [UIFont systemFontOfSize:16];
            // 设置footer
            self.tableView.mj_footer = footer;
        }else{
            [self.tableView setMj_footer:nil];
        }
    }
}

/**
 * 下拉刷新后执行的方法
 */
- (void)tableViewDidTriggerHeaderRefresh
{
    
}

/**
 * 上拉加载后执行的方法
 */
- (void)tableViewDidTriggerFooterRefresh
{
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
