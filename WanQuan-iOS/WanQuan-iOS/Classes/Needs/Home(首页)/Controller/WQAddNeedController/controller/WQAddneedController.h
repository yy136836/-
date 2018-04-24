//
//  WQAddneedController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/10.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, NeedControllerType) {
    NeedControllerTypeAddNeed,//默认从0开始
    NeedControllerTypeSubScription,
    NeedControllerTypeNeeds,   // 首页
    NeedControllerTypeGroup    // 群组
};
@interface WQAddneedController : UIViewController

@property (nonatomic, assign) NeedControllerType type;
/**
 群组id
 */
@property (nonatomic, copy) NSString *gid;
@end
