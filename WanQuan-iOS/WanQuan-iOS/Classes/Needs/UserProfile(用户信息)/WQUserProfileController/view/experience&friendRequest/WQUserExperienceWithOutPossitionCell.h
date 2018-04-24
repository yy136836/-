//
//  WQUserExperienceWithOutPossitionCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQUserWorkExperienceModel.h"

typedef void(^GoConfim)();


@interface WQUserExperienceWithOutPossitionCell : UITableViewCell
@property (nonatomic, retain) WQUserWorkExperienceModel * workModel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (nonatomic, copy) GoConfim goConfim;

@end
