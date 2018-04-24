//
//  WQSchoolOfSocialSciencesView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQSchoolOfSocialSciencesView.h"
#import "WQClassModel.h"

@interface WQSchoolOfSocialSciencesView ()

/**
 记录开始时间和结束时间的index
 */
@property (nonatomic, strong) NSIndexPath *index;

@end

@implementation WQSchoolOfSocialSciencesView {
    NSArray *classDataArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setupView {
    // 选择学位
    UIButton *selectedADegreeInBtn = [[UIButton alloc] init];
    selectedADegreeInBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.selectedADegreeInBtn = selectedADegreeInBtn;
    [selectedADegreeInBtn addTarget:self action:@selector(selectedADegreeInBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [selectedADegreeInBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [selectedADegreeInBtn setTitleColor:[UIColor colorWithHex:0xb2b2b2] forState:UIControlStateNormal];
    [self addSubview:selectedADegreeInBtn];
    [selectedADegreeInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(kScaleY(-40));
        make.top.equalTo(self);
    }];
    
    // 学位
    UILabel *aDegreeInLabel = [UILabel labelWithText:@"学位" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    [self addSubview:aDegreeInLabel];
    [aDegreeInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectedADegreeInBtn.mas_centerY);
        make.right.equalTo(selectedADegreeInBtn.mas_left).offset(kScaleY(-19));
    }];
    
    // 学位下的分割线
    UIView *aDegreeInLineView = [[UIView alloc] init];
    aDegreeInLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:aDegreeInLineView];
    [aDegreeInLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.top.equalTo(aDegreeInLabel.mas_bottom).offset(kScaleX(18));
        make.left.equalTo(aDegreeInLabel.mas_left);
        make.right.equalTo(self.mas_right).offset(kScaleY(-55));
    }];
    
    // 选择学位后的三角
    UIButton *selectedADegreeInsanjiaoBtn = [[UIButton alloc] init];
    [selectedADegreeInsanjiaoBtn setImage:[UIImage imageNamed:@"zhucexialacaidan1"] forState:UIControlStateNormal];
    [self addSubview:selectedADegreeInsanjiaoBtn];
    [selectedADegreeInsanjiaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectedADegreeInBtn);
        make.left.equalTo(selectedADegreeInBtn.mas_right).offset(kScaleY(3));
    }];
    
    // 在读时间
    UILabel *readingTimeLabel = [UILabel labelWithText:@"在读时间" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    [self addSubview:readingTimeLabel];
    [readingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aDegreeInLabel.mas_left);
        make.top.equalTo(aDegreeInLineView.mas_bottom).offset(kScaleX(18));
    }];
    
    // 开始时间
    UIButton *startTimeBtn = [[UIButton alloc] init];
    startTimeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.startTimeBtn = startTimeBtn;
    [startTimeBtn addTarget:self action:@selector(startTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [startTimeBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [startTimeBtn setTitleColor:[UIColor colorWithHex:0xb2b2b2] forState:UIControlStateNormal];
    [self addSubview:startTimeBtn];
    [startTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(readingTimeLabel.mas_centerY);
        make.left.equalTo(readingTimeLabel.mas_right).offset(kScaleY(ghStatusCellMargin));
    }];
    
    // 开始时间后的三角
    UIButton *startTimesanjiaoBtn = [[UIButton alloc] init];
    [startTimesanjiaoBtn setImage:[UIImage imageNamed:@"zhucexialacaidan1"] forState:UIControlStateNormal];
    [self addSubview:startTimesanjiaoBtn];
    [startTimesanjiaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(startTimeBtn);
        make.left.equalTo(startTimeBtn.mas_right).offset(kScaleY(3));
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
        make.left.equalTo(textLabel.mas_right).offset(kScaleY(ghStatusCellMargin));
    }];
    
    // 到期时间后的三角
    UIButton *daoqiTimesanjiaoBtn = [[UIButton alloc] init];
    [daoqiTimesanjiaoBtn setImage:[UIImage imageNamed:@"zhucexialacaidan1"] forState:UIControlStateNormal];
    [self addSubview:daoqiTimesanjiaoBtn];
    [daoqiTimesanjiaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(startTimeBtn);
        make.left.equalTo(daoqiTimeBtn.mas_right).offset(kScaleY(3));
    }];

    // 在读时间下的分割线
    UIView *readingTimeLineView = [[UIView alloc] init];
    readingTimeLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:readingTimeLineView];
    [readingTimeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel.mas_bottom).offset(kScaleX(18));
        make.left.equalTo(aDegreeInLineView.mas_left);
        make.right.equalTo(self.mas_right).offset(kScaleY(-55));
        make.height.offset(0.5);
    }];
    
    // 班级
    UILabel *banjiLabel = [UILabel labelWithText:@"班级" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    self.banjiLabel = banjiLabel;
    banjiLabel.hidden = YES;
    [self addSubview:banjiLabel];
    [banjiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(readingTimeLabel.mas_left);
        make.top.equalTo(readingTimeLineView.mas_bottom).offset(kScaleX(18));
    }];
    
    // 班级号
    UIButton *serialNumberBtn = [[UIButton alloc] init];
    serialNumberBtn.hidden = YES;
    serialNumberBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.serialNumberBtn = serialNumberBtn;
    [serialNumberBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [serialNumberBtn addTarget:self action:@selector(serialNumberBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [serialNumberBtn setTitleColor:[UIColor colorWithHex:0xb2b2b2] forState:UIControlStateNormal];
    [self addSubview:serialNumberBtn];
    [serialNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(banjiLabel.mas_centerY);
        make.left.equalTo(banjiLabel.mas_right).offset(kScaleY(ghDistanceershi));
    }];
    
    // 班级号后的三角
    UIButton *serialNumbersanjiaoBtn = [[UIButton alloc] init];
    serialNumbersanjiaoBtn.hidden = YES;
    self.serialNumbersanjiaoBtn = serialNumbersanjiaoBtn;
    [serialNumbersanjiaoBtn setImage:[UIImage imageNamed:@"zhucexialacaidan1"] forState:UIControlStateNormal];
    [self addSubview:serialNumbersanjiaoBtn];
    [serialNumbersanjiaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(serialNumberBtn);
        make.left.equalTo(serialNumberBtn.mas_right).offset(kScaleY(3));
    }];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.hidden = YES;
    self.bottomLineView = bottomLineView;
    bottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.top.equalTo(banjiLabel.mas_bottom).offset(kScaleX(18));
        make.right.left.equalTo(readingTimeLineView);
    }];
}

