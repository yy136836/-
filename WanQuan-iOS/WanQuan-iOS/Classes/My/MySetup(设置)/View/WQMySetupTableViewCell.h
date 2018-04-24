//
//  WQMySetupTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQMySetupModel;

@interface WQMySetupTableViewCell : UITableViewCell

@property (nonatomic, strong) WQMySetupModel *model;
@property (weak, nonatomic) IBOutlet UIView *bootmLineView;
@end
