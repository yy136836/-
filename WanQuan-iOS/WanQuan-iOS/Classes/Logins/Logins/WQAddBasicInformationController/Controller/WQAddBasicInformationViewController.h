//
//  WQAddBasicInformationViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQAddBasicInformationViewController : UIViewController

/**
 班级id
 */
@property (nonatomic, copy) NSString *class_idString;

/**
 是否有邀请码
 */
@property (nonatomic, assign) BOOL isInviteCode;

@end
