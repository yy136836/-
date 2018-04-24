//
//  WQPickerView.m
//  WanQuan-iOS
//
//  Created by Shmily on 2018/4/10.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQPickerView.h"

#define PickerHieght 180


@interface WQPickerView (){
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *canceBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePickerView;

@end

@implementation WQPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWithHex16_Alpha(0x000000, 0.3);
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.canceBtn];
        [self.bgView addSubview:self.sureBtn];
        [self.bgView addSubview:self.datePickerView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismis)];
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,kScreenHeight, kScreenWidth, 200)];
        _bgView.backgroundColor = [UIColor grayColor];

    }
    return _bgView;
}

- (UIDatePicker *)datePickerView
{
    if (!_datePickerView) {
        _datePickerView = [[UIDatePicker alloc]init];
        _datePickerView.frame = CGRectMake(0,40,kScreenWidth,PickerHieght);
        // 设置日期选择控件的地区
        
        [_datePickerView setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        [_datePickerView setCalendar:[NSCalendar currentCalendar]];
        _datePickerView.backgroundColor = [UIColor whiteColor];
      
        [_datePickerView setDate:[NSDate date]];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *currentDate = [NSDate date];
        [_datePickerView setDatePickerMode:UIDatePickerModeDate];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:0];//设置最小时间为：当前时间
        NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [_datePickerView setMinimumDate:minDate];
       // [_datePickerView addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
    }
    return _datePickerView;
}

- (void)dateChange:(UIDatePicker *)date

{
    
    
    
    
}


- (UIButton *)canceBtn
{
    if (!_canceBtn) {
        _canceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _canceBtn.frame = CGRectMake(12, 0, 40, 40);
        [_canceBtn setTitle:@"取消" forState:UIControlStateNormal];
        _canceBtn.backgroundColor = [UIColor clearColor];
        [_canceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_canceBtn addTarget:self action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
    }
    return _canceBtn;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(kScreenWidth - 50, 0, 40, 40);
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.backgroundColor = [UIColor clearColor];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sureBtn;
}

-(void)btnClicked:(UIButton *)btn
{
    
    _selectDate = [WQTool dateToString:_datePickerView.date];
    if ((_delegate && [_delegate respondsToSelector:@selector(didSelectDate:)])) {
        [_delegate didSelectDate:_selectDate];
        [self dismis];
    }
    
}


- (BOOL)anySubViewScrolling:(UIView *)view{
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    for (UIView *theSubView in view.subviews) {
        if ([self anySubViewScrolling:theSubView]) {
            return YES;
        }
    }
    return NO;
}

- (void)show {
    self.frame=[UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame= CGRectMake(0,kScreenHeight-200, kScreenWidth, PickerHieght);
    }];
}
- (void)dismis {
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame= CGRectMake(0,kScreenHeight, kScreenWidth, PickerHieght);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


@end
