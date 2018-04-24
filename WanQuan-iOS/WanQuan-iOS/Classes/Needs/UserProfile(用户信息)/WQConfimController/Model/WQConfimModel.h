//
//  WQConfimModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/8.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQConfimModel : NSObject
//true_name false string
//pic_truename false string 真名头像ID,32位的头像照片ID
//idcard false string
//idcard_pic false string

/**
 //true_name false string 真实姓名
 */
@property (nonatomic, copy) NSString * true_name;

/**
 真实头像 id
 */
@property (nonatomic, copy) NSString * pic_truename;

/**
 身份证号
 */
@property (nonatomic, copy) NSString * idcard;

/**
 身份证照片
 */
@property (nonatomic, copy) NSString * idcard_pic;

@end
