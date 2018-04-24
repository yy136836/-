//
//  WQGroupForwardView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/6.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupForwardView.h"

@interface WQGroupForwardView ()
@property (nonatomic, strong) MASConstraint *bottomCon;
@end

@implementation WQGroupForwardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGroup];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化Group
- (void)setupGroup {
    // 附加信息
    /*YYLabel *additionalInformationLabel = [[YYLabel alloc] init];
    self.additionalInformationLabel = additionalInformationLabel;
    additionalInformationLabel.numberOfLines = 6;
    additionalInformationLabel.font = [UIFont systemFontOfSize:16];
    additionalInformationLabel.textColor = [UIColor colorWithHex:0x111111];
    [self addSubview:additionalInformationLabel];
    [additionalInformationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(ghStatusCellMargin);
        make.top.equalTo(self.mas_top).offset(ghStatusCellMargin);
        make.right.equalTo(self.mas_right).offset(-ghStatusCellMargin);
    }];*/
    
    // 背景view
    UIView *backgroundForwardView = [[UIView alloc] init];
    backgroundForwardView.backgroundColor = [UIColor colorWithHex:0xededed];
    [self addSubview:backgroundForwardView];
    [backgroundForwardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(ghStatusCellMargin);
        make.right.equalTo(self.mas_right).offset(-ghStatusCellMargin);
        make.top.equalTo(self.mas_top).offset(ghStatusCellMargin);
        make.height.offset(60);
    }];
    
    // 群组头像
    UIImageView *groupHeadPortrait = [[UIImageView alloc] init];
    self.groupHeadPortrait = groupHeadPortrait;
    groupHeadPortrait.contentMode = UIViewContentModeScaleAspectFill;
    groupHeadPortrait.layer.cornerRadius = 0;
    groupHeadPortrait.layer.masksToBounds = YES;
    [backgroundForwardView addSubview:groupHeadPortrait];
    [groupHeadPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(backgroundForwardView.mas_left).offset(ghStatusCellMargin);
        make.centerY.equalTo(backgroundForwardView.mas_centerY);
    }];
    
    // 群名称
    YYLabel *nameLabel = [[YYLabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textColor = [UIColor colorWithHex:0x666666];
    [backgroundForwardView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(groupHeadPortrait.mas_right).offset(ghStatusCellMargin);
        make.top.equalTo(groupHeadPortrait.mas_top).offset(4);
    }];
    
    // 群介绍
    YYLabel *groupIntroduceLabel = [[YYLabel alloc] init];
    groupIntroduceLabel.numberOfLines = 1;
    self.groupIntroduceLabel = groupIntroduceLabel;
    groupIntroduceLabel.font = [UIFont systemFontOfSize:13];
    groupIntroduceLabel.textColor = [UIColor colorWithHex:0x444444];
    [backgroundForwardView addSubview:groupIntroduceLabel];
    [groupIntroduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.right.equalTo(backgroundForwardView.mas_right);
        make.top.equalTo(nameLabel.mas_bottom).offset(6);
    }];
    
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        self.bottomCon = make.bottom.equalTo(backgroundForwardView.mas_bottom).mas_offset(ghStatusCellMargin);
//    }];
}

@end
