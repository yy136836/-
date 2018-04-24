//
//  WQdynamicContentView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQmoment_statusModel;

@interface WQdynamicContentView : UIView

/**
 cell里的图片
 */
@property (nonatomic, strong) UIImageView *picImageview;

/**
 单张图片
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 内容
 */
@property (nonatomic, strong) YYLabel *contentLabel;

/**
 图片数据
 */
@property (nonatomic, strong) NSArray *picArray;

@property (nonatomic, strong) WQmoment_statusModel *model;

/**
 文字的响应事件
 */
@property (nonatomic, copy) void(^wqContentLabelClickBlock)();

@end
