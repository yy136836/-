//
//  WQPeopleListTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/29.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQPeopleListModel;

@interface WQPeopleListTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *severalFriendsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

/**
 分割线
 */
@property (weak, nonatomic) IBOutlet UIView *lineView;

/**
 选定他按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *SelectedBtn;

/**
 选定他图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;

/**
 申请取消交易按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

/**
 申请取消交易图片
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelImage;

/**
 临时会话按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *temporaryBtn;

/**
 临时会话图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *temporaryImage;

/**
 红点
 */
@property (weak, nonatomic) IBOutlet UIView *redDotView;

@property (nonatomic, strong) WQPeopleListModel *model;
@property (nonatomic, copy) NSString * midString;

@property (nonatomic, copy) void(^huihuaClikeBlock)();
@property (nonatomic, copy) void(^xuandingClikeBlock)();
@property (nonatomic, copy) void(^touxiangBtnClikeBlock)();
@property (nonatomic, copy) void(^cancelBntClikeBlick)();
// 编辑头像
@property (nonatomic, copy) void (^headPortraitBlock)();

@end
