//
//  WQTopicDetailController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQTopicModel.h"


/**
 群主题的详情

 - TopicDetailTypeFromGroup: 来自圈详情
 - TopicDetailTypeFromMessage: 来自圈消息
 */
typedef NS_ENUM(NSUInteger, TopicDetailType) {
    TopicDetailTypeFromGroup,
    TopicDetailTypeFromMessage
};

@interface WQTopicDetailController : UIViewController

/**
  true string 主题ID
 */


@property (nonatomic, copy, nonnull) NSString * tid;
@property (nonatomic, assign) TopicDetailType detailType;

/**
 删除主题成功回调上个控制器刷新数据
 */
@property (nonatomic, copy) void(^deleteSuccessfulBlock)();

/**
 置顶成功或者取消置顶成功
 */
@property (nonatomic, copy) void(^topSuccessfulBlock)();

@end
