//
//  WQconfirmsModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/10.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQconfirmsModel : NSObject
//用户信用分
@property (nonatomic, strong) NSNumber *credit_score;
//标签列表
@property (nonatomic, strong) NSArray *tag;
//信用分详情
@property (nonatomic, strong) id credit_detail;
//真名头像
@property (nonatomic, copy) NSString *pic_truename;
//帮忙认证时间
@property (nonatomic, copy) NSString *posttime;
//工作方向、行业
@property (nonatomic, copy) NSString *work_type;
//工作职务
@property (nonatomic, copy) NSString *work_title;
//工作区域
@property (nonatomic, copy) NSString *work_area;
//工作单位地址
@property (nonatomic, copy) NSString *work_addr_name;
//花名头像
@property (nonatomic, copy) NSString *pic_flowername;
//花名
@property (nonatomic, copy) NSString *flower_name;
//工作单位
@property (nonatomic, copy) NSString *work_unit;
//真名
@property (nonatomic, copy) NSString *true_name;

@end
