//
//  WQTool.h
//  WanQuan-iOS
//
//  Created by Shmily on 2018/4/9.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQTool : NSObject

/**
 * 判断tableView 是否滚动了，然后滚动到顶部
 */
+ (void)scrollToTopRow:(UITableView *)curreTableView;

/**
 * 加边框
 */

+ (void)borderForView:(UIView *)originalView color:(UIColor *)color borderWidth:(CGFloat)width borderRadius:(CGFloat)radius;

/**
 * 几天后
 */

+ (NSString *)getLastTime:(long)time;

/**
 * 时间转字符
 */

+ (NSString *)dateToString:(NSDate *)date;

/**
 * 复制链接
 */
+ (void)copy:(UIViewController *)vc urlStr:(NSString *)copyUrl;

/**
 * 好友关系
 */

+ (NSString *)friendship:(NSInteger)degree;

/**
 * 最后期限
 */
+ (NSString *)getFinishTime:(NSInteger)time;
/**
 * 评论时间
 */
+(NSString *)getCommentTime:(NSInteger)time;

@end
