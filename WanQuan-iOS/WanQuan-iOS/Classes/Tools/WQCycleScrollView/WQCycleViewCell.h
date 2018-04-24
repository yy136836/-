//
//  WQCycleViewCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "SDCollectionViewCell.h"

@interface WQCycleViewCell : UICollectionViewCell
@property (weak, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *title;

@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIFont *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;

@property (nonatomic, assign) BOOL hasConfigured;

/** 只展示文字轮播 */
@property (nonatomic, assign) BOOL onlyDisplayText;
//@property (nonatomic, retain)
@end
