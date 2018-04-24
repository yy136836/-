//
//  WQfeedbackViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

//类型（TYPE_NEED：需求投诉，TYPE_MOMENT：万圈投诉，TYPE_GROUP_TOPIC：群主题投诉；TYPE_ADVICE：建议） TYPE_CHOICEST_ARTICLE: 精选投诉

typedef NS_ENUM(NSInteger, WQFeedbackType) {
    TYPE_NEED = 0,
    TYPE_MOMENT,
    TYPE_GROUP_TOPIC,
    TYPE_ADVICE,
    TYPE_CHOICEST_ARTICLE
};

@interface WQfeedbackViewController : UIViewController
// @property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) WQFeedbackType feedbackType;
@end
