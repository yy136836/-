//
//  WQRemunerationCollectionViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/2/28.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQRemunerationCollectionViewCell.h"

@implementation WQRemunerationCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupContentView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -- 初始化UI
- (void)setupContentView {
    UIButton *titleBtn = [[UIButton alloc] init];
    self.titleBtn = titleBtn;
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    titleBtn.backgroundColor = [UIColor whiteColor];
    titleBtn.layer.borderWidth = 1.0f;
    titleBtn.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    titleBtn.layer.cornerRadius = 5;
    titleBtn.layer.masksToBounds = YES;
    [titleBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(titleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:titleBtn];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)titleBtnClick {
    if (self.titleBtnClickBlock) {
        self.titleBtnClickBlock();
    }
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    [self.titleBtn setTitle:[titleString stringByAppendingString:@"元"] forState:UIControlStateNormal];
}

@end
