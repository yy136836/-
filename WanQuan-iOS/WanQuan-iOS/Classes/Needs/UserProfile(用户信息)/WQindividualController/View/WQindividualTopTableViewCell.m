//
//  WQindividualTopTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQindividualTopTableViewCell.h"

@interface WQindividualTopTableViewCell()

@end

@implementation WQindividualTopTableViewCell

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
    [self addSubview:self.Labeltitle];
    [self addSubview:self.nameLabel];
    
    [_Labeltitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset(5);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-8);
    }];
}

#pragma make - 懒加载
- (UILabel *)Labeltitle
{
    if (!_Labeltitle) {
        _Labeltitle = [[UILabel alloc]init];
        _Labeltitle.font = [UIFont systemFontOfSize:14];
    }
    return _Labeltitle;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"用户名";
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor colorWithHex:0X989898];
    }
    return _nameLabel;
}

@end
