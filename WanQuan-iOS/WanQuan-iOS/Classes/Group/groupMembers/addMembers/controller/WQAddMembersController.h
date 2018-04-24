//
//  WQAddMembersController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>




/**
 群组添加或者删除成员
 */
@interface WQAddMembersController : UIViewController

/**
  yes 为删除好友, no 为增加好友
 */
@property (nonatomic, assign) BOOL deleteType;

/**
 群组的 ID
 */
@property (nonatomic, copy) NSString * gid;

/**
 当为删除好友时该字段必传
 */
@property (nonatomic, retain) NSArray * currentMembes;
@end
