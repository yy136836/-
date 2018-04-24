//
//  WQTsinghuaMBAView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQTsinghuaMBAView;

@protocol WQTsinghuaMBAViewDelegate <NSObject>

/**
 班级的响应事件

 @param mbaView self
 */
- (void)wqSerialNumberBtnClick:(WQTsinghuaMBAView *)mbaView;

/**
 开始时间和结束时间都确定的回调

 @param mbaView self
 */
- (void)wqMBADetermineTime:(WQTsinghuaMBAView *)mbaView;
@end

@interface WQTsinghuaMBAView : UIView

@property (nonatomic, weak) id <WQTsinghuaMBAViewDelegate> delegate;

/**
 开始时间
 */
@property (nonatomic, strong) UIButton *startTimeBtn;

/**
 到期时间
 */
@property (nonatomic, strong) UIButton *daoqiTimeBtn;

/**
 选择班级的按钮
 */
@property (nonatomic, strong) UIButton *serialNumberBtn;

@end
