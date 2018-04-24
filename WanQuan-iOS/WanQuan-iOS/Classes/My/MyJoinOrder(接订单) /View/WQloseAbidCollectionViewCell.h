//
//  WQloseAbidCollectionViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/12.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WQloseAbidCollectionViewCell : UICollectionViewCell
@property(nonatomic,copy)void(^evaluateBtnBlock)(NSString *);
@end
