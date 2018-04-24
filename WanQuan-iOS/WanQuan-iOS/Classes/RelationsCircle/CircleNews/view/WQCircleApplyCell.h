//
//  WQCircleApplyCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQCircleApplyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *redDot;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (nonatomic, assign) BOOL isApply;
@end
