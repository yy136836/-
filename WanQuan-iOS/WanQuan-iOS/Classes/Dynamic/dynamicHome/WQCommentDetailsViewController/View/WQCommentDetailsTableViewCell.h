//
//  WQCommentDetailsTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/15.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQDynamicLevelSecondaryModel,WQCommentDetailsTableViewCell;

@protocol WQCommentDetailsTableViewCellDelegate <NSObject>

/**
 赞的响应事件

 @param cell self
 */
- (void)wqPraiseBtnClick:(WQCommentDetailsTableViewCell *)cell;

@end

@interface WQCommentDetailsTableViewCell : UITableViewCell

@property (nonatomic, weak) id <WQCommentDetailsTableViewCellDelegate> delegate;

@property (nonatomic, strong) WQDynamicLevelSecondaryModel *model;

/**
 头像的响应事件
 */
@property (nonatomic, copy) void(^headBtnClikeBlock)();

/**
 内容
 */
@property (strong, nonatomic) UILabel *contentLabel;

/**
 赞
 */
@property (nonatomic, strong) UIButton *praiseBtn;

@end
