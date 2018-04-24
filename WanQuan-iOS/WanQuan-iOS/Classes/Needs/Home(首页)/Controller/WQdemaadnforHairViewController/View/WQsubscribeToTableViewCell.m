//
//  WQsubscribeToTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/11.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQsubscribeToTableViewCell.h"

@implementation WQsubscribeToTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- 初始化UI
- (void)setupUI{
    UILabel *subscribeToLabel = [[UILabel alloc] init];
    subscribeToLabel.text = @"需求类别";
    subscribeToLabel.font = [UIFont systemFontOfSize:16];
    subscribeToLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.contentView addSubview:subscribeToLabel];
    
    [subscribeToLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(20);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xededed];
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(7);
        make.left.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(50);
    }];
    
    [self.contentView addSubview:self.isSelectedLabel];
    [self.isSelectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView);
    }];
}

#pragma mark -- 懒加载
- (UILabel *)isSelectedLabel
{
    if (!_isSelectedLabel) {
        _isSelectedLabel = [[UILabel alloc] init];
        _isSelectedLabel.textColor = [UIColor colorWithHex:0xC4C4C4];
        _isSelectedLabel.font = [UIFont systemFontOfSize:14];
    }
    return _isSelectedLabel;
}

@end
