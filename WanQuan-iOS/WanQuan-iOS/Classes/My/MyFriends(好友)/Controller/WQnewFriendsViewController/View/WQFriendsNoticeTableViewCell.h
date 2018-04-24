//
//  WQFriendsNoticeTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQUserProfileModel;

@interface WQFriendsNoticeTableViewCell : UITableViewCell
@property (nonatomic, strong) WQUserProfileModel *model;
@property (nonatomic, copy) void (^agreedToBtnClikeBlock)();
@end
