//
//  WQUserProfileTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/2.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQTwoUserProfileModel,WQconfirmsModel,WQTwoWorkUserProfileModel,WQTwoWorkconfirmsModel;

@interface WQUserProfileTableViewCell : UITableViewCell
@property (nonatomic, strong) WQTwoUserProfileModel *userProfileModel;
@property (nonatomic, strong) WQTwoWorkconfirmsModel *workconfirmsModel;
@property (nonatomic, strong) WQconfirmsModel *confirmsModel;
@property (nonatomic, strong) WQTwoWorkUserProfileModel *profileMode;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
    /**
     右箭头
     */
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (nonatomic, copy) void(^certificationBtnClikeBlock)();
@end
