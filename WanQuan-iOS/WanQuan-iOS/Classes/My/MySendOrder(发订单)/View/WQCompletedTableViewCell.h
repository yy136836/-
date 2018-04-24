//
//  WQCompletedTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/12.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQWaitOrderModel;
@interface WQCompletedTableViewCell : UITableViewCell
@property (nonatomic, strong) WQWaitOrderModel *waitorderModel;

@property (nonatomic, copy) void(^applicationForDrawbackBtnClikeBlock)();
@end

