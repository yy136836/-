//
//  WQCommentDetailsViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/15.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQDynamicLevelOncCommentModel.h"

typedef NS_ENUM(NSUInteger, CommentDetailType) {
    CommentDetailTypeMoment = 0,
    CommentDetailTypeEssence,
    CommentDetaiTypeNeeds
};

@interface WQCommentDetailsViewController : UIViewController

@property (nonatomic, copy) void(^deleteCommentBlock)();

@property (nonatomic, copy) void(^SendSuccessCommentBlock)();


@property (nonatomic, strong) WQDynamicLevelOncCommentModel *model;

/**
 当来自圈消息时 commentId 不为空,当来自动态时为空
 */
@property (nonatomic, copy, nullable) NSString *commentId;
/**
 原动态或者精选的 id
 */
@property (nonatomic, copy, nullable) NSString *mid;

@property (nonatomic, assign) CommentDetailType type;

@property (nonatomic, copy) NSString *nid;

/**
 圈消息直接push过来 为YES
 */
@property (nonatomic, assign) BOOL isnid;

//展示键盘
@property (nonatomic, assign) BOOL isShowKeyBord;


@end
