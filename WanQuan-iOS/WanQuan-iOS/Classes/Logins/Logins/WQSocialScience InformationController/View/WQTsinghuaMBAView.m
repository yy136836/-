//
//  WQTsinghuaMBAView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTsinghuaMBAView.h"
#import "WQLoginClassListView.h"

@interface WQTsinghuaMBAView ()

/**
 记录开始时间和结束时间的index
 */
@property (nonatomic, strong) NSIndexPath *index;

/**
 班级号后的三角
 */
@property (nonatomic, strong) UIButton *serialNumbersanjiaoBtn;

/**
 最底部的分割线
 */
@property (nonatomic, strong) UIView *bottomLineView;

/**
 班级两个字的标签
 */
@property (nonatomic, strong) UILabel *banjiLabel;

@end

@implementation WQTsinghuaMBAView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setupView {
    // 开始时间
    UIButton *startTimeBtn = [[UIButton alloc] init];
    self.startTimeBtn = startTimeBtn;
    startTimeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [startTimeBtn addTarget:self action:@selector(startTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [startTimeBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [startTimeBtn setTitleColor:[UIColor colorWithHex:0xb2b2b2] forState:UIControlStateNormal];
    [self addSubview:startTimeBtn];
    [startTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(kScaleX(-12));
        make.top.equalTo(self.mas_top);
    }];
    
    // 开始时间后的三角
    UIButton *startTimesanjiaoBtn = [[UIButton alloc] init];
    [startTimesanjiaoBtn setImage:[UIImage imageNamed:@"zhucexialacaidan1"] forState:UIControlStateNormal];
    [self addSubview:startTimesanjiaoBtn];
    [startTimesanjiaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(startTimeBtn);
        make.left.equalTo(startTimeBtn.mas_right).offset(kScaleY(3));
    }];
    
    // 在读时间
    UILabel *readingTimeLabel = [UILabel labelWithText:@"在读时间" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    [self addSubview:readingTimeLabel];
    [readingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(startTimeBtn.mas_centerY);
        make.right.equalTo(startTimeBtn.mas_left).offset(kScaleY(-18));
    }];
    
    UILabel *textLabel = [UILabel labelWithText:@"至" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(startTimeBtn.mas_centerY);
        make.left.equalTo(startTimesanjiaoBtn.mas_right).offset(kScaleY(12));
    }];
    
    // 到期时间
    UIButton *daoqiTimeBtn = [[UIButton alloc] init];
    self.daoqiTimeBtn = daoqiTimeBtn;
    daoqiTimeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [daoqiTimeBtn addTarget:self action:@selector(daoqiTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [daoqiTimeBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [daoqiTimeBtn setTitleColor:[UIColor colorWithHex:0xb2b2b2] forState:UIControlStateNormal];
    [self addSubview:daoqiTimeBtn];
    [daoqiTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(startTimeBtn.mas_centerY);
        make.left.equalTo(textLabel.mas_right).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    // 到期时间后的三角
    UIButton *daoqiTimesanjiaoBtn = [[UIButton alloc] init];
    [daoqiTimesanjiaoBtn setImage:[UIImage imageNamed:@"zhucexialacaidan1"] forState:UIControlStateNormal];
    [self addSubview:daoqiTimesanjiaoBtn];
    [daoqiTimesanjiaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(startTimeBtn);
        make.left.equalTo(daoqiTimeBtn.mas_right).offset(kScaleY(3));
    }];
    
    // 分隔线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.equalTo(readingTimeLabel.mas_left);
        make.right.equalTo(daoqiTimesanjiaoBtn.mas_right).offset(kScaleY(5));
        make.top.equalTo(readingTimeLabel.mas_bottom).offset(kScaleX(18));
    }];
    
    // 班级
    UILabel *banjiLabel = [UILabel labelWithText:@"班级" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    self.banjiLabel = banjiLabel;
    banjiLabel.hidden = YES;
    [self addSubview:banjiLabel];
    [banjiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(readingTimeLabel.mas_left);
        make.top.equalTo(lineView.mas_bottom).offset(kScaleX(22));
    }];
    
    // 班级号
    UIButton *serialNumberBtn = [[UIButton alloc] init];
    self.serialNumberBtn = serialNumberBtn;
    serialNumberBtn.hidden = YES;
    serialNumberBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [serialNumberBtn addTarget:self action:@selector(serialNumberBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [serialNumberBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [serialNumberBtn setTitleColor:[UIColor colorWithHex:0xb2b2b2] forState:UIControlStateNormal];
    [self addSubview:serialNumberBtn];
    [serialNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(banjiLabel.mas_centerY);
        make.left.equalTo(banjiLabel.mas_right).offset(kScaleY(ghDistanceershi));
    }];
    
    // 班级号后的三角
    UIButton *serialNumbersanjiaoBtn = [[UIButton alloc] init];
    self.serialNumbersanjiaoBtn = serialNumbersanjiaoBtn;
    serialNumbersanjiaoBtn.hidden = YES;
    [serialNumbersanjiaoBtn setImage:[UIImage imageNamed:@"zhucexialacaidan1"] forState:UIControlStateNormal];
    [self addSubview:serialNumbersanjiaoBtn];
    [serialNumbersanjiaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(serialNumberBtn);
        make.left.equalTo(serialNumberBtn.mas_right).offset(kScaleY(3));
    }];
    
    UIView *bottomLineView = [[UIView alloc] init];
    self.bottomLineView = bottomLineView;
    bottomLineView.hidden = YES;
    bottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.top.equalTo(banjiLabel.mas_bottom).offset(kScaleX(18));
        make.right.left.equalTo(lineView);
    }];
    
}

