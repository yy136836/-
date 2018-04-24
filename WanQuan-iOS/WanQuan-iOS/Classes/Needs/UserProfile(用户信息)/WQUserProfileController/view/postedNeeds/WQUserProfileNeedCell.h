//
//  WQUserProfileNeedCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQUserProfileNeedModel.h"
@interface WQUserProfileNeedCell : UITableViewCell
@property (nonatomic, retain) WQUserProfileNeedModel * model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBottomConstent;


@end
