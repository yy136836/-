//
//  WQUserProfileController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQViewController.h"

@interface WQUserProfileController : WQViewController

- (instancetype)initWithUserId:(NSString *)UserId;

//- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, copy) NSString * userId;
@property (nonatomic, assign) BOOL selfEditing;

/**
 添加好友的验证信息
 */
@property (nonatomic, copy) NSString * requestInfo;

/**
 如果来自新的好友请求的话,会有一个好友请求验证消息的 cell
 */
@property (nonatomic, assign, getter=isFromFriendRequest) BOOL fromFriendRequest;
/**
 如果是从我的好友列表进入个人页面右上角会有删除好友的列表
 */
@property (nonatomic, assign) BOOL fromFriendList;

@end
