//
//  WQSearchView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQSearchView.h"

@interface WQSearchView () <UITextFieldDelegate>

@end

@implementation WQSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0xfafafa];
        [self setupView];
    }
    return self;
}

#pragma mark -- 初始化View
- (void)setupView {
    // 搜索框
    UITextField *searchTextField = [[UITextField alloc] init];
    searchTextField.delegate = self;
    self.searchTextField = searchTextField;
    searchTextField.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    searchTextField.placeholder = @"  搜索动态内容";
    searchTextField.layer.cornerRadius = 5;
    searchTextField.layer.masksToBounds = YES;
    [searchTextField setReturnKeyType:UIReturnKeySearch];
    [self addSubview:searchTextField];
    [searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self).offset(ghSpacingOfshiwu);
        make.height.offset(35);
        make.width.offset(kScaleY(300));
    }];
    UIImageView *searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dynamicsousuo"]];
    searchTextField.leftView = searchImageView;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    UIButton *xBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 17)];
    self.xBtn = xBtn;
    [xBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [xBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [xBtn setTitle:@"    " forState:UIControlStateNormal];
    self.searchTextField.rightView = xBtn;
    self.searchTextField.rightViewMode = UITextFieldViewModeAlways;
    
    // 取消的按钮
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHex:0x000000] forState:UIControlStateNormal];
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchTextField.mas_centerY);
        make.left.equalTo(searchTextField.mas_right).offset(kScaleY(ghStatusCellMargin));
    }];
}

#pragma mark -- 取消的响应事件
- (void)cancelBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqSearchViewCancelBtnClick:)]) {
        [self.delegate wqSearchViewCancelBtnClick:self];
    }
}

#pragma mark -- deleteClick
- (void)deleteClick {
    self.searchTextField.text = @"";
    if ([self.delegate respondsToSelector:@selector(wqDeleteClick:)]) {
        [self.delegate wqDeleteClick:self];
    }
}

@end
