//
//  WQNearbyroboneTabViewcell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/23.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQHomeNearby;

@interface WQNearbyroboneTabViewcell : UITableViewCell
@property (nonatomic, strong) WQHomeNearby *model;

@property (nonatomic, strong) UITextView *superiorityTextView;

@property (nonatomic, copy) void (^boolwhetheranonBlock)(BOOL);

@end

