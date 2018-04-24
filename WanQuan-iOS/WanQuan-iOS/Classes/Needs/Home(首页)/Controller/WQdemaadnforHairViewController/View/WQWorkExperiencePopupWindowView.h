//
//  WQWorkExperiencePopupWindowView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/3/5.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQWorkExperiencePopupWindowView : UIView

@property (nonatomic, copy) void(^addWorkBlock)();

/**
 下次再说的响应事件
 */
@property (nonatomic, copy) void(^btnClickBlock)();

@end
