//
//  WQdynamicHomeModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQmoment_statusModel.h"
#import "WQmoment_choicest_articleModel.h"
#import "WQPeopleWhoAreInterestedInModel.h"

@class WQmoment_choicest_articleModel,WQPeopleWhoAreInterestedInModel;

@interface WQdynamicHomeModel : NSObject

/**
 TYPE_MOMENT_STATUS=万圈状态；TYPE_CHOICEST_ARTICLE=精选文章  TYPE_MOMENT_USER=感兴趣的人
 */
@property (nonatomic, copy) NSString *moment_type;

/**
 TYPE_MOMENT_STATUS=万圈状态时
 */
@property (nonatomic, strong) WQmoment_statusModel *moment_status;

/**
 TYPE_CHOICEST_ARTICLE=精选文章时
 */
@property (nonatomic, strong) WQmoment_choicest_articleModel *moment_choicest_article;

/**
 TYPE_MOMENT_USER=感兴趣的人
 */
@property (nonatomic, strong) NSArray <WQPeopleWhoAreInterestedInModel *>*moment_users;

@end
