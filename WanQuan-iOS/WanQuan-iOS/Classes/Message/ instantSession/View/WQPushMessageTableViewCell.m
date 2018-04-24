//
//  WQPushMessageTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/7.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQPushMessageTableViewCell.h"
#import "WQmessageHomeModel.h"

@interface WQPushMessageTableViewCell()

@end

@implementation WQPushMessageTableViewCell {
    // 标题
    UILabel *titleLabel;
    // 来源
    UILabel *toSourceLabel;
    // 具体消息
    UILabel *contentLabel;
    // 时间
    UILabel *timeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
    }
    return self;
}

#pragma mark -- 初始化setupContentView
- (void)setupContentView {
    titleLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(ghSpacingOfshiwu);
    }];
    
    toSourceLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:14];
    [self.contentView addSubview:toSourceLabel];
    [toSourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
    }];
    
    contentLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toSourceLabel.mas_left);
        make.top.equalTo(toSourceLabel.mas_bottom).offset(8);
        make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
        make.bottom.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
    }];
    
    timeLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:10];
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
    }];
}

- (void)setModel:(WQmessageHomeModel *)model {
    _model = model;
    
    titleLabel.text = model.title;
    toSourceLabel.text = model.content;
    contentLabel.text = model.subject;
    timeLabel.text = model.posttime;
}

@end
