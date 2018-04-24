//
//  WQfriendsModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WQfriend_listModel;

@interface WQfriendsModel : NSObject
@property (nonatomic, copy) NSString *first_spell;
@property (nonatomic, copy) NSString *true_name;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, strong) NSArray *tag;
@property (nonatomic, strong) NSMutableArray <WQfriend_listModel *>*friend_list;
@property (nonatomic, copy) NSString * pic_truename;
@end
