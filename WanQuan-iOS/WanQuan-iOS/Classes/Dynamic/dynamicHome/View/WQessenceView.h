//
//  WQessenceView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQmoment_choicest_articleModel;

@interface WQessenceView : UIView

@property (nonatomic, strong) WQmoment_choicest_articleModel *model;

/**
 来自圈子名称
 */
@property (nonatomic, copy) NSString *group_name;

@property (nonatomic, copy) void(^groupNameClickBlock)();

@end
