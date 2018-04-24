//
//  WQEssenceArticleModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/10/9.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQEssenceArticleModel : NSObject

@property (nonatomic, copy) NSString *user_id;

/**
 是否可以赞
 */
@property (nonatomic, assign) BOOL can_like;
/**
 //carousel_pic true string 轮播图
 */
@property (nonatomic, copy) NSString * carousel_pic;

/**
 //subject true string 标题
 */
@property (nonatomic, copy) NSString * subject;

/**
 //cover_pic true string 封面图
 */
@property (nonatomic, copy) NSString * cover_pic;


/**
 //description true string 描述
 */
@property (nonatomic, copy) NSString * desc;

/**
 views true number 浏览次数
 */
@property (nonatomic, retain) NSNumber * views;

//tags true array[string] 标签
@property (nonatomic, retain) NSArray * tags;



/**
 点赞数
 */
@property (nonatomic, assign) NSInteger like_count;

@end