// 请选择班级的响应事件
- (void)serialNumberBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqSchoolOfSocialSciencesSerialNumberBtnClick:)]) {
        [self.delegate wqSchoolOfSocialSciencesSerialNumberBtnClick:self];
    }
}

// 请选择学位的响应事件
- (void)selectedADegreeInBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqSchoolOfSocialSciencesSelectedADegreeInBtnClick:)]) {
        [self.delegate wqSchoolOfSocialSciencesSelectedADegreeInBtnClick:self];
    }
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
        
        if (![weakSelf.startTimeBtn.titleLabel.text isEqualToString:@"请选择"] && ![weakSelf.daoqiTimeBtn.titleLabel.text isEqualToString:@"请选择"] && ![weakSelf.selectedADegreeInBtn.titleLabel.text isEqualToString:@"请选择"]) {
            
            if ([weakSelf.delegate respondsToSelector:@selector(wqSchoolOfSocialDetermineTime:)]) {
                [weakSelf.delegate wqSchoolOfSocialDetermineTime:weakSelf];
            }
            
            weakSelf.banjiLabel.hidden = NO;
            weakSelf.serialNumbersanjiaoBtn.hidden = NO;
            weakSelf.bottomLineView.hidden = NO;
            weakSelf.serialNumberBtn.hidden = NO;
        }else {
            weakSelf.banjiLabel.hidden = YES;
            weakSelf.serialNumbersanjiaoBtn.hidden = YES;
            weakSelf.bottomLineView.hidden = YES;
            weakSelf.serialNumberBtn.hidden = YES;
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

@end
