//
//  WQPhoneBookFriendsHasJoinedTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/11/6.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQPhoneBookFriendsModel,WQPhoneBookFriendsHasJoinedTableViewCell;

@protocol WQPhoneBookFriendsHasJoinedTableViewCellDelegate <NSObject>

/**
 添加的响应事件

 @param cell self
 */
- (void)wqAddClick:(WQPhoneBookFriendsHasJoinedTableViewCell *)cell;
@end

@interface WQPhoneBookFriendsHasJoinedTableViewCell : UITableViewCell 

@property (nonatomic, weak) id <WQPhoneBookFriendsHasJoinedTableViewCellDelegate> delegate;

@property (nonatomic, strong) WQPhoneBookFriendsModel *model;

/**
 添加的按钮
 */
@property (nonatomic, strong) UIButton *addBtn;

@end
