//
//  WQCycleViewCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQCycleViewCell.h"
#import "UIView+SDExtension.h"

@implementation WQCycleViewCell

{
    __weak UILabel *_titleLabel;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupImageView];
        [self setupTitleLabel];
    }
    
    return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:imageView];
    [self addCover];

}

- (void)addCover {
    UIImageView * cover = [[UIImageView alloc] init];
    cover.userInteractionEnabled = YES;
    [_imageView addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_imageView);
        make.height.equalTo(@(64));
    }];
    cover.image = [UIImage imageNamed:@"essenceBannerCover"];
}

- (void)setupTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.numberOfLines = 2;
    _titleLabel.hidden = YES;
    [self.contentView addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"%@", title];
    if (_titleLabel.hidden) {
        _titleLabel.hidden = NO;
    }
}

-(void)setTitleLabelTextAlignment:(NSTextAlignment)titleLabelTextAlignment
{
    _titleLabelTextAlignment = titleLabelTextAlignment;
    _titleLabel.textAlignment = titleLabelTextAlignment;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.onlyDisplayText) {
        
        _titleLabel.frame = self.bounds;
    } else {
        
        _imageView.frame = self.bounds;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.imageView.mas_bottom).offset(-10);
            make.height.lessThanOrEqualTo(@50);
            make.left.equalTo(self.imageView).offset(15);
            make.width.lessThanOrEqualTo(@(kScreenWidth / 4 * 3));
            
        }];
    }
}


@end
