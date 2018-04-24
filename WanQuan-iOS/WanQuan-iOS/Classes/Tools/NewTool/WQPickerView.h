//
//  WQPickerView.h
//  WanQuan-iOS
//
//  Created by Shmily on 2018/4/10.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WQDatePickerDelegate<NSObject>

- (void)didSelectDate:(NSString *)dateStr;

@end
@interface WQPickerView : UIView
{
    NSString *_selectDate;
}

@property (nonatomic,weak)id<WQDatePickerDelegate>delegate;

- (void)show;
- (void)dismis;


@end
