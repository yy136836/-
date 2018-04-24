//
//  WQMyUserInfoCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQUserProfileModel.h"


typedef void(^ConfimOnclick)();


@interface WQMyUserInfoCell : UITableViewCell

@property (nonatomic, copy) ConfimOnclick confimOnclick;
@property (nonatomic, retain) WQUserProfileModel * model;
@end
