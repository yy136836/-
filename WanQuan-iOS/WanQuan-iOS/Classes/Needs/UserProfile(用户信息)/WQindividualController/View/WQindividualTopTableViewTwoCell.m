//
//  WQindividualTopTableViewTwoCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQindividualTopTableViewTwoCell.h"

@implementation WQindividualTopTableViewTwoCell
 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma make - 初始化UI
- (void)setupUI
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.documentsLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset(16);
    }];
    [_documentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-8);
    }];
}

#pragma make - 懒加载
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"证件号码";
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)documentsLabel
{
    if (!_documentsLabel) {
        _documentsLabel = [[UILabel alloc]init];
        _documentsLabel.font = [UIFont systemFontOfSize:14];
        _documentsLabel.text = @"111111";
        _documentsLabel.textColor = [UIColor colorWithHex:0X989898];
    }
    return _documentsLabel;
}

@end
