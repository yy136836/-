//
//  WQbiddingTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/12.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZLBadgeImport.h"
@class WQWaitOrderModel;
@interface WQbiddingTableViewCell : UITableViewCell<WZLBadgeProtocol>
@property (nonatomic, strong) WQWaitOrderModel *model;

/**
 中间的线
 */
@property (strong, nonatomic) IBOutlet UIButton *agreedToCancelBtn;

/**
 完成申请付款
 */
@property (strong, nonatomic) IBOutlet UIButton *completeBtn;
@property (strong, nonatomic) IBOutlet UIView *redDotView;
@property (nonatomic, copy) void(^billingPresonClikeBlock)();
@property (nonatomic, copy) void(^completeBlick)();
@property (nonatomic, copy) void(^agreedToCancelBlock)();

/**
 橘黄色的图
 */
@property (strong, nonatomic) IBOutlet UIImageView *orangeEdges;

/**
 黄的图
 */
@property (strong, nonatomic) IBOutlet UIImageView *yellowEdges;

/**
 对方已申请取消交易
 */
@property (strong, nonatomic) IBOutlet UILabel *promptLabel;
@end

