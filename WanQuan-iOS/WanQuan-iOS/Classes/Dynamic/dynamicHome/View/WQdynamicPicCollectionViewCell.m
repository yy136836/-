//
//  WQdynamicPicCollectionViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQdynamicPicCollectionViewCell.h"

@implementation WQdynamicPicCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -- 初始化View
- (void)setupView {
    UIImageView *picImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    self.picImageview = picImageview;
    picImageview.userInteractionEnabled = YES;
    picImageview.contentMode = UIViewContentModeScaleAspectFill;
    picImageview.layer.masksToBounds = YES;
    picImageview.layer.cornerRadius = 0;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap)];
    [picImageview addGestureRecognizer:imageTap];
    [self addSubview:picImageview];
    [picImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setImageId:(NSString *)imageId {
    _imageId = imageId;
    [self.picImageview yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_MIDDLE_URLSTRING(imageId)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
}

#pragma mark -- 图片响应事件
- (void)imageTap {
    if (self.imageClickBlock) {
        self.imageClickBlock();
    }
}

@end
