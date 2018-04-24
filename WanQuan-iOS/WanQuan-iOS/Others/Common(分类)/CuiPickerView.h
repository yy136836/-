//
//  CuiPickerView.h
//  CXB
//
//  Created by 郭杭 on 17/1/14.
//  Copyright © 2016年 郭杭. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol CuiPickViewDelegate <NSObject>
- (void)didFinishPickView:(NSString*)date;
- (void)pickerviewbuttonclick:(UIButton *)sender;
- (void)hiddenPickerView;


@end


@interface CuiPickerView : UIView
@property (nonatomic, copy) NSString *province;
@property(nonatomic,strong)NSDate*curDate;
@property (nonatomic,strong)UITextField *myTextField;
@property(nonatomic,strong)id<CuiPickViewDelegate>delegate;
- (void)showInView:(UIView *)view;
- (void)hiddenPickerView;
@end

