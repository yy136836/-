//
//  WQGroupRelationsCircleHomeTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQGroupModel;

@interface WQGroupRelationsCircleHomeTableViewCell : UITableViewCell

@property (nonatomic, strong) WQGroupModel *model;
@property (nonatomic, copy) void(^groupHeadPortraitimageViewBlock)();

// 底部分隔线
@property (nonatomic, strong) UIView *bottomLine;
@end
