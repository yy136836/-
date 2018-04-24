//
//  WQGroupSwitchDataEntity.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupSwitchDataEntity.h"

@interface WQGroupSwitchDataEntity()
@property (nonatomic, retain) NSMutableDictionary * switchStatus;
@end


@implementation WQGroupSwitchDataEntity

+ (instancetype)sharedEntity {
    static dispatch_once_t onceToken;
    static WQGroupSwitchDataEntity * entity;
    dispatch_once(&onceToken, ^{
        if (!entity) {
            entity = [[self alloc] init];
            entity.switchStatus = @{}.mutableCopy;
        }
    });
    return entity;
}

- (void)updateGroupSwitchStatusWith:(NSArray<WQUserProfileGroupModel *> *)groupsInfo {
    for (WQUserProfileGroupModel * model in groupsInfo) {
        self.switchStatus[model.gid] = @(model.public_show);
    }
}

- (BOOL)switchStatusForGroup:(NSString *)gid {
    BOOL ret = [_switchStatus[gid] boolValue];
    
    return ret;
}

@end
