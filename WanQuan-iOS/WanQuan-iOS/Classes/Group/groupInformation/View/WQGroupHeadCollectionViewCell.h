//
//  WQGroupHeadCollectionViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQGroupMemberModel;

@interface WQGroupHeadCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) WQGroupMemberModel *model;

/**
 圈主的label
 */
@property (nonatomic, strong) UILabel *circleMainLabel;

/**
 管理员的label
 */
@property (nonatomic, strong) UILabel *administratorLabel;

@end
