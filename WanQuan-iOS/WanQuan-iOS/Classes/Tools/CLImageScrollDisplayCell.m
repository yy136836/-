//
//  bohe
//
//  Created by 郭杭 on 15/12/16.
//  Copyright © 2015年 WQ. All rights reserved.
//

#import "CLImageScrollDisplayCell.h"

@implementation CLImageScrollDisplayCell {
    UIImageView *_imageView;
    UIButton *_closeBtn;
}
    
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
    
- (void)setupUI {
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.hidden = YES;
    [_closeBtn setImage:obtainImage(@"imageClose") forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeDisplayView:) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn sizeToFit];
    [self.contentView addSubview:_closeBtn];
    CGFloat width = _closeBtn.bounds.size.width;
    CGFloat height = _closeBtn.bounds.size.height;
    
    _closeBtn.frame = CGRectMake(self.bounds.size.width - width - 10, 30, width * 0.8, height * 0.8);
}
    
- (void)closeDisplayView:(UIButton *)sender {
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.closeBtnClick) {
        self.closeBtnClick();
    }
}
    
- (void)setDisplayImage:(UIImage *)displayImage {
    _displayImage = displayImage;
    _imageView.image = displayImage;
    if (!CGRectIsEmpty(self.convertFrame) && !CGRectIsNull(self.convertFrame)) {
        _imageView.frame = self.convertFrame;
        [UIView animateWithDuration:0.4 animations:^{
            [self showImageView];
        }];
    }else {
        [self showImageView];
    }
    
}

- (void)setImageUrl:(NSString *)imageUrl {
//    imageUrl = imageUrl;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
        _imageView.frame = self.convertFrame;
        _imageView.image = image;
        if (!CGRectIsEmpty(self.convertFrame) && !CGRectIsNull(self.convertFrame)) {
            [UIView animateWithDuration:0.4 animations:^{
                [self showImageView];
            }];
        } else {
            [self showImageView];
        }
    }];
}

- (void)showImageView {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = _imageView.frame;
        rect.size.width = kScreenWidth;
        rect.size.height = kScreenHeight;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.frame = rect;
        _imageView.center = self.contentView.center;
    });

}
    
@end
