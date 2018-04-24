//
//  WQmyDynamicTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQdynamicContentView,WQdynamicUserInformationView;

@interface WQmyDynamicTableViewCell : UITableViewCell

/**
 动态的view
 */
@property (nonatomic, strong) WQdynamicContentView *dynamicContentView;

/**
 用户信息的view
 */
@property (nonatomic, strong) WQdynamicUserInformationView *userInformationView;

@end
