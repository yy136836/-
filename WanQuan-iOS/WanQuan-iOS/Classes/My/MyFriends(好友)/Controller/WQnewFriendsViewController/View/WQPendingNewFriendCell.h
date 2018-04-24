//
//  WQPendingNewFriendCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/29.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQPendingNewFriendModel.h"
@class WQPendingNewFriendCell;

@protocol WQPendingNewFriendCellAccceptFriendRequestDelegate<NSObject>
- (void)WQPendingNewFriendCell:(WQPendingNewFriendCell *)cell accceptFriendRequestBtnClicked:(UIButton *)sender;
@end
typedef void(^AcceptRequest)(NSString * friend_apply_id);
@interface WQPendingNewFriendCell : UITableViewCell
@property (nonatomic, retain) WQPendingNewFriendModel * model;
//@property (nonatomic, copy) AcceptRequest acceptFriendRequest;

@property (nonatomic, assign) id<WQPendingNewFriendCellAccceptFriendRequestDelegate> delegate;
@end
