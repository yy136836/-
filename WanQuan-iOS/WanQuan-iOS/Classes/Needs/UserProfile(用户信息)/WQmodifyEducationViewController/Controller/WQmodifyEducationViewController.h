//
//  WQmodifyEducationViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQTwoUserProfileModel;

/**
 main -> 我的 -> 个人信息 -> 修改教育经历
 */
@interface WQmodifyEducationViewController : UIViewController
@property (nonatomic, retain) NSMutableArray * educetions;
@property (nonatomic, retain) NSArray * currentEducetionExperience;
@property (nonatomic, assign) NSInteger modifingIndex;
- (instancetype)initWithType:(NSString *)type model:(WQTwoUserProfileModel *)model;
@end
