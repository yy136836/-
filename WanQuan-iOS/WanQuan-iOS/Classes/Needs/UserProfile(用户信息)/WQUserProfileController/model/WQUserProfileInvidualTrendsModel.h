//
//  WQUserProfileInvidualTrendsModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQUserProfileMomentModel.h"
#import "WQUserProfileChoiestArticleModel.h"
@interface WQUserProfileInvidualTrendsModel : NSObject

/**
 TYPE_MOMENT_STATUS=万圈状态；TYPE_CHOICEST_ARTICLE=精选文章；TYPE_MOMENT_USER=感兴趣用户
 */
@property (nonatomic, copy) NSString * moment_type;
@property (nonatomic, retain) WQUserProfileChoiestArticleModel * moment_choicest_article;
@property (nonatomic, retain) WQUserProfileMomentModel * moment_status;
@end
