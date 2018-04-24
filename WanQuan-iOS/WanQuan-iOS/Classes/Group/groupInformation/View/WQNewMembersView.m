//
//  WQNewMembersView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQNewMembersView.h"
#import "WQNewMembersViewController.h"

@implementation WQNewMembersView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    // 在self上添加一个btn
    UIButton *newMembersBtn = [[UIButton alloc] init];
    [newMembersBtn addTarget:self action:@selector(newMembersBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:newMembersBtn];
    [newMembersBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 新成员
    UILabel *newMembersLabel = [UILabel labelWithText:@"新成员" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    newMembersLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    [self addSubview:newMembersLabel];
    [newMembersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(ghSpacingOfshiwu);
        make.top.equalTo(self.mas_top).offset(ghSpacingOfshiwu);
    }];
    
    // 红点后的三角
    UIImageView *redTriangleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow"]];
    [self addSubview:redTriangleImage];
    [redTriangleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 12));
        make.right.equalTo(self.mas_right).offset(-ghStatusCellMargin);
        make.centerY.equalTo(newMembersLabel.mas_centerY);
    }];
    
    // 红点
    UILabel *redLabel = [UILabel labelWithText:@"12" andTextColor:[UIColor whiteColor] andFontSize:12];
    self.redLabel = redLabel;
    redLabel.backgroundColor = [UIColor redColor];
    redLabel.layer.masksToBounds = YES;
    redLabel.layer.cornerRadius = 7.5;
    [self addSubview:redLabel];
    [redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(redTriangleImage.mas_centerY);
        make.right.equalTo(redTriangleImage.mas_left).offset(-ghStatusCellMargin);
    }];
    
    // 底部分隔线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.equalTo(self.mas_left).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(newMembersLabel.mas_bottom).offset(ghSpacingOfshiwu);
    }];
}

// 点击新成员这一行的响应事件
- (void)newMembersBtnClike {
    WQNewMembersViewController *vc = [[WQNewMembersViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    [vc setOperationIsSuccessfulBlock:^{
       // 删除或者同意,回掉事件,刷新数据
        if (weakSelf.isLoadDataBlock) {
            weakSelf.isLoadDataBlock();
        }
    }];
    vc.groupId = self.groupId;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
