//
//  WQCircleListCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQCircleApplyModel.h"
typedef void(^AgreeOnclick)(UIButton * sender);
typedef void(^AvatarOntap)();

@interface WQCircleListCell : UITableViewCell
@property (nonatomic, retain) WQCircleApplyModel * model;


@property (nonatomic, copy) AgreeOnclick agreeOnclick;
@property (nonatomic, copy) AvatarOntap avatarOntap;
@property (nonatomic, copy) AvatarOntap circleNameOnclick;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@end
