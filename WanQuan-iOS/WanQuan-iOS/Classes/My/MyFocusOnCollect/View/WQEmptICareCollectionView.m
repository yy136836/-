//
//  WQEmptICareCollectionView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/11.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQEmptICareCollectionView.h"

@implementation WQEmptICareCollectionView {
    UILabel *tagLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
        [self setupUI];
    }
    return self;
}

#pragma mark -- 初始化UI
- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guanzhukong"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(94.5);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    tagLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    [self addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(25);
    }];
}

- (void)setStatus:(Status)status {
    _status = status;
    if (self.status == IFocusOn) {
        tagLabel.text = @"还没有关注人";
    }else if (self.status == PayAttentionToMy) {
        tagLabel.text = @"还没有被关注";
    }else if (self.status == PayAttentionToMe) {
        tagLabel.text = @"还没有收藏";
    }
}

@end
