//
//  WQOrderTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/6.
//  Copyright © 2016年 WQ. All rights reserved.
//join

#import <UIKit/UIKit.h>
@class WQWaitOrderModel;
@interface WQOrderTableViewCell : UITableViewCell
@property (nonatomic, strong) WQWaitOrderModel *waitorderModel;
@property (strong, nonatomic) UIView *redDotView;

@property (nonatomic, copy) void(^personnelClikeBlock)();
@end
