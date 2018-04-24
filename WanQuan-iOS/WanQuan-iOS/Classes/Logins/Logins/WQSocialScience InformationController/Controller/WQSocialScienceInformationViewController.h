//
//  WQSocialScienceInformationViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SocialScienceType) {
    // 清华MBA校友
    MBA = 0,
    // 清华社科学院校友
    SocialScience,
    // 以上都不是
    AreNot,
};

@interface WQSocialScienceInformationViewController : UIViewController

@property (nonatomic, assign) SocialScienceType type;

@end
