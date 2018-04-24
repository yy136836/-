//
//  WQworkExperienceTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQTwoUserProfileModel;

@interface WQworkExperienceTableViewCell : UITableViewCell

@property (nonatomic, strong) WQTwoUserProfileModel *model;
@property (nonatomic, copy) void (^modifyBtnClikeBlock)();

@end
