//
//  WQHomeNearby.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/2.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQHomeNearby.h"

@implementation WQHomeNearby

- (void)setPic:(NSArray *)pic {
    _pic = pic;
    self.imageArray = [NSMutableArray array];
    NSString *picrulString = @"file/download";
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    tools.responseSerializer =  [AFHTTPResponseSerializer serializer];
    
    dispatch_group_t group =  dispatch_group_create();
    
    for (NSString *imageId in _pic) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        dict[@"fileID"] = imageId;
        dispatch_group_enter(group);
        [tools request:WQHttpMethodPost urlString:picrulString parameters:dict completion:^(id response, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                dispatch_group_leave(group);
                return ;
            }
            UIImage *image = [UIImage imageWithData:response];
            if (image) {
                [self.imageArray addObject:image];
            }
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (self.imagesBlock) {
            self.imagesBlock();
        }
    });
}

@end
