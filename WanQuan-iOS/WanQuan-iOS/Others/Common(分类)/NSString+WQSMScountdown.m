//
//  NSString+WQSMScountdown.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/18.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "NSString+WQSMScountdown.h"

@implementation UIButton (WQSMScountdown)
-(void)statWithTimeout:(NSInteger)timeout eventhandler:(void (^)(NSInteger))index
{
    __block NSInteger time = timeout; //倒计时时间
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(timer, ^{
        
        //回调结果
        if (index) {
            index(time);
        }
        
        if(time<=0){ //倒计时结束，关闭
            dispatch_source_cancel(timer);
        }else{
            time --;
        }
    });
    
    dispatch_resume(timer);
}
@end
