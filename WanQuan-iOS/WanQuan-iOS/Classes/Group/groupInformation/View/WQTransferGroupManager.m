//
//  WQTransferGroupManager.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTransferGroupManager.h"

@implementation WQTransferGroupManager

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupView {
    // 在self上添加一个btn
    UIButton *newMembersBtn = [[UIButton alloc] init];
    [newMembersBtn addTarget:self action:@selector(newMembersBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:newMembersBtn];
    [newMembersBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 新成员
    UILabel *newMembersLabel = [UILabel labelWithText:@"圈主权限转让" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    newMembersLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    [self addSubview:newMembersLabel];
    [newMembersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(ghSpacingOfshiwu);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    // 左边三角
    UIImageView *redTriangleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow"]];
    [self addSubview:redTriangleImage];
    [redTriangleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 12));
        make.right.equalTo(self.mas_right).offset(-ghStatusCellMargin);
        make.centerY.equalTo(newMembersLabel.mas_centerY);
    }];
    
    // 底部的线
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.equalTo(self.mas_left).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

// 透明的按钮
- (void)newMembersBtnClike {
    if (self.transferGroupManagerBlock) {
        self.transferGroupManagerBlock();
    }
}

@end
