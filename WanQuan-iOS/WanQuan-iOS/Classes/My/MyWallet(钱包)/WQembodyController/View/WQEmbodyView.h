//
//  WQEmbodyView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQEmbodyView;

@protocol WQEmbodyViewDelegate <NSObject>

/**
 提现的响应事件

 @param embodyView self
 */
- (void)wqDescriptionBtnClick:(WQEmbodyView *)embodyView;
@end

@interface WQEmbodyView : UIView

@property (nonatomic, weak) id <WQEmbodyViewDelegate> delegate;

/**
 可用余额
 */
@property (nonatomic, strong) UILabel *availableBalanceLabel;

/**
 账号
 */
@property (nonatomic, strong) UITextField *accountTextField;

/**
 姓名
 */
@property (nonatomic, strong) UITextField *nameTextField;

/**
 提现金额
 */
@property (nonatomic, strong) UITextField *embodyTextField;

/**
 是支付宝还是微信
 */
@property (nonatomic, copy) NSString *state;
@end
