//
//  WQAreNotView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQAreNotView;

@protocol WQAreNotViewDelegate <NSObject>
/**
 学位的响应事件
 
 @param areNotView self
 */
- (void)wqAreNotViewSelectedADegreeInBtnClick:(WQAreNotView *)areNotView;
@end

@interface WQAreNotView : UIView

@property (nonatomic, weak) id <WQAreNotViewDelegate> delegate;

@property (nonatomic, copy) void(^areNotViewSelectedADegreeInBtnClickBlock)();

/**
 学校的输入框
 */
@property (nonatomic, strong) UITextField *schoolTextField;

/**
 专业的输入框
 */
@property (nonatomic, strong) UITextField *professionalTextField;

/**
 学位的输入框
 */
//@property (nonatomic, strong) UITextField *aDegreeinTextField;

/**
 开始时间的按钮
 */
@property (nonatomic, strong) UIButton *startTimeBtn;

/**
 到期时间的按钮
 */
@property (nonatomic, strong) UIButton *daoqiTimeBtn;

/**
 学位
 */
@property (nonatomic, strong) UIButton *selectedADegreeInBtn;

@end
