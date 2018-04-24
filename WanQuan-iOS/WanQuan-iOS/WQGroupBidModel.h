//
//  WQGroupBidModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/6.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQGroupBidModel : NSObject
@property (nonatomic, assign)BOOL truename;
@property (nonatomic, copy) NSString * user_name;
@property (nonatomic, copy) NSString * user_id;
@property (nonatomic, copy) NSString * user_pic;

@property (nonatomic, assign) BOOL can_bid;

@end
