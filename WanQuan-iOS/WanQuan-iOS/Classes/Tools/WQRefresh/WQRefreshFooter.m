//
//  WQRefreshFooter.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/11/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQRefreshFooter.h"

@implementation WQRefreshFooter

+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    
    WQRefreshFooter * footer = [super footerWithRefreshingBlock:refreshingBlock];
    //    /** 普通闲置状态 */
    //    MJRefreshStateIdle = 1,
    //    /** 松开就可以进行刷新的状态 */
    //    MJRefreshStatePulling,
    //    /** 正在刷新中的状态 */
    //    MJRefreshStateRefreshing,
    //    /** 即将刷新的状态 */
    //    MJRefreshStateWillRefresh,
    //    /** 所有数据加载完毕，没有更多的数据了 */
    //    MJRefreshStateNoMoreData
    [footer setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
    [footer.stateLabel setTextColor:HEX(0x999999)];
    footer.stateLabel.font = [UIFont systemFontOfSize:16];

    return footer;
}

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    WQRefreshFooter * footer = [super footerWithRefreshingTarget:target refreshingAction:action];
    //    /** 普通闲置状态 */
    //    MJRefreshStateIdle = 1,
    //    /** 松开就可以进行刷新的状态 */
    //    MJRefreshStatePulling,
    //    /** 正在刷新中的状态 */
    //    MJRefreshStateRefreshing,
    //    /** 即将刷新的状态 */
    //    MJRefreshStateWillRefresh,
    //    /** 所有数据加载完毕，没有更多的数据了 */
    //    MJRefreshStateNoMoreData
    [footer setTitle:@"下拉刷新" forState:MJRefreshStatePulling];
    [footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
    [footer.stateLabel setTextColor:HEX(0x999999)];
    footer.stateLabel.font = [UIFont systemFontOfSize:16];
    return footer;
}

@end
