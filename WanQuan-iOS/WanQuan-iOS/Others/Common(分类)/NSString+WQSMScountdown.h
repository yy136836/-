//
//  NSString+WQSMScountdown.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/18.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WQSMScountdown)
/**
 *  开启倒计时
 *
 *  @param timeout 倒计时总时间
 *  @param index   当前剩余时间
 */
- (void)statWithTimeout:(NSInteger)timeout eventhandler:(void(^) (NSInteger timeout))index;

@end
