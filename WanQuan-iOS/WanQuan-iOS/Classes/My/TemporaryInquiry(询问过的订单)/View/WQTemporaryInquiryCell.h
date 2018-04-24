//
//  WQTemporaryInquiryCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQWaitOrderModel;

@interface WQTemporaryInquiryCell : UITableViewCell

@property (nonatomic, strong) WQWaitOrderModel *waitorderModel;

/**
 红点
 */
@property (strong, nonatomic) UIView *redDotView;

/**
 联系发单人按钮
 */
@property (strong, nonatomic) UIButton *contactBiderButton;

@property (nonatomic, copy) void(^personnelClikeBlock)();
@end
