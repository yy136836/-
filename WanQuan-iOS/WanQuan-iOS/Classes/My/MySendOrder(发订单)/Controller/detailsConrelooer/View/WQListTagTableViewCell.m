//
//  WQListTagTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/5/26.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQListTagTableViewCell.h"

@implementation WQListTagTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    UIView *lineTwoView = [[UIView alloc] init];
    lineTwoView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    [self.contentView addSubview:lineTwoView];
    [lineTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.height.offset(ghStatusCellMargin);
    }];
    
    // 前边的一条紫线
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHex:0x9872ca];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(3, 17));
        make.left.equalTo(self.contentView).offset(ghSpacingOfshiwu);
        make.top.equalTo(lineTwoView.mas_bottom).offset(ghSpacingOfshiwu);
    }];
    
    // 观看者列表
    UILabel *tagLabel = [UILabel labelWithText:@"领取者列表" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    tagLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    [self.contentView addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(view.mas_right).offset(8);
    }];
    
    // 领取人数
    UILabel *watchLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    self.watchLabel = watchLabel;
    [self.contentView addSubview:watchLabel];
    [watchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tagLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
    
    // 底部分割线
//    UIView *bottomLineView = [[UIView alloc] init];
//    bottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
//    [self.contentView addSubview:bottomLineView];
//    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.right.left.equalTo(self.contentView);
//        make.height.offset(0.5);
//    }];
}

@end
