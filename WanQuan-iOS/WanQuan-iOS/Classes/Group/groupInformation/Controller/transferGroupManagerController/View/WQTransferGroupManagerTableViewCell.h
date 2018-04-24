//
//  WQTransferGroupManagerTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQGroupMemberModel;

@interface WQTransferGroupManagerTableViewCell : UITableViewCell

@property (nonatomic, strong) WQGroupMemberModel *model;

// 对号
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
/**
 头像的响应事件
 */
@property (nonatomic, copy) void(^headPortraitViewClickBlock)();
@end
