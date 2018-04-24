//
//  WQAddAdministratorTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQAddAdministratorTableViewCell.h"

@implementation WQAddAdministratorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupContentView];
    }
    return self;
}

#pragma mark -- 初始化View
- (void)setupContentView {
    // 加号
    UIImageView *addIamgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tianjiaguanliyuan"]];
    [self.contentView addSubview:addIamgeView];
    [addIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    // tag
    UILabel *label = [UILabel labelWithText:@"添加圈管理员" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addIamgeView.mas_centerY);
        make.left.equalTo(addIamgeView.mas_right).offset(kScaleY(ghSpacingOfshiwu));
    }];
}

@end
