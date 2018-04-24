//
//  WQAreNotView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQAreNotView.h"

@interface WQAreNotView () <UITextFieldDelegate>

/**
 记录开始时间和结束时间的index
 */
@property (nonatomic, strong) NSIndexPath *index;

@end

@implementation WQAreNotView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setupView {
    // 学校的输入框
    UILabel *schoolLabel = [UILabel labelWithText:@"学校 " andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    UITextField *schoolTextField = [[UITextField alloc] init];
    schoolTextField.delegate = self;
    self.schoolTextField = schoolTextField;
    schoolTextField.leftView = schoolLabel;
    schoolTextField.leftViewMode = UITextFieldViewModeAlways;
    schoolTextField.placeholder = @"输入学校名称";
    schoolTextField.returnKeyType = UIReturnKeyDone;
    schoolTextField.userInteractionEnabled = YES;
    schoolTextField.font = [UIFont fontWithName:@".PingFangSC-Regular" size:16];
    [self addSubview:schoolTextField];
    [schoolTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(kScaleY(65));
        make.right.equalTo(self.mas_right).offset(kScaleY(-65));
        make.height.offset(kScaleX(55));
    }];
    
    // 学校的分割线
    UIView *schoolBottomLineView = [[UIView alloc] init];
    schoolBottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:schoolBottomLineView];
    [schoolBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.right.equalTo(schoolTextField);
        make.top.equalTo(schoolTextField.mas_bottom);
    }];
    
    // 专业
    UILabel *professionalLabel = [UILabel labelWithText:@"专业 " andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    UITextField *professionalTextField = [[UITextField alloc] init];
    self.professionalTextField = professionalTextField;
    professionalTextField.delegate = self;
    professionalTextField.leftView = professionalLabel;
    professionalTextField.leftViewMode = UITextFieldViewModeAlways;
    professionalTextField.returnKeyType = UIReturnKeyDone;
    professionalTextField.placeholder = @"输入专业名称";
    professionalTextField.userInteractionEnabled = YES;
    professionalTextField.font = [UIFont fontWithName:@".PingFangSC-Regular" size:16];
    [self addSubview:professionalTextField];
    [professionalTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(schoolBottomLineView.mas_bottom);
        make.left.equalTo(self.mas_left).offset(kScaleY(65));
        make.right.equalTo(self.mas_right).offset(kScaleY(-65));
        make.height.offset(kScaleX(55));
    }];
    
    // 专业下的分割线
    UIView *professionalBottomLineView = [[UIView alloc] init];
    professionalBottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:professionalBottomLineView];
    [professionalBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(schoolBottomLineView);
        make.height.offset(0.5);
        make.top.equalTo(professionalTextField.mas_bottom);
    }];
    
    // 学位
    UILabel *aDegreeinLabel = [UILabel labelWithText:@"学位 " andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    [self addSubview:aDegreeinLabel];
    [aDegreeinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(professionalBottomLineView);
//        make.top.equalTo(professionalBottomLineView.mas_bottom).offset(kScaleX(ghDistanceershi));
        make.top.equalTo(professionalBottomLineView.mas_bottom).offset(kScaleX(ghDistanceershi));
        make.left.equalTo(professionalBottomLineView.mas_left);
    }];
    
    // 选择学位
    UIButton *selectedADegreeInBtn = [[UIButton alloc] init];
    selectedADegreeInBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.selectedADegreeInBtn = selectedADegreeInBtn;
    [selectedADegreeInBtn addTarget:self action:@selector(selectedADegreeInBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [selectedADegreeInBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [selectedADegreeInBtn setTitleColor:[UIColor colorWithHex:0xb2b2b2] forState:UIControlStateNormal];
    [self addSubview:selectedADegreeInBtn];
    [selectedADegreeInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(aDegreeinLabel.mas_centerX).offset(kScaleY(-40));
//        make.left.equalTo(aDegreeinLabel.mas_right).offset(kScaleY(ghStatusCellMargin));
        make.centerY.equalTo(aDegreeinLabel.mas_centerY);
        make.left.equalTo(aDegreeinLabel.mas_right).offset(kScaleY(ghStatusCellMargin));
    }];
    
    // 选择学位后的三角
    UIButton *selectedADegreeInsanjiaoBtn = [[UIButton alloc] init];
    [selectedADegreeInsanjiaoBtn setImage:[UIImage imageNamed:@"zhucexialacaidan1"] forState:UIControlStateNormal];
    [self addSubview:selectedADegreeInsanjiaoBtn];
    [selectedADegreeInsanjiaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectedADegreeInBtn);
        make.left.equalTo(selectedADegreeInBtn.mas_right).offset(kScaleY(3));
    }];
    
