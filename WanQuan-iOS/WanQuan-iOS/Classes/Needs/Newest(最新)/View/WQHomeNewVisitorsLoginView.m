//
//  WQHomeNewVisitorsLoginView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQHomeNewVisitorsLoginView.h"
#import "WQLogInController.h"
#import "WQlogonnNavViewController.h"

@implementation WQHomeNewVisitorsLoginView {
    UIButton *loginBtn;
    UILabel *tagonc;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupVisitorsLoginView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -- 初始化游客登录
- (void)setupVisitorsLoginView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fujin"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerX.equalTo(kScreenWidth);
        //make.top.equalTo(self.mas_top).offset(100);
        make.top.equalTo(self.mas_top).offset(94.5);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    tagonc= [UILabel labelWithText:@"看看附近有谁在发需求" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    [self addSubview:tagonc];
    tagonc.numberOfLines = 0;
    [tagonc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(25);
    }];
    
    loginBtn = [[UIButton alloc] init];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.borderWidth = 1.0f;
    loginBtn.layer.borderColor = [UIColor colorWithHex:0x901f87].CGColor;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginBtn setTitleColor:[UIColor colorWithHex:0x901f87] forState:UIControlStateNormal];
    

    [loginBtn setTitle: self.btnTitle?self.btnTitle:@"立即登录" forState:UIControlStateNormal];
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(tagonc.mas_bottom).offset(20);
        make.height.offset(36);
        make.width.offset(100);
    }];
    
    __weak typeof(self) weakself = self;
    
    [loginBtn addClickAction:^(UIButton * _Nullable sender) {
        if (weakself.loginBtnClickBlock) {
            weakself.loginBtnClickBlock();
        }
    }];
}



- (void)setBtnTitle:(NSString *)btnTitle {
    _btnTitle = btnTitle;
    [loginBtn setTitle: self.btnTitle?self.btnTitle:@"立即登录" forState:UIControlStateNormal];
}

- (void)setNoLocateText:(NSAttributedString *)noLocateText {
    _noLocateText = noLocateText;
    
    [tagonc setAttributedText:noLocateText];
}
@end
