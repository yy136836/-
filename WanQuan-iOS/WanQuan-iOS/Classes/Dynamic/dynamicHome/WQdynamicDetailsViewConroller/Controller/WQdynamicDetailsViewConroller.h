//
//  WQdynamicDetailsViewConroller.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQdynamicDetailsViewConroller : UIViewController

/**
 万圈详情id
 */
@property (nonatomic, copy) NSString *mid;

/**
 是否展开评论的输入框
 */
@property (nonatomic, assign) BOOL isComment;

/**
 点赞成功
 */
@property (nonatomic, copy) void(^likeBlock)();

@end
