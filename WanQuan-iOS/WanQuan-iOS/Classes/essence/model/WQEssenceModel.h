//
//  WQEssenceModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/26.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQEssenceArticleModel.h"
#import "WQEssenceDataEntity.h"
/**
 TODO
 */
@interface WQEssenceModel : NSObject<WQEssenceDataEntity>

/**
 是否可以赞
 */
@property (nonatomic, assign) BOOL can_like;

/**
 //createtime true string 创建时间
 */
@property (nonatomic, copy) NSString * createtime;

/**
 user_tag true array[string] 作者的标签
 */
@property (nonatomic, retain) NSArray * user_tag;

/**
 modifytime true string 修改时间
 */
@property (nonatomic, copy) NSString * modifytime;

/**
 user_name true string 作者姓名
 */
@property (nonatomic, copy) NSString * user_name;

/**
 user_idcard_status true string 作者身份状态
 */
@property (nonatomic, copy) NSString * user_idcard_status;

/**
 user_pic true string 作者头像
 */
@property (nonatomic, copy) NSString * user_pic;

/**
 user_id true string 作者ID
 */
@property (nonatomic, copy) NSString * user_id;

/**
 user_degree true number 作者好友度数
 */
@property (nonatomic, retain) NSNumber * user_degree;

/**
 user_creditscore true number 作者信用分
 */
@property (nonatomic, retain) NSNumber * user_creditscore;

/**
 //modifytime_past_second true number 创建时间距离当前时间的秒数
 */
@property (nonatomic, retain) NSNumber * createtime_past_second;

/**
 //modifytime_past_second true number 修改时间距离当前时间的秒数
 */
@property (nonatomic, retain) NSNumber * modifytime_past_second;

/**
 id true string 精选ID
 */
@property (nonatomic, copy) NSString * id;

/**
 category true string 精选类别：CATEGORY_ARTICLE=精选文章
 */
@property (nonatomic, copy) NSString * category;

/**
 choicest_article true object 精选文章的相关内容
 */
@property (nonatomic, retain) WQEssenceArticleModel * choicest_article;


//"favorite_id" = "";

/**
 不知道有啥用
 */
@property (nonatomic, copy) NSString * favorite_id;
//favorited = 0;

@property (nonatomic, assign) BOOL favorited;

- (void)setEssenceLikeCount:(NSInteger)essenceLikeCount;

@end
