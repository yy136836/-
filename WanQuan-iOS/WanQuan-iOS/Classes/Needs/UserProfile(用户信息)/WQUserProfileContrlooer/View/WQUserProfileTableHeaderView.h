//
//  WQUserProfileTableHeaderView.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/4/12.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQUserProfileTableHeaderView : UIView
@property (nonatomic, retain) WQUserProfileModel * model;

/**
 头像
 */
@property (nonatomic, retain) UIImageView * userHeadImageView;
@end
