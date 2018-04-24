//
//  WQDynamicDetailsCommentTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQDynamicLevelOncCommentModel,WQDynamicDetailsCommentTableViewCell;

@protocol WQDynamicDetailsCommentTableViewCellDelegate <NSObject>

/**
 游客点击回复时调用

 @param cell self
 */
- (void)wqVisitorsLogIn:(WQDynamicDetailsCommentTableViewCell *)cell;

/**
 评论的响应事件

 @param cell WQDynamicDetailsCommentTableViewCell
 */
- (void)wqCommentsBtnClick:(WQDynamicDetailsCommentTableViewCell *)cell;

/**
 赞的响应事件

 @param cell WQDynamicDetailsCommentTableViewCell
 */
- (void)wqPraiseBtnClick:(WQDynamicDetailsCommentTableViewCell *)cell;

/**
 头像的响应事件

 @param cell WQDynamicDetailsCommentTableViewCell
 */
- (void)wqHeadBtnClike:(WQDynamicDetailsCommentTableViewCell *)cell;

/**
 评论的文字的响应事件

 @param cell self
 */
- (void)wqtextcClick:(WQDynamicDetailsCommentTableViewCell *)cell;


- (void)wqJingxuanCommentClick:(WQDynamicDetailsCommentTableViewCell *)cell;
@end

@interface WQDynamicDetailsCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) WQDynamicLevelOncCommentModel *model;

@property (nonatomic, weak) id <WQDynamicDetailsCommentTableViewCellDelegate> delegate;

/**
 赞
 */
@property (nonatomic, strong) UIButton *praiseBtn;

/**
 一级回复
 */
@property (nonatomic, strong) UILabel *replyLabel;

@property (nonatomic, copy) NSString *role_id;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *nid;

@end
