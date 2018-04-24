//
//  WQPhoneBookFriendsBottomView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/11/6.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQPhoneBookFriendsBottomView.h"

@implementation WQPhoneBookFriendsBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

#pragma mark -- 初始化View
- (void)setupView {
    UIButton *invitationBtn = [[UIButton alloc] init];
    self.invitationBtn = invitationBtn;
    invitationBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [invitationBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
    [invitationBtn setTitle:@"一键邀请所有好友" forState:UIControlStateNormal];
    [invitationBtn addTarget:self action:@selector(invitationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:invitationBtn];
    [invitationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
    }];
}

#pragma mark -- 邀请所有好友的响应事件
- (void)invitationBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqInvitationBtnClick:)]) {
        [self.delegate wqInvitationBtnClick:self];
    }
}

@end
