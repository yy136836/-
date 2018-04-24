//
//  WQStatusPictureViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/16.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQStatusPictureViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *picString;
@property (nonatomic, strong) NSArray *imageViewArray;
@property (nonatomic, copy) void(^imageClilcBlock)(UIImageView *imageView);
@end
