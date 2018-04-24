//
//  WQmoment_choicest_articleModel.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQmoment_choicest_articleModel.h"

@implementation WQmoment_choicest_articleModel

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
    return [self.like_count integerValue];
}
-(BOOL)essenceFavorited {
    return self.favorited;
}
- (NSString *)essenceCover {
    return self.cover_pic;
}

@end
