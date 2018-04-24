//
//  WQTouristView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/2/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTouristView.h"
#import "WQLogInController.h"

@interface WQTouristView()
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *promptBtn;
@end

@implementation WQTouristView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -- 初始化
- (void)setupUI {
    [self addSubview:self.promptLabel];
    [self addSubview:self.promptBtn];
    
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
    }];
    [_promptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_promptLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

#pragma mark -- 监听事件
- (void)promptBtnCliek {
    WQLogInController *logInVc = [[WQLogInController alloc]initWithTouristLoginStatus:TouristLoginStatusHide];
    [self.viewController.navigationController pushViewController:logInVc animated:YES];
}


#pragma mark -- 懒加载
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc]init];
        _promptLabel.text = @"您暂未登录,请先登录";
        _promptLabel.font = [UIFont systemFontOfSize:14];
        }
    return _promptLabel;
}

- (UIButton *)promptBtn {
    if (!_promptBtn) {
        _promptBtn = [[UIButton alloc]init];
        [_promptBtn setTitle:@"去登录 >" forState:0];
        _promptBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_promptBtn setTitleColor:[UIColor colorWithHex:0xa550d6] forState:0];
        [_promptBtn addTarget:self action:@selector(promptBtnCliek) forControlEvents:UIControlEventTouchUpInside];
    }
    return _promptBtn;
}

@end
