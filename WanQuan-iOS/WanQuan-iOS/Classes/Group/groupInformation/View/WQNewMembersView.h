//
//  WQNewMembersView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQNewMembersView : UIView

// 红点的数量
@property (nonatomic, strong) UILabel *redLabel;

@property (nonatomic, copy) NSString *groupId;
// 需要刷新数据
@property (nonatomic, copy) void(^isLoadDataBlock)();
@end
