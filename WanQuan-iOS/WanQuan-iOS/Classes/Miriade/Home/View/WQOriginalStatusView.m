//
//  WQOriginalStatusView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/13.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQOriginalStatusView.h"
#import "WQUserProfileController.h"

@interface WQOriginalStatusView()<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) MASConstraint *bottomCon;
@property (nonatomic, strong) UIButton *shareBtn;
@end

@implementation WQOriginalStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    [self addSubview:self.iconView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.tagOncLabel];
    [self addSubview:self.tagTwoLabel];
    [self addSubview:self.shareBtn];
    [self addSubview:self.creditPointsLabel];
    
    // 自动布局
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(ghSpacingOfshiwu);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconView).offset(10);
        make.left.equalTo(_iconView.mas_right).offset(ghStatusCellMargin);
    }];
    
    [_tagOncLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.bottom.equalTo(_iconView).offset(-3);
    }];
    
    [_tagTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tagOncLabel.mas_right).offset(ghStatusCellMargin);
        make.top.equalTo(_tagOncLabel);
    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-ghSpacingOfshiwu);
    }];
    
    // 信用分的背景view
    [self addSubview:self.creditBackgroundView];
    [_creditBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(38, 14));
        make.left.equalTo(self.self.nameLabel.mas_right).offset(ghStatusCellMargin);
    }];
    
    // 信用分图标
    [_creditBackgroundView addSubview:self.creditImageView];
    [_creditImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_creditBackgroundView.mas_centerY);
        make.left.equalTo(_creditBackgroundView.mas_left).offset(5);
    }];
    // 信用分数
    [_creditBackgroundView addSubview:self.creditPointsLabel];
    [_creditPointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_creditBackgroundView.mas_centerY);
        make.left.equalTo(_creditImageView.mas_right).offset(1);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.bottomCon = make.bottom.equalTo(_iconView.mas_bottom);
    }];
    
}

#pragma mark - 转发按钮
- (void)shareBtnClike:(UIButton *) sender {
    if (self.ClikeBlock) {
        self.ClikeBlock(sender);
    }
}

// 点击头像
- (void)handleTapGes:(UITapGestureRecognizer *)tap {
    /*if ([[WQDataSource sharedTool].loginStatus isEqualToString:@"STATUS_UNVERIFY"]) {
        // 快速注册的用户
        UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"实名认证后可查看用户信息"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 NSLog(@"取消");
                                                             }];
        UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"实名认证"
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:[WQDataSource sharedTool].userIdString];
                                                                      [self.viewController.navigationController pushViewController:vc animated:YES];
                                                                  }];
        [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
        [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
        
        [alertController addAction:cancelButton];
        [alertController addAction:destructiveButton];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
    }*/
    
    if (self.headPortraitBlock) {
        self.headPortraitBlock();
    }
}

#pragma mark - 懒加载
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Userpic"]];
        _iconView.layer.cornerRadius = 25;
        _iconView.layer.masksToBounds = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
        [_iconView addGestureRecognizer:tap];
    }
    return _iconView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithText:@"用户名" andTextColor:[UIColor colorWithHex:0X111111] andFontSize:16];
    }
    return _nameLabel;
}

- (UILabel *)tagOncLabel {
    if (!_tagOncLabel) {
        _tagOncLabel = [UILabel labelWithText:@"#标签1" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    }
    return _tagOncLabel;
}

- (UILabel *)tagTwoLabel {
    if (!_tagTwoLabel) {
        _tagTwoLabel = [UILabel labelWithText:@"#标签2" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    }
    return _tagTwoLabel;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc]init];
        [_shareBtn setImage:[UIImage imageNamed:@"haoyouquanzhaunfa"] forState:0];
        [_shareBtn addTarget:self action:@selector(shareBtnClike:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

// 信用分数
- (UILabel *)creditPointsLabel {
    if (!_creditPointsLabel) {
        _creditPointsLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x9871c9] andFontSize:9];
    }
    return _creditPointsLabel;
}
// 信用分的背景view
- (UIView *)creditBackgroundView {
    if (!_creditBackgroundView) {
        _creditBackgroundView = [[UIView alloc] init];
        _creditBackgroundView.backgroundColor = [UIColor colorWithHex:0xf4f0ff];
        _creditBackgroundView.layer.cornerRadius = 2;
        _creditBackgroundView.layer.masksToBounds = YES;
    }
    return _creditBackgroundView;
}

// 信用分图标
- (UIImageView *)creditImageView {
    if (!_creditImageView) {
        _creditImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyexinyongfen"]];
    }
    return _creditImageView;
}

@end
