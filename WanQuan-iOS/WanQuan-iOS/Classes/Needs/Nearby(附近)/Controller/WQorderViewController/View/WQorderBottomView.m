//
//  WQorderBottomView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQorderBottomView.h"

@interface WQorderBottomView()

@end

@implementation WQorderBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
//    [self addSubview:self.askBtn];
    [self addSubview:self.helpBtn];
    
//    [_askBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(ghSpacingOfshiwu);
//        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(110, ghCellHeight));
//    }];
    
    [_helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.mas_right).offset(-ghSpacingOfshiwu);
        make.centerY.equalTo(self);
        make.height.offset(ghCellHeight);
    }];
}

#pragma mark - 监听事件
// 询问
- (void)askBtnClike {
    if ([self.delegate respondsToSelector:@selector(WQorderBottomView:askBtnClike:)]) {
        [self.delegate WQorderBottomView:self askBtnClike:self.askBtn];
    }
}
// 我能帮助
- (void)helpBtnClike {
    if ([self.delegate respondsToSelector:@selector(WQorderBottomView:helpBtnClike:)]) {
        [self.delegate WQorderBottomView:self helpBtnClike:self.helpBtn];
    }
}

#pragma mark - 懒加载
- (UIButton *)askBtn {
    if (!_askBtn) {
        _askBtn = [[UIButton alloc] init];
        _askBtn.backgroundColor = [UIColor whiteColor];
        _askBtn.layer.borderWidth = 1.0f;
        _askBtn.layer.cornerRadius = 5;
        _askBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _askBtn.layer.borderColor = [UIColor colorWithHex:0X9767d0].CGColor;
        [_askBtn setTitle:@"询问" forState:UIControlStateNormal];
        [_askBtn setTitleColor:[UIColor colorWithHex:0X9767d0] forState:UIControlStateNormal];
        [_askBtn addTarget:self action:@selector(askBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _askBtn;
}

- (UIButton *)helpBtn {
    if (!_helpBtn) {
        _helpBtn = [[UIButton alloc] init];
        _helpBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
        _helpBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_helpBtn setTitle:@"我能帮助" forState:UIControlStateNormal];
        [_helpBtn setTitle:@"需求已完成" forState:UIControlStateDisabled];
        [_helpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _helpBtn.layer.cornerRadius = 5;
        [_helpBtn addTarget:self action:@selector(helpBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpBtn;
}

@end
