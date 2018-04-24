//
//  WQAlert.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/11.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQAlert : NSObject
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                  duration:(NSTimeInterval)interval;

+(UIAlertController *)showAttributedAlertWith:(NSString *)title
                    titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont
                       message:(NSString *)message
                  messageColor:(UIColor *)messageColor messageFont:(UIFont *)messageFont
                      duration:(NSTimeInterval)interval;



@end
