//
//  WQEssenceDataEntity.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WQEssenceDataEntity <NSObject>
@required
/**
 精选的 id
 */
 -(NSString *)essenceId;

/**
 精选的描述
 */
- (NSString *)essenceDesc;

/**
 精选的标题
 */
- (NSString *)essenceSubject;

/**
 赞的总数
 */
- (NSInteger)essenceLikeCount;

/**
 是否已经收藏
 */
- (BOOL)essenceFavorited;
- (void)setEssenceFavorited:(BOOL)essenceFavorited;

- (NSString *)essenceCover;

- (BOOL)can_like;

- (NSString *)user_id;

@end
