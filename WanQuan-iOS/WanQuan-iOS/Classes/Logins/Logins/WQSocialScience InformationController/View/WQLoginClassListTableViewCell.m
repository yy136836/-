//
//  WQLoginClassListTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQLoginClassListTableViewCell.h"
#import "WQClassModel.h"

@implementation WQLoginClassListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark -- 初始化setupContentView
- (void)setupContentView {
    // 顶部的分割线
    UIView *topLineView = UIView.alloc.init;
    topLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.offset(0.5);
    }];
    
    UILabel *tagLabel = [UILabel labelWithText:@"MBA   f1" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    self.tagLabel = tagLabel;
    [self.contentView addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kScaleY(ghSpacingOfshiwu));
    }];
}

- (void)setModel:(WQClassModel *)model {
    _model = model;
    
    self.tagLabel.text = model.class_name;
}

@end
