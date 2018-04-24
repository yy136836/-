//
//  WQTopSearchCollectionViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/9.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTopSearchCollectionViewCell.h"

@implementation WQTopSearchCollectionViewCell {
    UILabel *textLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;

    }
    return self;
}

#pragma mark -- 初始化UI
- (void)setupUI {
    textLabel = [UILabel labelWithText:@"title" andTextColor:[UIColor colorWithHex:0x777777] andFontSize:14];
    [self.contentView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    
    textLabel.text = titleString;
}

@end