//    UITextField *aDegreeinTextField = [[UITextField alloc] init];
//    self.aDegreeinTextField = aDegreeinTextField;
//    aDegreeinTextField.leftView = aDegreeinLabel;
//    aDegreeinTextField.leftViewMode = UITextFieldViewModeAlways;
//    aDegreeinTextField.placeholder = @"输入学位名称";
//    aDegreeinTextField.userInteractionEnabled = YES;
//    aDegreeinTextField.font = [UIFont fontWithName:@".PingFangSC-Regular" size:16];
//    [self addSubview:aDegreeinTextField];
//    [aDegreeinTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.mas_centerX);
//        make.top.equalTo(professionalBottomLineView.mas_bottom);
//        make.left.equalTo(self.mas_left).offset(kScaleY(65));
//        make.right.equalTo(self.mas_right).offset(kScaleY(-65));
//        make.height.offset(kScaleX(55));
//    }];
    
    // 学位下的分割线
    UIView *aDegreeinLineView = [[UIView alloc] init];
    aDegreeinLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:aDegreeinLineView];
    [aDegreeinLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.right.left.equalTo(schoolBottomLineView);
        make.top.equalTo(aDegreeinLabel.mas_bottom).offset(kScaleX(18));
    }];
    
    // 在读时间
    UILabel *readingTimeLabel = [UILabel labelWithText:@"在读时间" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    [self addSubview:readingTimeLabel];
    [readingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aDegreeinLineView.mas_bottom).offset(kScaleX(ghDistanceershi));
        make.left.equalTo(aDegreeinLineView.mas_left);
    }];
    
    // 开始时间
    UIButton *startTimeBtn = [[UIButton alloc] init];
    self.startTimeBtn = startTimeBtn;
    startTimeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
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
        make.left.equalTo(startTimesanjiaoBtn.mas_right).offset(kScaleY(ghSpacingOfshiwu));
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
    
    // 分隔线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.right.equalTo(professionalBottomLineView);
        make.top.equalTo(readingTimeLabel.mas_bottom).offset(kScaleX(18));
    }];
}

#pragma mark -- UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 取消第一响应者
    [textField resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

#pragma mark -- 学位的响应事件
- (void)selectedADegreeInBtnClick {
//    if ([self.delegate respondsToSelector:@selector(wqAreNotViewSelectedADegreeInBtnClick:)]) {
//        [self.delegate wqAreNotViewSelectedADegreeInBtnClick:self];
//    }
    [self endEditing:YES];
    if (self.areNotViewSelectedADegreeInBtnClickBlock) {
        self.areNotViewSelectedADegreeInBtnClickBlock();
    }
}

#pragma mark -- 到期时间的响应事件
- (void)daoqiTimeBtnClick {
    [self endEditing:YES];
    self.index = [NSIndexPath indexPathForRow:1 inSection:1];
    [self theTimeSelector:YES];
}

#pragma mark -- 开始时间的响应事件
- (void)startTimeBtnClick {
    [self endEditing:YES];
    self.index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self theTimeSelector:NO];
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
        
    }  isToday:isWhetherToday];
    
    [datePickerView show];
    
    [datePickerView setHindBlock:^{
        if ([weakSelf.startTimeBtn.titleLabel.text isEqualToString:@"请选择"] && [weakSelf.daoqiTimeBtn.titleLabel.text isEqualToString:@"请选择"]) {
            
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
