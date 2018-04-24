//
//  WQReceivinganOrderTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/7.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZLBadgeImport.h"
@class WQWaitOrderModel;
@interface WQReceivinganOrderTableViewCell : UITableViewCell<WZLBadgeProtocol>
@property(nonatomic,strong)WQWaitOrderModel *model;
@property (strong, nonatomic) UIView *redDotView;
@property(nonatomic,copy)void(^billingPresonClikeBlock)();
@end
