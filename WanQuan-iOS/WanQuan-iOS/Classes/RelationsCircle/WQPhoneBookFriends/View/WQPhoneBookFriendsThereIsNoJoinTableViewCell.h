//
//  WQPhoneBookFriendsThereIsNoJoinTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/11/6.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQPhoneBookFriendsModel,WQPhoneBookFriendsThereIsNoJoinTableViewCell;

@protocol WQPhoneBookFriendsThereIsNoJoinTableViewCellDelegate <NSObject>

/**
 邀请的响应事件

 @param cell self
 */
- (void)wqInvitationClick:(WQPhoneBookFriendsThereIsNoJoinTableViewCell *)cell;
@end

@interface WQPhoneBookFriendsThereIsNoJoinTableViewCell : UITableViewCell

@property (nonatomic, weak) id <WQPhoneBookFriendsThereIsNoJoinTableViewCellDelegate> delegate;

@property (nonatomic, strong) WQPhoneBookFriendsModel *model;

/**
 邀请的按钮
 */
@property (nonatomic, strong) UIButton *invitationBtn;

@end
