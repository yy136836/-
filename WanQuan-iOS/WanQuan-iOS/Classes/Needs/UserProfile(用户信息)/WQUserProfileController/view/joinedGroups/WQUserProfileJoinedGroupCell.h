//
//  WQUserProfileJoinedGroupLabel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MakeGroupPublic)(BOOL public, UISwitch * aSwitch);
#import "WQUserProfileGroupModel.h"
#import "WQSwitch.h"
@interface WQUserProfileJoinedGroupCell : UITableViewCell
@property (nonatomic, retain) WQUserProfileGroupModel * model;
@property (nonatomic, copy) MakeGroupPublic makePublic;
@property (weak, nonatomic) IBOutlet WQSwitch *showSwitch;

@end
