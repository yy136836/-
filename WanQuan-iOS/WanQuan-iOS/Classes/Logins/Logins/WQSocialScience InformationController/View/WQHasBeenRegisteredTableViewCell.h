//
//  WQHasBeenRegisteredTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQHasJoinedWanQuanModel,WQNoneOfTheAboveModel;

@interface WQHasBeenRegisteredTableViewCell : UITableViewCell

@property (nonatomic, strong) WQHasJoinedWanQuanModel *model;

@property (nonatomic, strong) WQNoneOfTheAboveModel *noneOfTheAboveModel;

@end
