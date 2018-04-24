//
//  WQGroupInformationViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQGroupModel.h"
@interface WQGroupInformationViewController : UIViewController

@property (nonatomic, copy) NSString *gid;
@property (nonatomic, retain) WQGroupModel * groupModel;
/**
 确定退出此群
 */
//@property (nonatomic, copy) void(^determineRefundGroupOfBlock)();

@end
