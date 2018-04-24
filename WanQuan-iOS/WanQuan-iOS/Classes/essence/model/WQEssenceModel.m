//
//  WQEssenceModel.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/26.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQEssenceModel.h"

@implementation WQEssenceModel
- (void)setEssenceId:(NSString *)essenceId {
    
}
- (void)setEssenceDesc:(NSString *)essenceDesc {
    
}
- (void)setEssenceSubject:(NSString *)essenceSubject {
    
}
- (void)setEssenceLikeCount:(NSInteger)essenceLikeCount {
    WQEssenceArticleModel * model = [WQEssenceArticleModel new];
    model.like_count = essenceLikeCount;
    
    if (self.choicest_article) {
        self.choicest_article.like_count = essenceLikeCount;
    } else {
        self.choicest_article = model;
    }
    
    
}

- (void)setEssenceFavorited:(BOOL)essenceFavorited {
    _favorited = essenceFavorited;
}

- (void)setEssenceCover:(NSString *)essenceCover {
    
}

- (NSString * )essenceId {
    return self.id;
}
- (NSString * )essenceDesc {
    return self.choicest_article.desc;
}
- (NSString * )essenceSubject{
    return self.choicest_article.subject;
}
- (NSInteger)essenceLikeCount {
    return self.choicest_article.like_count;
}
-(BOOL)essenceFavorited {
    return self.favorited;
}
- (NSString *)essenceCover {
    return self.choicest_article.cover_pic;
}

- (BOOL)can_like {
    return self.choicest_article.can_like;
}

- (NSString *)user_id {
    return self.choicest_article.user_id;
}

@end
