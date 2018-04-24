//
//  WQThemeImageCollectionViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/30.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQThemeImageCollectionViewCell.h"

@implementation WQThemeImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
    }
    return self;
}

#pragma mark -- 初始化图片
- (void)setupImageView {
    YYAnimatedImageView *picImageView = [[YYAnimatedImageView alloc] init];
    self.picImageView = picImageView;
    picImageView.layer.masksToBounds = YES;
    picImageView.layer.cornerRadius = 0;
    picImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:picImageView];
    [self.contentView addSubview:picImageView];
    [picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        // make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    picImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
    [picImageView addGestureRecognizer:tap];
    
    // 图片总数量的背景view
    UIView *backgroundViewCount = [[UIView alloc] init];
    self.backgroundViewCount = backgroundViewCount;
    backgroundViewCount.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.4];
    [picImageView addSubview:backgroundViewCount];
    [backgroundViewCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(picImageView);
        make.size.mas_equalTo(CGSizeMake(38, 20));
    }];
    
    // 图片总数量
    UILabel *countLabel = [UILabel labelWithText:@"" andTextColor:[UIColor whiteColor] andFontSize:10];
    self.countLabel = countLabel;
    [backgroundViewCount addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backgroundViewCount.mas_centerY);
        make.centerX.equalTo(backgroundViewCount.mas_centerX);
    }];
}

- (void)handleTapGes:(UITapGestureRecognizer *)tap{
    
    if (self.imageClilcBlock) {
        self.imageClilcBlock((UIImageView *)tap.view);
    }
}

@end
