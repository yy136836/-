//
//  WQUserProfileContrlooer.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/2.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, UserProfileType) {
//    默认的情况,即陌生人这种情况下下面的按钮应该是加好友;
    UserProfileTypeDefault,
//    是好友的状态,这种情况下最下面的按钮应该是对话;
    UserProfileTypeFriend,
//    是自己的编辑状态下最下面的按钮应该是预览
    UserProfileTypeEdit,
//    是自己的编预览状态下最下面的按钮应该是编辑
    UserProfileTypePreview,
//    是自己的编预览状态下最下面的按钮应该是编辑
    UserProfileTypeFromFriendList
    
};


/**
 root-> 我的-> 头像-> 个人信息
 
 */



NS_CLASS_DEPRECATED_IOS(2_0, 9_0, "该类已停止使用!!!!请使用WQUserProfileController")
@interface WQUserProfileContrlooer : UIViewController

- (instancetype)initWithUserId:(NSString *)UserId;

+ (void)getUserAccountAndPassword:(NSString *)userId userLogin:(void(^)(void))userLogin;

@property (nonatomic, copy) NSString *stringuserId;

/**
 个人页面可能有以下几种状态
 默认的情况,即陌生人这种情况下下面的按钮应该是加好友;
 是好友的状态,这种情况下最下面的按钮应该是对话;
 是自己的编辑状态下最下面的按钮应该是预览
 是自己的编预览状态下最下面的按钮应该是编辑
 */
@property (nonatomic,assign) UserProfileType userProfileType;
@property (nonatomic, assign) BOOL ismyaccount;
@property (nonatomic, assign) BOOL fromFriendList;
@end
