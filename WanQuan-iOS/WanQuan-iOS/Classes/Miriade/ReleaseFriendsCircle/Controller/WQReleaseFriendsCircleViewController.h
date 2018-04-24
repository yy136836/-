//
//  WQReleaseFriendsCircleViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQReleaseFriendsCircleViewController : UIViewController

// 发布成功的回调
@property (nonatomic, copy) void(^releaseSuccessBlock)();

@end
