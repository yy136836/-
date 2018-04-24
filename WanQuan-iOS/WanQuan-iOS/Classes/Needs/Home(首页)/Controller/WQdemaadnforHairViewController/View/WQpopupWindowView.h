//
//  WQpopupWindowView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/10.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQpopupWindowView;

@protocol WQpopupWindowViewDelegate <NSObject>

- (void)wqPopupWindowView:(WQpopupWindowView *)popupWindowView TotalAmountOf:(NSString *)totalAmountOf aSinglePayment:(NSString *)aSinglePayment theTotalAmountOf:(NSString *)theTotalAmountOf;

/**
 确定的响应事件
 
 @param popupWindowView self
 @param totalString 总金额
 @param personNum 人数
 @param moneyString 金额
 */
- (void)wqDetermineBtnClick:(WQpopupWindowView *)popupWindowView totalString:(NSString *)totalString personNum:(NSString *)personNum moneyString:(NSString *)moneyString;

@end

@interface WQpopupWindowView : UIView

@property (nonatomic, weak) id <WQpopupWindowViewDelegate> delegate;

@property (nonatomic, strong) UITextField *theNumberOfTransactionsTextField;
@property (nonatomic, strong) UITextField *aSinglePaymentTextField;
@property (nonatomic, strong) UITextField *theTotalAmountOfTextField;
@property (nonatomic, assign) BOOL isBBS;

@property (nonatomic, copy) void (^returnBtnClikeBlock)();

@end
