//
//  WQSetAdministratorTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQGroupMemberModel;

@interface WQSetAdministratorTableViewCell : UITableViewCell

@property (nonatomic, strong) WQGroupMemberModel *model;

/**
 头像的响应事件
 */
@property (nonatomic, copy) void(^headPortraitViewClickBlock)();

@end
