//
//  WQPhoneBookFriendsBottomView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/11/6.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQPhoneBookFriendsBottomView;

@protocol WQPhoneBookFriendsBottomViewDelegate <NSObject>

/**
 一键邀请好友的响应事件

 @param bottomView self
 */
- (void)wqInvitationBtnClick:(WQPhoneBookFriendsBottomView *)bottomView;
@end

@interface WQPhoneBookFriendsBottomView : UIView

@property (nonatomic, weak) id <WQPhoneBookFriendsBottomViewDelegate> delegate;

@property (nonatomic, strong) UIButton *invitationBtn;

@end
