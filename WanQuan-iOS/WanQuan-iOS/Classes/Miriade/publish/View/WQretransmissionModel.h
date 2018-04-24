//
//  WQ retransmissionModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/15.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQretransmissionModel : NSObject
/**
 * 原状态简介（如果是转发）
 **/
//原状态用户头像
@property(nonatomic,copy)NSString *user_pic;
//原状态用户 id
@property(nonatomic,copy)NSString *user_id;
//原状态用户姓名
@property(nonatomic,copy)NSString *user_name;
//原状态 id
@property(nonatomic,copy)NSString *id;
//原状态图片
@property(nonatomic,strong)NSArray *pic;
//原状态内容
@property(nonatomic,copy)NSString *content;
@property (nonatomic, copy) NSString *link_url;
@property (nonatomic, copy) NSString *link_txt;
@property (nonatomic, copy) NSString *link_img;
@end
