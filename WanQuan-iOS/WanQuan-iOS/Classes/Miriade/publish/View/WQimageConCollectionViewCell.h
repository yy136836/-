//
//  WQimageConCollectionViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/14.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQimageConCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UIImage *image;

@property (copy, nonatomic) void (^deleteBlock)();

/**
 点击图片的响应事件
 */
@property (nonatomic, copy) void(^imageClilcBlock)();

@end
