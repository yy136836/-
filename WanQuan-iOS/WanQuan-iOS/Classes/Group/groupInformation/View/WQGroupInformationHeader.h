//
//  WQGroupInformationHeader.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WQMainNameDelegate <NSObject>

- (void)clickedMainName;

@end

@interface WQGroupInformationHeader : UIView
// 组的头像
@property (nonatomic, strong) UIImageView *groupHeadImageView;
// 群组名称
@property (nonatomic, strong) UILabel *groupNameLabel;
// 群主名称
@property (nonatomic, strong) UILabel *GroupmainName;

@property (nonatomic, copy) void(^isGroupHeadClikeBlock)();


@property (nonatomic,weak)id<WQMainNameDelegate>delegte;


@end
