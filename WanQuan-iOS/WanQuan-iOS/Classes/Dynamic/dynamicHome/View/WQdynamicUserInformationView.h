//
//  WQdynamicUserInformationView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQdynamicUserInformationView;

@protocol WQdynamicUserInformationViewDelegate <NSObject>

/**
 头像的响应事件

 @param dynamicUserInformationView self
 */
- (void)wqUser_picImageViewClick:(WQdynamicUserInformationView *)dynamicUserInformationView;

/**
 关注的响应事件

 @param dynamicUserInformationView self
 */
- (void)wqGuanzhuBtnClick:(WQdynamicUserInformationView *)dynamicUserInformationView;

@end

@interface WQdynamicUserInformationView : UIView

@property (nonatomic, weak) id <WQdynamicUserInformationViewDelegate> delegate;

/**
 详情的标签
 */
@property (nonatomic, strong) NSArray *workArray;

/**
 标签数组
 */
@property (nonatomic, strong) NSArray *tagArray;

/**
 头像
 */
@property (nonatomic, strong) UIImageView *user_picImageView;

/**
 姓名
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 信用分数
 */
@property (nonatomic, strong) UILabel *creditLabel;

/**
 用户标签
 */
@property (nonatomic, strong) UILabel *user_tagLabel;

/**
 关注按钮
 */
@property (nonatomic, strong) UIButton *guanzhuBtn;

/**
 精选图标
 */
@property (nonatomic, strong) UIImageView *essenceImageView;

/**
 几度好友的背景颜色
 */
@property (nonatomic, strong) UILabel *aFewDegreesBackgroundLabel;

/**
 信用分的背景view
 */
@property (nonatomic, strong) UIView *creditBackgroundView;

/**
 信用分图标
 */
@property (nonatomic, strong) UIImageView *creditImageView;

@end
