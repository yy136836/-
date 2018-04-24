//
//  WQThemeImageView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/30.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQThemeImageCollectionViewCell;

@interface WQThemeImageView : UIView
@property (nonatomic, strong) WQThemeImageCollectionViewCell *cell;
@property (nonatomic, strong) NSArray *picArray;
// 图片总数量
@property (nonatomic, strong) NSArray *pic;
@property (nonatomic, strong) UICollectionView *collectionView;
@end
