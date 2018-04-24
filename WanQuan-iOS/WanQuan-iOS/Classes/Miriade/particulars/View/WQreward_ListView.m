//
//  WQreward_ListView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/2/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQreward_ListView.h"
#import "WQrewardListModel.h"

@interface WQreward_ListView ()

@property (nonatomic, strong) UIImageView *exceptionalIamgeView;
@property (strong, nonatomic) MASConstraint *bottomCon;

@end

@implementation WQreward_ListView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    UIImageView *exceptionalIamgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guliren"]];
    self.exceptionalIamgeView = exceptionalIamgeView;
    self.exceptionalIamgeView.hidden = YES;
    [self addSubview:exceptionalIamgeView];
//    [exceptionalIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(kScaleX(1));
//        make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu));
//    }];
    
    [self addSubview:self.user_nameLabel];
//    [_user_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.bottom.equalTo(self);
//        make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu) + 20);
//        make.right.equalTo(self.mas_right).offset(kScaleY(-ghSpacingOfshiwu));
//    }];
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        self.bottomCon = make.bottom.equalTo(_user_nameLabel.mas_bottom).offset(12);
//    }];
}

- (void)setReward_list:(NSArray *)reward_list {
    _reward_list = reward_list;
    if (reward_list.count) {
        self.exceptionalIamgeView.hidden = NO;
    }
    NSMutableString *strM = [NSMutableString string];
    for (int i = 0; i < reward_list.count; i ++) {
        WQrewardListModel *model = reward_list[i];
        [strM appendString:[[model.user_name stringByAppendingString:@"鼓励了"]stringByAppendingString:[model.money stringByAppendingString:@"元"]]];
        if (i != reward_list.count - 1) {
            [strM appendString:@","];
        }
    }
    if (reward_list.count != 0) {
        self.user_nameLabel.text = strM;
    }
    
    [_exceptionalIamgeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kScaleX(1));
        make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu));
    }];
//    CGFloat height = [self.user_nameLabel sizeThatFits:CGSizeMake(self.user_nameLabel.preferredMaxLayoutWidth, MAXFLOAT)].height;
    [_user_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
//        make.height.offset(height);
        make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu) + 20);
        make.right.equalTo(self.mas_right).offset(kScaleY(-ghSpacingOfshiwu));
    }];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        self.bottomCon = make.bottom.equalTo(_user_nameLabel.mas_bottom).offset(12);
    }];
}

#pragma mark - 懒加载
- (YYLabel *)user_nameLabel {
    if (!_user_nameLabel) {
        _user_nameLabel = [[YYLabel alloc]init];
        _user_nameLabel.textColor = [UIColor colorWithHex:0x333333];
        _user_nameLabel.text = @"";
        _user_nameLabel.font = [UIFont systemFontOfSize:13];
        _user_nameLabel.numberOfLines = 100;
        _user_nameLabel.preferredMaxLayoutWidth = kScreenWidth - 2 * (CGFloat)ghDistanceershi;
    }
    return _user_nameLabel;
}

@end
