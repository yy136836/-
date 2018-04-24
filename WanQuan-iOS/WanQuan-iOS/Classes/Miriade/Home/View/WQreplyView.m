//
//  WQreplyView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/23.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQreplyView.h"

@interface WQreplyView()
@end

@implementation WQreplyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- 初始化
- (void)setupUI {
    //查看消息的Btn
    UIButton *viewReplyBtn = [[UIButton alloc] init];
    [viewReplyBtn setTitle:@"您有新的评论消息" forState:UIControlStateNormal];
    viewReplyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [viewReplyBtn setTitleColor:[UIColor colorWithHex:0xa550d6] forState:UIControlStateNormal];
    [viewReplyBtn addTarget:self action:@selector(viewReplyBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:viewReplyBtn];
    [viewReplyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

#pragma mark -- 点击事件
- (void)viewReplyBtnClike {
    if (self.viewReplyBtnClikeBlock) {
        self.viewReplyBtnClikeBlock();
    }
}

@end
