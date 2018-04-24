//
//  WQaddFriendsController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQaddFriendsController : UIViewController
- (instancetype)initWithIMId:(NSString *)imId;

/**
 加入类型如果是加入圈子则 type 需要传@"加入圈",
 如果是添加好友则传@"添加好友"
 */
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *gid;
@end
