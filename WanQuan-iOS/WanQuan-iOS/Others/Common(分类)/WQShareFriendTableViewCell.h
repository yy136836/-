//
//  WQShareFriendTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/7.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQfriend_listModel;

@interface WQShareFriendTableViewCell : UITableViewCell

@property (nonatomic, retain) WQfriend_listModel * model;

@property (nonatomic, strong) UIImageView *duihaoImageView;

@end
