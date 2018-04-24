//
//  WQLoginAreaCodeTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/8.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQLoginAreaCodeTableViewCell.h"
#import "WQAreaCodeListModel.h"

@interface WQLoginAreaCodeTableViewCell ()

// 地区
@property (nonatomic, strong) UILabel *regionLabel;

// 区号
@property (nonatomic, strong) UILabel *areaCodeLabel;

@end

@implementation WQLoginAreaCodeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark -- 初始化contentView
- (void)setupContentView {
    // 地区
    UILabel *regionLabel = [UILabel labelWithText:@"中国" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    self.regionLabel = regionLabel;
    [self addSubview:regionLabel];
    [regionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(kScaleY(ghDistanceershi));
    }];
    
    // 区号
    UILabel *areaCodeLabel = [UILabel labelWithText:@"86" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    self.areaCodeLabel = areaCodeLabel;
    [self addSubview:areaCodeLabel];
    [areaCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-kScaleY(ghDistanceershi));
    }];
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.bottom.right.equalTo(self);
        make.left.equalTo(regionLabel.mas_left);
    }];
}

- (void)setModel:(WQAreaCodeListModel *)model {
    _model = model;
    
    self.regionLabel.text = model.country;
    self.areaCodeLabel.text = model.code;
}

@end
