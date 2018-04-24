//
//  WQCommentDetailController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/16.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WQCommentAndReplyModel.h"
#import "WQGroupReplyModel.h"

@class WQCommentAndReplyModel;

@interface WQCommentDetailController : UIViewController

/**
 删除回复成功
 */
@property (nonatomic, copy) void(^deleteCommentBlock)();

@property (nonatomic, strong) WQCommentAndReplyModel *model;

@property (nonatomic, retain) NSMutableArray * secondnaryComments;
@property (nonatomic, assign) BOOL commenting;

@property (nonatomic, assign) BOOL isNeedsVC;
@property (nonatomic, copy) NSString * pid;
@end 
