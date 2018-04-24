//
//  NSDictionary+WQEqual.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/4.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WQEqual)

/**
 该方法仅用于环信聊天里面的 ext 是否相同的判断字典的相同的

 @param dic 需要与自己相比较的字典
 @return 判断字典的相同
 */
- (BOOL)WQ_equalTo:(NSDictionary *)dic;

@end
