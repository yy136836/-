//
//  WQmodifyWorkViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQTwoUserProfileModel;

@interface WQmodifyWorkViewController : UIViewController
@property (nonatomic, retain) NSMutableArray * work;
- (instancetype)initWithType:(NSString *)type modelArray:(NSArray *)modelArray andCurrentIndex:(NSUInteger)index;
@end
