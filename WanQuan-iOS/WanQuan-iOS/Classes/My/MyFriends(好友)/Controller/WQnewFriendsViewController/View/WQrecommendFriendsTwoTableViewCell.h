//
//  WQrecommendFriendsTwoTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQfriend_listModel;

@interface WQrecommendFriendsTwoTableViewCell : UITableViewCell
@property (nonatomic, strong) WQfriend_listModel *model;
@property (nonatomic, copy) void (^friendsAddBtnClikeBlock)();
@end
