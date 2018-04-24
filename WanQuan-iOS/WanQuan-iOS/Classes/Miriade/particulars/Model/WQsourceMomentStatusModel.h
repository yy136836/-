//
//  WQsourceMomentStatusModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/26.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQsourceMomentStatusModel : NSObject
//原状态发布者头像
@property(nonatomic,copy)NSString *user_pic;
//原状态发布者 id
@property(nonatomic,copy)NSString *user_id;
//原状态发布者姓名
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

/**
 原创内容是否被删除
 */
@property (nonatomic, assign) BOOL deleted;

@end
