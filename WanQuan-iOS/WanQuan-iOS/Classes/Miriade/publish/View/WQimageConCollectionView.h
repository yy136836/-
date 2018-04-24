//
//  WQimageConCollectionView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/14.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQimageConCollectionView : UICollectionView
@property (strong, nonatomic) NSMutableArray *imageArray;

@property (copy, nonatomic) void (^addImageBlock)();
@property (copy, nonatomic) void (^deleteBlock)();
@property (copy, nonatomic) void (^cellhiddenBlock)(NSInteger);

- (void)addImageWithImgae:(UIImage *)image;
@end
