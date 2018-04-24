//
//  WQCommentLevelOncTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/15.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQDynamicLevelOncCommentModel;



@interface WQCommentLevelOncTableViewCell : UITableViewCell




@property (nonatomic, strong) WQDynamicLevelOncCommentModel *model;

@property (nonatomic, copy) void(^refreshBlock)();

@property (nonatomic, assign) BOOL isnid;

/**
 头像的响应事件
 */
@property (nonatomic, copy) void(^headBtnClikeBlock)();

/**
 是否从消息页面跳转
 */
@property (nonatomic, assign) BOOL fromMessage;

/**
 内容
 */
@property (strong, nonatomic) UILabel *contentLabel;

/**
 赞
 */
@property (nonatomic, strong) UIButton *praiseBtn;

@property (nonatomic, copy) NSString *nid;

@end
