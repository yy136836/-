//
//  WQimageConCollectionViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/14.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQimageConCollectionViewCell.h"

@interface WQimageConCollectionViewCell()

@end

@implementation WQimageConCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
#pragma mark -- 初始化UI
- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 0;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
    [imageView addGestureRecognizer:tap];
    
    [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setImage:[UIImage imageNamed:@"compose_photo_close"] forState:UIControlStateNormal];
    
    [self.contentView addSubview:imageView];
    [self addSubview:deleteButton];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
    }];
    
    self.imageView = imageView;
    self.deleteButton = deleteButton;
    
}

- (void)handleTapGes:(UITapGestureRecognizer *)tap{
    if (self.imageClilcBlock) {
        self.imageClilcBlock();
    }
}

#pragma mark -- 删除Btn事件
- (void)deleteButtonClick:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    if (_image == nil) {
        self.imageView.image = [UIImage imageNamed:@"fabuwanquanxuantupian"];
        self.imageView.highlightedImage = [UIImage imageNamed:@"fabuwanquanxuantupian"];
    }else {
        self.imageView.image = image;
        self.imageView.highlightedImage = image;
    }
    self.deleteButton.hidden = image == nil;
}

@end
