//
//  WQNewMembersTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQWaitingForAuditModel;

@interface WQNewMembersTableViewCell : UITableViewCell
@property (nonatomic, strong) WQWaitingForAuditModel *model;

@property (nonatomic, copy) void(^agreedToBtnClikeBlock)();
@end
