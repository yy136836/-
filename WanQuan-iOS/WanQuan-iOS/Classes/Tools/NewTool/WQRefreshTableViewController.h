//
//  WQRefreshTableViewController.h
//  WanQuan-iOS
//
//  Created by Shmily on 2018/4/16.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQBaseViewController.h"

@interface WQRefreshTableViewController : WQBaseViewController<UITableViewDelegate, UITableViewDataSource>

/**
 * 第一次
 */
@property (nonatomic) BOOL isFirst;
/**
 * tableView
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 * tableView的数据源，用户UI显示
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 * 当前加载的页数
 */
@property (nonatomic) int curepage;

/**
 * 偏移量 每页展示
 */
@property (nonatomic) int pageSize;


/**
 * 是否启用下拉加载更多，默认为NO
 */
@property (nonatomic) BOOL showRefreshHeader;

/**
 * 是否启用上拉加载更多，默认为NO
 */
@property (nonatomic) BOOL showRefreshFooter;
/**
 * 初始化ViewController
 * style   tableView样式
 */
- (instancetype)initWithStyle:(UITableViewStyle)style;

/**
 * 下拉刷新后执行的方法
 */
- (void)tableViewDidTriggerHeaderRefresh;

/**
 * 上拉加载后执行的方法
 */
- (void)tableViewDidTriggerFooterRefresh;

/**
 * 加载结束
 * 加载结束后，通过参数reload来判断是否需要调用tableView的reloadData，判断isHeader来停止加载
 * isHeader   是否结束下拉刷新(或者上拉加载)[传YES结束下拉刷新,传NO结束上拉加载]
 * reload     是否需要重载TabeleView
 */
- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;

/**
 * 上拉加载结束，没有更多数据
 */
- (void)endRefreshingWithNoMoreData;


@end
