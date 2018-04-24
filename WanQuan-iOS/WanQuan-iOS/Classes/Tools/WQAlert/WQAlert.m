//
//  WQAlert.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/11.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQAlert.h"

@implementation WQAlert

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message duration:(NSTimeInterval)interval {
    if (!interval) {
        interval = 1.2;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
//        [[UIApplication sharedApplication].delegate.window.rootViewController.presentedViewController presentViewController:alert animated:YES completion:^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [alert dismissViewControllerAnimated:YES completion:nil];
//            });
//        }];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            
        });
    });
}

+(UIAlertController *)showAttributedAlertWith:(NSString *)title
                    titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont
                       message:(NSString *)message
                  messageColor:(UIColor *)messageColor messageFont:(UIFont *)messageFont
                      duration:(NSTimeInterval)interval {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
//    修改 title
    if (title.length) {
        NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
        
        if (titleColor) {
            
            [alertControllerStr addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, title.length)];
        }
        if (titleFont) {
            
            [alertControllerStr addAttribute:NSFontAttributeName
                                       value:titleFont
                                       range:NSMakeRange(0, title.length)];
        }
        
        if ([self haveKey:@"attributedTitle"]) {
            
            [alert setValue:alertControllerStr forKey:@"attributedTitle"];
        }
    }
    



//修改message
    
    if (message.length) {
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
        
        if (messageColor) {
            [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName
                                              value:messageColor
                                              range:NSMakeRange(0, message.length)];
        }
        
        if (messageFont) {
            
            [alertControllerMessageStr addAttribute:NSFontAttributeName
                                              value:messageFont
                                              range:NSMakeRange(0, message.length)];
        }
        if ([self haveKey:@"attributedMessage"]) {
            
            [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
        }
    }

    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
   
    
    
    if (interval) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(interval * NSEC_PER_SEC)),
                       dispatch_get_main_queue(),
                       ^{
                           [alert dismissViewControllerAnimated:YES completion:nil];
                       });
    }
    
    return alert;
}




+ (BOOL)haveKey:(NSString *)key {
    unsigned int count;
    BOOL flag = NO;

    Ivar* vars = class_copyIvarList([UIAlertController class], &count);
    for (NSInteger i = 0; i<count; i++) {
        Ivar var = vars[i];
        NSString* keyName = [[NSString stringWithCString:ivar_getName(var) encoding:NSUTF8StringEncoding] substringFromIndex:1];
        if ([keyName isEqualToString:[NSString stringWithFormat:@"_%@",key]]) {
            flag = YES;

        }
        if ([keyName isEqualToString:key]) {
            flag = YES;
        }
    }
    return flag;
}

@end
