//
//  WQNeedsSecondaryReplyModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/3/13.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQNeedsSecondaryReplyModel : NSObject

/*
 neeID": "4bb828e79c824663a6422b65ede75a4a",
 "needUser": "郭杭",
 "needTitle": "【问事】求推荐cxc"
 */

@property (nonatomic, copy) NSString *neeID;

@property (nonatomic, copy) NSString *needUser;

@property (nonatomic, copy) NSString *needTitle;

@end
