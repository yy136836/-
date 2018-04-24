//
//  WQLoginClassListTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQClassModel;

@interface WQLoginClassListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *tagLabel;

@property (nonatomic, strong) WQClassModel *model;

@end
