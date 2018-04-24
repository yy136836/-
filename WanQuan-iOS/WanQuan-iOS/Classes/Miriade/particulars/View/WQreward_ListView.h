//
//  WQreward_ListView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/2/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYLabel.h>

@class WQrewardListModel;

@interface WQreward_ListView : UIView
@property (nonatomic, strong) WQrewardListModel *model;
@property (nonatomic, strong) YYLabel *user_nameLabel;
@property (nonatomic, strong) NSArray *reward_list;

@end
