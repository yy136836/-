//
//  WQDetailsTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQHomeNearby;

@class WQPeopleListModel;

@interface WQDetailsTableViewCell : UITableViewCell

@property (nonatomic, strong) WQHomeNearby *model;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic, copy) void(^confirmBtnClikeBlock)();

@property (nonatomic, strong) WQPeopleListModel *peopleListModel;

@end
