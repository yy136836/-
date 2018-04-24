//
//  WQfriend_listModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQfriend_listModel : NSObject
@property (nonatomic, strong) NSArray *tag;
@property (nonatomic, copy) NSString *true_name;
@property (nonatomic, copy) NSString *pic_truename;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, assign) CGFloat creditscore;




//pic_truename true string 真实头像id
//creditscore true number 信用分
//degree true number 好友度数
//work_type true string
//work_title true string
//work_area true string
//work_addr_name true string
//pic_flowername true string
//flower_name true string
//work_unit true string
//user_id true string
//true_name true string 真实姓名
//common_friend_count true number 共同好友数量
//tag true array[string] 用户标签

@end
