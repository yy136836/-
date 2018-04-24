//
//  WQRegionSelectSearchViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 home-> 最新->选择城市->搜索位置
 */
@interface WQRegionSelectSearchViewController : UIViewController
@property(nonatomic,copy)void(^dismisBlock)();
@end
