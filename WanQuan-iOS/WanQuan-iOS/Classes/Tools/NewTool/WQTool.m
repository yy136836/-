//
//  WQTool.m
//  WanQuan-iOS
//
//  Created by Shmily on 2018/4/9.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQTool.h"

@implementation WQTool

+ (void)scrollToTopRow:(UITableView *)curreTableView
{
    if (curreTableView) {
        
        //CGFloat contentOffsetY = curreTableView.contentOffset.y;
        [curreTableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
    
}



+ (void)borderForView:(UIView *)originalView color:(UIColor *)color borderWidth:(CGFloat)width borderRadius:(CGFloat)radius
{
        originalView.layer.masksToBounds = YES;
        originalView.layer.borderWidth = width;
        originalView.layer.cornerRadius = radius;
        originalView.layer.borderColor = color.CGColor;
}


+ (NSString *)getLastTime:(long)time
{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];
    // 当前时间秒数加上七天的秒数
    long seconds = [timeString longLongValue] + time;
    NSDate  *date1 = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    // 最终时间
    NSString *endTime = [dateformatter stringFromDate:date1];
    return endTime;
}

 + (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    return [dateFormatter stringFromDate:date];
}

+ (void)copy:(UIViewController *)vc urlStr:(NSString *)copyUrl{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = copyUrl;
    [UIAlertController wqAlertWithController:vc addTitle:nil andMessage:@"已复制至剪切板" andAnimated:YES andTime:1];
}

+ (NSString *)friendship:(NSInteger)degree
{
    NSString *user_degree;
    if (degree == 0) {
        user_degree = [@" " stringByAppendingString:[@"自己" stringByAppendingString:@" "]];
    }else if (degree <= 2) {
        user_degree = [@" " stringByAppendingString:[@"2度内好友" stringByAppendingString:@" "]];
    }else if (degree == 3) {
        user_degree = [@" " stringByAppendingString:[@"3度好友" stringByAppendingString:@" "]];
    }else {
        user_degree = [@" " stringByAppendingString:[@"4度外好友" stringByAppendingString:@" "]];
    }
    return  user_degree;
}

+ (NSString *)getFinishTime:(NSInteger)time
{
    NSString *lastTime;
    if (time < 0) {
        lastTime = [NSString stringWithFormat:@"已完成"];
    }else if (time < 3600) {
        lastTime = [NSString stringWithFormat:@"%zd分钟到期",time / 60];
    }else if (time / (60 * 60 * 24) >= 1) {
        lastTime = [NSString stringWithFormat:@"%zd天到期",time / (60 * 60 * 24)];
    }else{
        lastTime = [NSString stringWithFormat:@"%zd小时到期",time / 3600];
    }
    return lastTime;
}

+(NSString *)getCommentTime:(NSInteger)time
{
    if (time < 60) {
        return  [NSString stringWithFormat:@"刚刚"];
    }else if (time < 3600) {
        return [NSString stringWithFormat:@"%zd分钟前",time / 60];
    }else if (time / (60 * 60 * 24) >= 1) {
        return [NSString stringWithFormat:@"%zd天前",time / (60 * 60 * 24)];
    }else{
        return [NSString stringWithFormat:@"%zd小时前",time / 3600];
    }
}


@end
