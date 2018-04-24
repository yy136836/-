//
//  WQGroupInformationTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQGetgroupInfoModel;

@interface WQGroupInformationTableViewCell : UITableViewCell
@property (nonatomic, strong) WQGetgroupInfoModel *model;

// 群成员总数量
@property (nonatomic, copy) NSString *member_count;
@property (nonatomic, copy) NSString *groupId;
// 群介绍
@property (nonatomic, strong) UILabel *contentLabel;
// 不是群成员
@property (nonatomic, copy) void(^isMemberBlock)();
// 需要刷新数据
@property (nonatomic, copy) void(^isLoadDataBlockBlock)();
@end
