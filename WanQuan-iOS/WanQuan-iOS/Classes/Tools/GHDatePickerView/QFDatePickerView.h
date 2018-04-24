//
//  QFDatePickerView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/3/3.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QFDatePickerView : UIView

- (instancetype)initDatePackerWithResponse:(void(^)(NSString*))block isToday:(BOOL)isWhetherToday;

- (void)show;

@property (nonatomic, copy) void(^hindBlock)();

@end
