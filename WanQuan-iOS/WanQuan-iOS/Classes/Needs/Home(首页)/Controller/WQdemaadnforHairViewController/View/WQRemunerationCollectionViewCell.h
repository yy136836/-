//
//  WQRemunerationCollectionViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/2/28.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQRemunerationCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, strong) UIButton *titleBtn;

@property (nonatomic, copy) void(^titleBtnClickBlock)();

@end
