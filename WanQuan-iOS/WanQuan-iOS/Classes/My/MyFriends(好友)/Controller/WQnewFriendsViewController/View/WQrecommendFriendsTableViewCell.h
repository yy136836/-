//
//  WQrecommendFriendsTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,NewFriendType){
    NewFriendTypeToAgree,
    NewFriendTypeToAddressBook,
    NewFriendTypeToRecommond
    
};

@class WQrecommendnewFriendsModel,WQfriend_listModel;

@interface WQrecommendFriendsTableViewCell : UITableViewCell
@property (nonatomic, strong) WQrecommendnewFriendsModel *model;
@property (nonatomic, strong) WQfriend_listModel *friend_listModel;
@property (nonatomic, assign) NewFriendType type;
@property (nonatomic, strong) UILabel *additionalInformationLabel;

@property (nonatomic, copy) void (^friendsAddBtnClikeBlock)();
@end
