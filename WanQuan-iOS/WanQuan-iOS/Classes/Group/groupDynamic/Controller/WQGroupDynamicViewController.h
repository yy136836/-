//
//  WQGroupDynamicViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQGroupModel.h"

@interface WQGroupDynamicViewController : UIViewController
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, retain)WQGroupModel * groupModel;
@end
