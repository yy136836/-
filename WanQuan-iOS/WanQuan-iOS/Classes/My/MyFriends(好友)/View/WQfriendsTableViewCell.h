//
//  WQfriendsTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreText;
@class WQUserProfileModel,WQfriend_listModel;

@interface WQfriendsTableViewCell : UITableViewCell
@property (nonatomic, strong) WQUserProfileModel *userProfileModel;
@property (nonatomic, strong) WQfriend_listModel *model;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;

@end
