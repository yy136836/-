//
//  WQGroupSwitchDataEntity.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQUserProfileGroupModel.h"


/**
 保存个人页面群组栏所有子开关的状态
 */
@interface WQGroupSwitchDataEntity : NSObject

+ (instancetype)sharedEntity;
- (BOOL)switchStatusForGroup:(NSString *)gid;
- (void)updateGroupSwitchStatusWith:(NSArray <WQUserProfileGroupModel *>*)groupsInfo;
@end
