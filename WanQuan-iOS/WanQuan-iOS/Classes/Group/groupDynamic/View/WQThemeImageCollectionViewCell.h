//
//  WQThemeImageCollectionViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/30.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYAnimatedImageView;

@interface WQThemeImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) YYAnimatedImageView *picImageView;

/**
 图片总数量
 */
@property (nonatomic, strong) UILabel *countLabel;

/**
 图片总数量的背景view
 */
@property (nonatomic, strong) UIView *backgroundViewCount;

/**
 图片的响应事件
 */
@property (nonatomic, copy) void (^imageClilcBlock)();

@end
