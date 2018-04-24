//
//  WQlikeListView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/27.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQlikeListView.h"
#import "WQzanLike_listModel.h"
#import <objc/runtime.h>

@interface WQlikeListView()

@property (strong, nonatomic) MASConstraint *bottomCon;

@property (nonatomic, strong) UIImageView *praiseImageView;

@end

@implementation WQlikeListView

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
    [self addSubview:self.praiseImageView];
    [self addSubview:self.user_nameLabel];
    [self addSubview:self.bottomLineView];
    
//    [self.praiseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self);
//        make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu));
//    }];
//    [_user_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self);
//        //        make.top.equalTo(self).offset(kScaleX(1));
//        make.centerY.equalTo(self);
//        //make.height.equalTo(@(height));
//        //make.bottom.equalTo(self).offset(-5);
//        make.left.equalTo(self.mas_left).offset(kScaleY(15) + 20);
//    }];
//    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self);
//        make.top.equalTo(_user_nameLabel.mas_bottom).offset(ghStatusCellMargin);
//        make.bottom.equalTo(self);
//        make.height.offset(0.5);
//    }];
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        self.bottomCon = make.bottom.equalTo(_bottomLineView.mas_bottom);
//    }];
}

- (void)setLikeArray:(NSArray *)likeArray {
    _likeArray = likeArray;
    
    if (likeArray.count) {
        _praiseImageView.hidden = NO;
    }
    
    NSMutableString *strM = [NSMutableString string];
    NSInteger degreesFriendCount = 0;
    
    NSMutableArray * frinedArray = @[].mutableCopy;
    
    for (int i = 0; i < likeArray.count; i ++) {
        WQzanLike_listModel *model = likeArray[i];
        if ([[NSString stringWithFormat:@"%@",model.user_name] isEqualToString:@"好友的好友"]) {
            degreesFriendCount ++;
            continue;
        }
        [frinedArray addObject:model];
    }

    if (frinedArray.count) {
        for (NSInteger i = 0 ; i < frinedArray.count; ++ i) {
            
            WQzanLike_listModel *model = frinedArray[i];
            
            [strM appendString:model.user_name];
            if (i != frinedArray.count - 1) {
                [strM appendString:@","];
            }
        }
    }

    if (degreesFriendCount) {
        if (frinedArray.count) {
            [strM appendString:@"及"];
        }
        [strM appendString:[NSString stringWithFormat:@"%@%@",degreesFriendCount > 1 ? [NSString stringWithFormat:@"%ld%@",degreesFriendCount,@"个"]:@"", @"好友的好友"]];
    }
    
    if (likeArray.count != 0) {
        self.user_nameLabel.text = [strM stringByAppendingString:@"觉的很赞"];
    }
    
    [_praiseImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu));
    }];
    CGFloat height = [self.user_nameLabel sizeThatFits:CGSizeMake(self.user_nameLabel.preferredMaxLayoutWidth, MAXFLOAT)].height;
    [_user_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self);
        make.height.equalTo(@(height));
        make.left.equalTo(self.mas_left).offset(kScaleY(15) + 20);
    }];
    [_bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_user_nameLabel.mas_bottom).offset(ghStatusCellMargin);
        make.bottom.equalTo(self);
        make.height.offset(0.5);
    }];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        self.bottomCon = make.bottom.equalTo(_bottomLineView.mas_bottom);
    }];
}

#pragma mark - 懒加载
- (UILabel *)user_nameLabel {
    if (!_user_nameLabel) {
        _user_nameLabel = [[UILabel alloc]init];
        _user_nameLabel.textColor = [UIColor colorWithHex:0x333333];
        _user_nameLabel.text = @"";
        _user_nameLabel.font = [UIFont systemFontOfSize:13];
        _user_nameLabel.numberOfLines = 0;
        _user_nameLabel.preferredMaxLayoutWidth = kScreenWidth - 2 * (CGFloat)ghSpacingOfshiwu;
//        _user_nameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    }
    return _user_nameLabel;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    }
    return _bottomLineView;
}
- (UIImageView *)praiseImageView {
    if (!_praiseImageView) {
        _praiseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dianzanren"]];
        _praiseImageView.hidden = YES;
    }
    return _praiseImageView;
}

@end
