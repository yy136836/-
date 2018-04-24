//
//  WQaccountDetailsModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/9.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQaccountDetailsModel : NSObject

//交易时间
@property(nonatomic,copy)NSString *posttime;
//交易金额
@property(nonatomic,assign)float money;
//交易信息
@property(nonatomic,copy)NSString *message;
//交易类型
@property(nonatomic,copy)NSString *type;
@end
