//
//  WQGroupDynamicActlvltyView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/3/20.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQGroupDynamicActlvltyView : UIView

/**
 活动标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 活动图片
 */
@property (nonatomic, strong) UIImageView *actlvltyImageView;

/**
 时间
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 地点
 */
@property (nonatomic, strong) UILabel *addrLabel;

@property (nonatomic, assign) CGFloat w;

@property (nonatomic, assign) CGFloat h;

@end
