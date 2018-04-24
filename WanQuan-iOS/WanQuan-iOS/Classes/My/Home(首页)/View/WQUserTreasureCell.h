//
//  WQUserTreasureCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TreasureOnclick)();


@interface WQUserTreasureCell : UITableViewCell
@property (nonatomic, copy) TreasureOnclick purseOnclick;
@property (nonatomic, copy) TreasureOnclick creditOnclick;
@property (nonatomic, copy) TreasureOnclick friendOnclick;


@property (nonatomic, strong) UILabel *xinyongfenLabel;
@property (nonatomic, strong) UILabel *qianbaoyueeLabel;
@property (nonatomic, strong) UILabel *haoyouLabel;

- (void)showFriendBadge;
@end
