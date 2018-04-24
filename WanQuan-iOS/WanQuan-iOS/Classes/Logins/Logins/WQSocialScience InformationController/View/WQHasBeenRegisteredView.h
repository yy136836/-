//
//  WQHasBeenRegisteredView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SocialType) {
    // 清华MBA校友
    MBAs = 0,
    // 清华社科学院校友
    SocialSciences,
    // 以上都不是
    AreNots,
};

@interface WQHasBeenRegisteredView : UIView

@property (nonatomic, assign) SocialType type;

/**
 已加入万圈人数
 */
@property (nonatomic, copy) NSString *presonCount;

/**
 模型数组
 */
@property (nonatomic, strong) NSArray *modelDataArray;

/**
 以上都不是的模型
 */
@property (nonatomic, strong) NSArray *noneOfTheAboveArray;

@end
