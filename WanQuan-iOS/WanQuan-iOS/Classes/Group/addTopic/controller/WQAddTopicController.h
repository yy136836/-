//
//  WQAddTopicController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/19.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQAddTopicController : UIViewController
@property (nonatomic, copy) NSString * gid;

/**
 发布成功
 */
@property (nonatomic, copy) void(^releaseSuccessBlock)();

@end
