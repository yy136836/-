//
//  WQImageCollectionViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/7.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQImageCollectionViewCell.h"

@interface WQImageCollectionViewCell ()
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation WQImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor colorWithWhite:0xffffff alpha:0];
    }
    return self;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

#pragma mark -- 初始化UI
- (void)setupUI {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.deleteBtn];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_deleteBtn.mas_centerY).offset(-5);
        make.left.equalTo(_deleteBtn.mas_centerX);
        make.width.height.offset(30);
    }];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
    }];
}
 
#pragma mark -- 响应事件
- (void)deleteBtnClike {
    if (self.deleteImageBlock) {
        self.deleteImageBlock();
    }
}

- (void)handleTapGes {
    
    if (self.imageClilcBlock) {
        self.imageClilcBlock();
    }
}

#pragma mark -- 懒加载
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 0;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes)];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:[UIImage imageNamed:@"compose_photo_close"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

@end
