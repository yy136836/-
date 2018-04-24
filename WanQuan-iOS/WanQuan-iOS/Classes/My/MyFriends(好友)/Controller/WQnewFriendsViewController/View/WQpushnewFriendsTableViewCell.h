//
//  WQpushnewFriendsTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQnewFriendsModel,WQmyFriendsModel;

@interface WQpushnewFriendsTableViewCell : UITableViewCell

@property (nonatomic, strong) WQnewFriendsModel *model;
@property (nonatomic, strong) WQmyFriendsModel *myFriendsModel;

@property (nonatomic, copy) void (^agreeBtnClikeBlock)();
@end
