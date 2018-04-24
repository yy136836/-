//
//  WQReleaseFriendsCirclePromptView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQReleaseFriendsCirclePromptView.h"

@implementation WQReleaseFriendsCirclePromptView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    // 背景view
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor =[UIColor colorWithHex:0xf8f8f8];
    [self addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(115);
        make.left.equalTo(self).offset(ghSpacingOfshiwu);
        make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        make.top.equalTo(self).offset(20);
    }];
    
    UILabel *label = [UILabel labelWithText:@"怎样获得文章链接?" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    [backgroundView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView.mas_top).offset(ghSpacingOfshiwu);
        make.left.equalTo(backgroundView).offset(ghSpacingOfshiwu);
    }];
    
    UILabel *twoLabel = [UILabel labelWithText:@"在其他app中读到有感触的文章时，在文章页面点击分享按钮，分享方式选择\"复制链接\",即可来万圈中点击上方粘贴链接区域，分享给大家啦。" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:15];
    
    twoLabel.numberOfLines = 3;
    [backgroundView addSubview:twoLabel];
    [twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_left);
        make.top.equalTo(label.mas_bottom).offset(ghStatusCellMargin);
        make.right.equalTo(backgroundView).offset(-ghSpacingOfshiwu);
    }];
    
    // x的按钮
    UIButton *deleteBtn = [[UIButton alloc] init];
    [deleteBtn setImage:[UIImage imageNamed:@"fabuwanquanshanchu"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView).offset(ghStatusCellMargin);
        make.right.equalTo(backgroundView).offset(-ghStatusCellMargin);
    }];
}

#pragma mark -- 删除的按钮
- (void)deleteBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqDeleteBtnClickCirclePromptView:)]) {
        [self.delegate wqDeleteBtnClickCirclePromptView:self];
    }
}

@end
