//
//  WQPlacedTopTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/11.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQPlacedTopTableViewCell.h"

@implementation WQPlacedTopTableViewCell {
    // 置顶的标题
    UILabel *subjectLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -- 初始化contentView
- (void)setupContentView {
    UIButton *tagBtn = [UIButton setNormalTitle:@"置顶\n主题" andNormalColor:[UIColor whiteColor] andFont:11];
    self.tagBtn = tagBtn;
    tagBtn.titleLabel.numberOfLines = 0;
    tagBtn.backgroundColor = [UIColor colorWithHex:0x5288d8];
    tagBtn.layer.cornerRadius = 5;
    tagBtn.layer.masksToBounds = YES;
    tagBtn.layer.borderWidth = 1.0f;
    tagBtn.layer.borderColor = [UIColor colorWithHex:0x5288d8].CGColor;
    [self.contentView addSubview:tagBtn];
    [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(kScaleY(ghSpacingOfshiwu));
        make.size.mas_equalTo(CGSizeMake(kScaleY(40), kScaleX(40)));
    }];
    
    subjectLabel = [UILabel labelWithText:@"3232" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:15];
    subjectLabel.numberOfLines = 1;
    subjectLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
    [self.contentView addSubview:subjectLabel];
    [subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tagBtn.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(kScaleY(-ghStatusCellMargin));
        make.left.equalTo(tagBtn.mas_right).offset(kScaleY(9));
    }];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}

- (void)setSubjectString:(NSString *)subjectString {
    _subjectString = subjectString;
    
    subjectLabel.text = subjectString;
}

@end
