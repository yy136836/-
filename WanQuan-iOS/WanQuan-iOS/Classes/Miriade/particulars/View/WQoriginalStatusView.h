//
//  WQoriginalStatusView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/22.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQoriginalStatusView : UIView
@property (strong, nonatomic) UIImageView *iconView;  //用户图标
@property (strong, nonatomic) UILabel *nameLabel;     //昵称
@property (strong, nonatomic) UILabel *tagOncLabel;   //标签1
@property (strong, nonatomic) UILabel *tagTwoLabel;   //标签2

/**
 信用分
 */
@property (nonatomic, strong) UILabel *creditPointsLabel;
/**
 信用分的背景view
 */
@property (nonatomic, strong) UIView *creditBackgroundView;

/**
 信用分图标
 */
@property (nonatomic, strong) UIImageView *creditImageView;

@property (copy, nonatomic) void(^shareBtnClikeBlock)();
// 点击头像
@property (nonatomic, copy) void (^headPortraitBlock)();
@end
