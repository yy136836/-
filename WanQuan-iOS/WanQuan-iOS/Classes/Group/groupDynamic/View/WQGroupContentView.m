//
//  WQGroupContentView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupContentView.h"

@interface WQGroupContentView ()
@property (strong, nonatomic) MASConstraint *bottomCon;
@end

@implementation WQGroupContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    // 标题
    UILabel *titleLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:15];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.mas_right).offset(-ghStatusCellMargin);
        make.top.equalTo(self.mas_top);
        make.height.offset(kScaleX(ghDistanceershi));
    }];
    // 内容
    UILabel *contentLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:14];
    self.contentLabel = contentLabel;
    contentLabel.numberOfLines = 3;
    [self addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.bottomCon = make.bottom.equalTo(contentLabel.mas_bottom).offset(ghStatusCellMargin);
    }];
}

- (void)setType:(NSString *)type {
    _type = type;
    if ([type isEqualToString:@"转发需求"]) {
        
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.titleLabel.mas_bottom).offset(ghStatusCellMargin);
        }];
    }else {
        
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.contentLabel.mas_bottom).offset(ghStatusCellMargin);
        }];
    }
}

@end
