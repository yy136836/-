//
//  WQToChooseTimeView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/2/26.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQToChooseTimeView : UIView

@property (nonatomic, copy) void(^toChooseTimeBlock)(NSString *timeString);

@end
