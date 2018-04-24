//
//  WQDynamicDetailsContentView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQDynamicDetailsContentView : UIView

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
@property (nonatomic, strong) UILabel *contentLabel;

/**
 图片数据
 */
@property (nonatomic, strong) NSArray *picArray;

/**
 内容
 */
@property (nonatomic, copy) NSString *contentString;

@property (nonatomic, strong) UICollectionView *collectionView;

@end
