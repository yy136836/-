//
//  WQConversationListViewController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/11.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "EaseRefreshTableViewController.h"

@interface WQConversationListViewController : EaseConversationListViewController<EMChatManagerDelegate,EMGroupManagerDelegate>




//@property (weak, nonatomic) id<EaseConversationListViewControllerDelegate> delegate;
//@property (weak, nonatomic) id<EaseConversationListViewControllerDataSource> dataSource;

/*!
 @method
 @brief 下拉加载更多
 @discussion
 @result
 */
- (void)tableViewDidTriggerHeaderRefresh;

/*!
 @method
 @brief 内存中刷新页面
 @discussion
 @result
 */
- (void)refreshAndSortView;

- (void)tableViewScrollTop;


@end
