//
//  WQdynamicTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQdynamicContentView.h"
#import "WQdynamicHomeModel.h"
#import "WQdynamicTableViewCell.h"
#import "WQdynamicUserInformationView.h"
#import "WQLinksContentView.h"
#import "WQdynamicToobarView.h"
@class WQdynamicHomeModel,WQdynamicTableViewCell,WQdynamicUserInformationView,WQLinksContentView,WQdynamicToobarView,WQessenceView;

@protocol WQdynamicTableViewCellDelegate <NSObject>

/**
 文字的响应事件

 @param cell self
 */
- (void)wqContentLabelClick:(WQdynamicTableViewCell *)cell;

/**
 头像的响应事件
 
 @param dynamicUserInformationView self
 */
- (void)wqUser_picImageViewClick:(WQdynamicTableViewCell *)cell;

/**
 关注的响应事件
 
 @param dynamicUserInformationView self
 */
- (void)wqGuanzhuBtnClick:(WQdynamicTableViewCell *)cell;

/**
 外链的响应事件

 @param linksContentView linksContentView
 @param cell self
 */
- (void)wqLinksContentViewClick:(WQLinksContentView *)linksContentView cell:(WQdynamicTableViewCell *)cell;

/**
 分享的响应事件
 
 @param yoobarView WQdynamicToobarView
 @param cell self
 */
- (void)wqSharBtnClick:(WQdynamicToobarView *)yoobarView cell:(WQdynamicTableViewCell *)cell;

/**
 评论的响应事件
 
 @param yoobarView WQdynamicToobarView
 @param cell self
 */
- (void)wqCommentsBtnClick:(WQdynamicToobarView *)yoobarView cell:(WQdynamicTableViewCell *)cell;

/**
 赞的响应事件

 @param yoobarView WQdynamicToobarView
 @param cell self
 */
- (void)wqPraiseBtnClick:(WQdynamicToobarView *)yoobarView cell:(WQdynamicTableViewCell *)cell;

/**
 鼓励的响应事件

 @param toobarView WQdynamicToobarView
 @param cell self
 */
- (void)wqEencourageBtnClick:(WQdynamicToobarView *)toobarView cell:(WQdynamicTableViewCell *)cell;

/**
 踩的响应事件

 @param toobarView WQdynamicToobarView
 @param cell self
 */
- (void)wqCaiBtnClick:(WQdynamicToobarView *)toobarView cell:(WQdynamicTableViewCell *)cell;

/**
 三个点的响应事件

 @param toobarView WQdynamicToobarView
 @param cell self
 */
- (void)wqBtnsClick:(WQdynamicToobarView *)toobarView cell:(WQdynamicTableViewCell *)cell;

/**
 来自圈子的响应事件

 @param essenceView WQessenceView
 @param cell self
 */
- (void)wqGroupNameClick:(WQessenceView *)essenceView cell:(WQdynamicTableViewCell *)cell;

@end

@interface WQdynamicTableViewCell : UITableViewCell

@property (nonatomic, weak) id <WQdynamicTableViewCellDelegate> delegate;

@property (nonatomic, strong) WQdynamicHomeModel *model;


/**
 动态的view
 */
@property (nonatomic, strong) WQdynamicContentView *dynamicContentView;

/**
 用户信息的view
 */
@property (nonatomic, strong) WQdynamicUserInformationView *userInformationView;

/**
 底部栏
 */
@property (nonatomic, strong) WQdynamicToobarView *toobarView;

@end