// 开始时间的响应事件
- (void)startTimeBtnClick {
    self.index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self theTimeSelector:NO];
}

// 到期时间的响应事件
- (void)daoqiTimeBtnClick {
    self.index = [NSIndexPath indexPathForRow:1 inSection:1];
    [self theTimeSelector:YES];
}

// 时间选择器
- (void)theTimeSelector:(BOOL)isWhetherToday {
    __weak typeof(self) weakSelf = self;
    QFDatePickerView *datePickerView = [[QFDatePickerView alloc] initDatePackerWithResponse:^(NSString *str) {
        if (weakSelf.index.row == 0) {
            [weakSelf.startTimeBtn setTitle:str forState:UIControlStateNormal];
            [weakSelf.startTimeBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
        }else if(weakSelf.index.row == 1) {
            [weakSelf.daoqiTimeBtn setTitle:str forState:UIControlStateNormal];
            [weakSelf.daoqiTimeBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
        }
        
        if (![weakSelf.startTimeBtn.titleLabel.text isEqualToString:@"请选择"] && ![weakSelf.daoqiTimeBtn.titleLabel.text isEqualToString:@"请选择"]) {
            
            if ([self.delegate respondsToSelector:@selector(wqMBADetermineTime:)]) {
                [self.delegate wqMBADetermineTime:self];
            }
            
            self.banjiLabel.hidden = NO;
            self.serialNumbersanjiaoBtn.hidden = NO;
            self.bottomLineView.hidden = NO;
            self.serialNumberBtn.hidden = NO;
        }else {
            self.banjiLabel.hidden = YES;
            self.serialNumbersanjiaoBtn.hidden = YES;
            self.bottomLineView.hidden = YES;
            self.serialNumberBtn.hidden = YES;
        }
        
    }  isToday:isWhetherToday];
    
    [datePickerView show];
    
    [datePickerView setHindBlock:^{
        
        if ([weakSelf.startTimeBtn.titleLabel.text isEqualToString:@"请选择"] && [weakSelf.daoqiTimeBtn.titleLabel.text isEqualToString:@"请选择"]) {
            self.banjiLabel.hidden = YES;
            self.serialNumbersanjiaoBtn.hidden = YES;
            self.bottomLineView.hidden = YES;
            self.serialNumberBtn.hidden = YES;
            
            UIAlertController *alertVC = [UIAlertController
                                          alertControllerWithTitle:@"提示!" message:@"请选择开始时间和截止时间" preferredStyle:UIAlertControllerStyleAlert];
            [weakSelf.viewController presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            
            return ;
        }
        
        if (self.index.row == 0 && [weakSelf.startTimeBtn.titleLabel.text isEqualToString:@"请选择"]) {
            UIAlertController *alertVC = [UIAlertController
                                          alertControllerWithTitle:@"提示!" message:@"请选择开始时间" preferredStyle:UIAlertControllerStyleAlert];
            [weakSelf.viewController presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
                
            }];
        }
        if (self.index.row == 1 && [weakSelf.daoqiTimeBtn.titleLabel.text isEqualToString:@"请选择"]) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请选择结束时间" preferredStyle:UIAlertControllerStyleAlert];

            [weakSelf.viewController presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }];
}

// 请选择班级的响应事件
- (void)serialNumberBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqSerialNumberBtnClick:)]) {
        [self.delegate wqSerialNumberBtnClick:self];
    }
}

@end
