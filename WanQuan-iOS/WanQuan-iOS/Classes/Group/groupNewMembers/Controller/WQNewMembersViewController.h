//
//  WQNewMembersViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQNewMembersViewController : UIViewController
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) void(^operationIsSuccessfulBlock)();
@end
