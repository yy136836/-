//
//  WQMessageModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQMessageModel : NSObject
@property (nonatomic, retain)EMMessage * last;

/**
 对话人的名称
 */
@property (nonatomic, copy) NSString * chatterName;

/**
 对话人的头像
 */
@property (nonatomic, copy) NSString * picId;

/**
 对话的类型
 */
@property (nonatomic, copy) NSString * messageType;

/**
 最后一次收到的消息
 */
@property (nonatomic, copy) NSString * lastRecievedMessageConttent;

/**
  最后一次收到的消息的相关的需求信息
 */
@property (nonatomic, copy) NSString * lastRecievedMessageNeedInfo;

@end
