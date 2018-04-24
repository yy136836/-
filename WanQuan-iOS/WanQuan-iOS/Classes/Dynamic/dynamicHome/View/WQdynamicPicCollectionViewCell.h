//
//  WQdynamicPicCollectionViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQdynamicPicCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *picImageview;

@property (nonatomic, copy) void(^imageClickBlock)();

@property (nonatomic, copy) NSString *imageId;

@end
