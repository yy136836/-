//
//  WQStatusPictureViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/16.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQStatusPictureViewCell.h"
#import "YYWebImage.h"
#import "YYPhotoBrowseView.h"

@interface WQStatusPictureViewCell()
@property (nonatomic, strong) UIImageView *picImageview;
@end

@implementation WQStatusPictureViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- 初始化UI
- (void)setupUI {
    self.userInteractionEnabled = YES;
    UIImageView *picImageview = [[UIImageView alloc]init];
    picImageview.contentMode = UIViewContentModeScaleAspectFill;
    picImageview.layer.masksToBounds = YES;
    picImageview.layer.cornerRadius = 0;
    self.picImageview = picImageview;
    
    [self addSubview:picImageview];
    
    [picImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    picImageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
    picImageview.backgroundColor = [UIColor whiteColor];
    [picImageview addGestureRecognizer:tap];
}

- (void)setPicString:(NSString *)picString {
    _picString = picString;
    [self.picImageview yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_LARGE_URLSTRING(picString)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
}

- (void)setImageViewArray:(NSArray *)imageViewArray {
    _imageViewArray = imageViewArray;
}

- (void)handleTapGes:(UITapGestureRecognizer *)tap{
    
    if (self.imageClilcBlock) {
        self.imageClilcBlock((UIImageView *)tap.view);
    }
}

#pragma mark - 图片预览

-(CGRect)rectAtIndex:(NSInteger)index {
    //    KcolNumber 每行的个数
    //    Kwidth     控件的宽
    NSInteger KcolNumber = 3;
    CGFloat margin = 10;
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - (margin * KcolNumber +1))/(KcolNumber);
    CGFloat height = width;
    NSUInteger rowIndex = 0;
    NSUInteger colIndex = 0;
    rowIndex = index /KcolNumber;
    colIndex = index %KcolNumber;
    X = colIndex * width + (colIndex)*margin + 5;
    Y = rowIndex * width + (rowIndex)*margin +64;
    return CGRectMake(X, Y, width, height);
}

@end
