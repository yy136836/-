//
//  WQTheArbitrationView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/3/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTheArbitrationView.h"
#import "BDImagePicker.h"

@implementation WQTheArbitrationView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    [self addSubview:self.textView];
    [self addSubview:self.imageView];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.offset(kScreenHeight / 3);
    }];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(_textView.mas_bottom).offset(20);
        make.height.width.offset(100);
    }];
}

- (void)handleTapGes:(UITapGestureRecognizer *)tap {
    [BDImagePicker showImagePickerFromViewController:self.viewController allowsEditing:YES finishAction:^(UIImage *image) {
        _imageView.image = image;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

#pragma mark - 懒加载
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textColor = [UIColor colorWithHex:0X7b7b7b];
        _textView.layer.borderWidth= 1.0f;
        _textView.layer.borderColor= [UIColor colorWithHex:0Xececec].CGColor;
        _textView.placeholder = @"请输入您要投诉的内容";
    }
    return _textView;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 0;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

@end
