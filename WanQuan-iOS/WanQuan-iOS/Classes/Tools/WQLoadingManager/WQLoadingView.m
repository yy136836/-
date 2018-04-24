//
//  WQLoadingView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/24.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQLoadingView.h"
#import "YYImage.h"

@implementation WQLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupView {
    UIImage *image = [YYImage imageNamed:@"加载动画@2x.gif"];
    UIImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    self.imageView = imageView;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}

- (void)dismiss {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.7 animations:^{
            weakSelf.alpha = 0;
        } completion:^(BOOL finished) {
            weakSelf.hidden = YES;
        }];
    });
}

- (void)show {
    self.hidden = NO;
}

@end
