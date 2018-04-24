//
//  WQAreaCodeModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/11.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WQAreaCodeListModel;

@interface WQAreaCodeModel : NSObject

@property (nonatomic, strong) NSMutableArray <WQAreaCodeListModel *>*list;

@property (nonatomic, copy) NSString *first_spell;

@end
