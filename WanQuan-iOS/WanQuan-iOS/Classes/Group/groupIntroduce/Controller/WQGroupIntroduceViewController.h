//
//  WQGroupIntroduceViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQGroupIntroduceViewController : UIViewController

/**
 组的id
 */
@property (nonatomic, copy) NSString *gid;

/**
 原有的内容
 */
@property (nonatomic, copy) NSString *content;
@end
