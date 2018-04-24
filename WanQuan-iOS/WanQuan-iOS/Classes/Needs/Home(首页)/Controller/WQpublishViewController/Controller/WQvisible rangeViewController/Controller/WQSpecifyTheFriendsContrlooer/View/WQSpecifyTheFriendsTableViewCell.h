//
//  WQSpecifyTheFriendsTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/3/2.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQUserProfileModel,WQfriend_listModel;

@interface WQSpecifyTheFriendsTableViewCell : UITableViewCell

//@property (nonatomic, strong) WQUserProfileModel *model;
//@property (nonatomic, strong) UIImageView *checkImageView;

@property (nonatomic, strong) WQfriend_listModel * model;

@property (nonatomic, strong) UIImageView *duihaoImageView;

@property (nonatomic, strong) UIImageView *quanImageView;

@end
