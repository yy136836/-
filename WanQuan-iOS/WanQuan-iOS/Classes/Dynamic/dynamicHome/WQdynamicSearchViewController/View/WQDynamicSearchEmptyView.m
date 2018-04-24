//
//  WQDynamicSearchEmptyView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/29.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQDynamicSearchEmptyView.h"

@implementation WQDynamicSearchEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    UILabel *textLabel = [UILabel labelWithText:@"输入关键词,可以搜到含有" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:16];
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).offset(67);
    }];
    UILabel *label = [UILabel labelWithText:@"相关内容的动态" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:16];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(textLabel.mas_bottom).offset(5);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sousuotubiao"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(label.mas_bottom).offset(ghSpacingOfshiwu);
    }];
}

@end
