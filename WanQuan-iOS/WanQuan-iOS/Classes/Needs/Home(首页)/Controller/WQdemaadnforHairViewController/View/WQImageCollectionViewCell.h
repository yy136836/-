//
//  WQImageCollectionViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/7.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void (^deleteImageBlock)();

/**
 图片的响应事件
 */
@property (nonatomic, copy) void (^imageClilcBlock)();

@property (nonatomic, strong) UIImageView *imageView;
@end
