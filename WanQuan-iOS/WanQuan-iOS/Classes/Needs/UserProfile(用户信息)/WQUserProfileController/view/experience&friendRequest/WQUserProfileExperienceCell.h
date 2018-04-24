//
//  WQUserProfileExperienceCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQUserEducationExperienceModel.h"
#import "WQUserWorkExperienceModel.h"

typedef void(^GoConfim)();

@interface WQUserProfileExperienceCell : UITableViewCell



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (nonatomic, retain) WQUserWorkExperienceModel * workModel;
@property (nonatomic, retain) WQUserEducationExperienceModel * educationModel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@property (nonatomic, copy) GoConfim goConfim;
@end
