//
//  WQRefreshHeader.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/11/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQRefreshHeader.h"

@interface WQRefreshHeader ()

@end


@implementation WQRefreshHeader
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    
    WQRefreshHeader * header = [super headerWithRefreshingBlock:refreshingBlock];
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
    [header setTitle:@" "
            forState:MJRefreshStateIdle];
    [header setTitle:@"正在刷新"
            forState:MJRefreshStateRefreshing];
    [header setTitle:@"松开刷新"
            forState:MJRefreshStatePulling];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    [header.stateLabel setTextColor:HEX(0x999999)];
    [header.stateLabel setFont:[UIFont systemFontOfSize:16]];
    return header;
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    
    WQRefreshHeader * header = [super headerWithRefreshingTarget:target
                                                refreshingAction:action];
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
    [header setTitle:@"  "
            forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新"
            forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新"
            forState:MJRefreshStateRefreshing];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    [header.stateLabel setTextColor:HEX(0x999999)];
    [header.stateLabel setFont:[UIFont systemFontOfSize:16]];
    return header;
}
@end
