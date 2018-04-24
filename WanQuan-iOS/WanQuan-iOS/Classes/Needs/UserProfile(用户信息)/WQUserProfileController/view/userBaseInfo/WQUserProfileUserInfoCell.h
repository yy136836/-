//
//  WQUserProfileUserInfoCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQUserInfoModel.h"

typedef void (^ActionOnclick)(void);
typedef void(^FollowOrUnflow)(UIButton * sender);


@interface WQUserProfileUserInfoCell : UITableViewCell
@property (nonatomic, retain) WQUserInfoModel * model;
@property (nonatomic, retain) UIImage * toReplaceImage;
@property (nonatomic, assign) BOOL selfEditing;
@property (nonatomic, copy) ActionOnclick goPreview;
@property (nonatomic, copy) ActionOnclick goTalking;
@property (nonatomic, copy) ActionOnclick friendApply;
@property (nonatomic, copy) ActionOnclick changeAvartar;
@property (nonatomic, copy) ActionOnclick goConfim;

@property (nonatomic, copy) ActionOnclick showAvatar;
@property (nonatomic, copy) FollowOrUnflow follwOrUnfollow;
@property (nonatomic, copy) ActionBlock changeBackGroundImage;


@end
