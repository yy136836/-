//
//  WQGroupForwardView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/6.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYLabel;

@interface WQGroupForwardView : UIView
// 附加信息
@property (nonatomic, strong) YYLabel *additionalInformationLabel;
// 群组头像
@property (nonatomic, strong) UIImageView *groupHeadPortrait;
// 群名称
@property (nonatomic, strong) YYLabel *nameLabel;
// 群介绍
@property (nonatomic, strong) YYLabel *groupIntroduceLabel;
@end
