//
//  WQLinksContentView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/4.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQLinksContentView.h"

@implementation WQLinksContentView {
    UIButton *deleteBtn;
}

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
    UIImageView *linksImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lianjie占位图"]];
    self.linksImage = linksImage;
    linksImage.contentMode = UIViewContentModeScaleAspectFill;
    linksImage.layer.cornerRadius = 0;
    linksImage.layer.masksToBounds = YES;
    [self addSubview:linksImage];
    [linksImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self);
        make.width.offset(60);
    }];
    
    UILabel *linksLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    self.linksLabel = linksLabel;
    linksLabel.numberOfLines = 2;
    [self addSubview:linksLabel];
    [linksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(linksImage.mas_right).offset(10);
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self.mas_right).offset(-ghSpacingOfshiwu);
        make.bottom.equalTo(self).offset(-9);
    }];
    
    deleteBtn = [[UIButton alloc] init];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setImage:[UIImage imageNamed:@"fabuwanquanshanchudi"] forState:UIControlStateNormal];
    [self addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScaleY(12), kScaleX(12)));
    }];
//    [deleteBtn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.top.equalTo(self);
//    }];
}

- (void)setIsWanquanHome:(BOOL)isWanquanHome {
    _isWanquanHome = isWanquanHome;
    if (isWanquanHome) {
        deleteBtn.hidden = YES;
    }
}

// x号按钮的响应事件
- (void)deleteBtnClick {
    if ([self.delegate respondsToSelector:@selector(deleteBtnClick:)]) {
        [self.delegate deleteBtnClick:self];
    }
}

@end
