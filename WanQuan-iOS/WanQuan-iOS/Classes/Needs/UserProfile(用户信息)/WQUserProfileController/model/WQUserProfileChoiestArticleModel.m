//
//  WQUserProfileChoiestArticleModel.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUserProfileChoiestArticleModel.h"

@implementation WQUserProfileChoiestArticleModel
- (void)setEssenceId:(NSString *)essenceId {
    
}
- (void)setEssenceDesc:(NSString *)essenceDesc {
    
}
- (void)setEssenceSubject:(NSString *)essenceSubject {
    
}
- (void)setEssenceLikeCount:(NSInteger)essenceLikeCount {
    
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
    return self.desc;
}
- (NSString * )essenceSubject{
    return self.subject;
}
- (NSInteger)essenceLikeCount {
    return self.like_count;
}
-(BOOL)essenceFavorited {
    return self.favorited;
}

- (NSString *)essenceCover {
    return self.carousel_pic;
}
@end
