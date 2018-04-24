//
//  WQMySetupTableViewCacheCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQMySetupTableViewCacheCell.h"

@implementation WQMySetupTableViewCacheCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 初始化setupContentView
- (void)setupContentView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qingchuhuancun"]];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    UILabel *Label = [UILabel labelWithText:@"清除缓存" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    [self.contentView addSubview:Label];
    [Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(imageView.mas_right).offset(12);
    }];
    
    UILabel *contLabel = [UILabel labelWithText:@"正在计算..." andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    self.contLabel = contLabel;
    [self.contentView addSubview:contLabel];
    [contLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];

}

@end
