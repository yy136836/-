//
//  WQMyWalletModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/30.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQMyWalletModel : NSObject
//可用金额
@property(nonatomic,assign)float useable_money;
//冻结金额
@property(nonatomic,assign)float frozen_money;
//总金额
@property(nonatomic,assign)float total_money;
@end
