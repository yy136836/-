//
//  WQGroupInformationHeaderView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQGroupInformationHeaderView;

@protocol WQGroupInformationHeaderViewDelegate <NSObject>
// 点击头像
- (void)wqHeadPortraitImageViewClike:(WQGroupInformationHeaderView *)headerView;
// 点击群人数
- (void)wqNumberLabelClike:(WQGroupInformationHeaderView *)headerView;
// 点击群主头像
- (void)wqGroupManagerNamelLabelTap:(WQGroupInformationHeaderView *)headerView;
@end

@interface WQGroupInformationHeaderView : UIView
@property (nonatomic, weak) id <WQGroupInformationHeaderViewDelegate> delegate;

// 组的大头像
@property (nonatomic, strong) UIImageView *groupBackgroundHeadPortraitImageView;
// 组的小头像
@property (nonatomic, strong) UIImageView *groupHeadPortraitImageView;
// 群组名称
@property (nonatomic, strong) UILabel *groupNameLabel;
// 群人数
@property (nonatomic, strong) UILabel *numberLabel;
// 群主名称
@property (nonatomic, strong) UILabel *groupManagerNamelLabel;
@end
