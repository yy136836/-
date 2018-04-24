//
//  WQLoadingError.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/25.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQLoadingError : UIView

@property (nonatomic, copy) void(^clickRetryBtnClickBlock)();

- (void)dismiss;

- (void)show;

@end
