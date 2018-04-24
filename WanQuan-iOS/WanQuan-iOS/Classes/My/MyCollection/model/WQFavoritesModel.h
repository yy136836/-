//
//  WQFavoritesModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/10/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQFavoritesModel : NSObject
//favorite_id true string 收藏自身ID（暂无用）
@property (nonatomic, copy) NSString * favorite_id;
//favorite_createtime true string 收藏时间
@property (nonatomic, copy) NSString * favorite_createtime;
//favorite_target_id true string 收藏目标的ID
@property (nonatomic, copy) NSString * favorite_target_id;
//favorite_type true string 收藏目标的类型（TYPE_CHOICEST_ARTICLE=精选文章）
@property (nonatomic, copy) NSString * favorite_type;
//favorite_pic true string 收藏目标的图标
@property (nonatomic, copy) NSString * favorite_pic;
//favorite_title true string 收藏目标的标题
@property (nonatomic, copy) NSString * favorite_title;
//favorite_desc true string 收藏目标的描述
@property (nonatomic, copy) NSString * favorite_desc;

@end
