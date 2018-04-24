//
//  WQGroupListCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQGroupModel;

@interface WQGroupListCell : UITableViewCell

@property (nonatomic, retain) WQGroupModel * model;

/**
 圈介绍
 */
@property (nonatomic, copy) NSString *groupDescriptionString;

/**
 搜索关键词
 */
@property (nonatomic, copy) NSString *searchContent;

@property (nonatomic, copy) void (^wqAvatarImageViewClikeBlock)();
@end
