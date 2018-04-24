//
//  WQReceivinganOrderTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/7.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQReceivinganOrderTableViewCell.h"
#import "WQWaitOrderModel.h"
#import "WQMyReceivinganOrderViewController.h"

@interface WQReceivinganOrderTableViewCell()

@end

@implementation WQReceivinganOrderTableViewCell {
    // 标题
    UILabel *subjectLabel;
    // 分享数量
    UILabel *forwardingNumberLabel;
    // 观看数量
    UILabel *checkTheNumberLabel;
}
- (void)billingPresonClike:(UIButton *)sender {
    if (self.billingPresonClikeBlock) {
        self.billingPresonClikeBlock();
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.contentView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark -- 初始化setupContentView
- (void)setupContentView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQShouldHideRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQShouldShowRedNotifacation object:nil];
    
    // 背景框,因为有阴影
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdancellbottom"]];
    backgroundImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ghSpacingOfshiwu);
        make.top.equalTo(self.contentView).offset(ghStatusCellMargin);
        make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
        make.bottom.equalTo(self.contentView);
    }];
    
    // 标题
    subjectLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    [self.contentView addSubview:subjectLabel];
    [subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundImageView).offset(ghSpacingOfshiwu);
        make.left.equalTo(backgroundImageView).offset(7);
        make.width.mas_equalTo(kScreenWidth-2*ghSpacingOfshiwu-9);
    }];
    
    // 分享图片
    UIImageView *sharImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdanzhuanfa"]];
    [self.contentView addSubview:sharImageView];
    [sharImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundImageView).offset(ghSpacingOfshiwu);
        make.top.equalTo(subjectLabel.mas_bottom).offset(ghStatusCellMargin);
    }];
    
    // 分享数量
    forwardingNumberLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    [self.contentView addSubview:forwardingNumberLabel];
    [forwardingNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sharImageView.mas_centerY);
        make.left.equalTo(sharImageView.mas_right).offset(5);
    }];
    
    // 观看图片
    UIImageView *checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdanliulan"]];
    [self.contentView addSubview:checkImageView];
    [checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerY.equalTo(sharImageView.mas_centerY);
        make.bottom.equalTo(sharImageView.mas_bottom);
        make.left.equalTo(forwardingNumberLabel.mas_right).offset(ghDistanceershi);
    }];
    
    // 观看数量
    checkTheNumberLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    [self.contentView addSubview:checkTheNumberLabel];
    [checkTheNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(checkImageView.mas_centerY);
        make.left.equalTo(checkImageView.mas_right).offset(5);
    }];
    
    // 联系发单人
    UIButton *contactBtn = [[UIButton alloc] init];
    contactBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [contactBtn setImage:[UIImage imageNamed:@"dingdanlianxifadanren2"] forState:UIControlStateNormal];
    [contactBtn setTitle:@" 联系发单人" forState:UIControlStateNormal];
    [contactBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
    [contactBtn addTarget:self action:@selector(billingPresonClike:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:contactBtn];
    [contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(checkTheNumberLabel);
        make.right.equalTo(backgroundImageView.mas_right).offset(-ghSpacingOfshiwu);
    }];
    
    // 红点
    self.redDotView = [[UIView alloc] init];
    self.redDotView.backgroundColor = [UIColor redColor];
    self.redDotView.layer.cornerRadius = 3;
    self.redDotView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.redDotView];
    [self.redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(contactBtn);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQShouldHideRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQShouldShowRedNotifacation object:nil];
    
}

- (void)hideOrShowDot:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL haveRed = [WQUnreadMessageCenter haveUnreadMessageForBid:self.model.id];
        self.redDotView.hidden = !haveRed;
        if ([self.viewController isKindOfClass:[WQMyReceivinganOrderViewController class]] && haveRed) {
            [[(WQMyReceivinganOrderViewController *)(self.viewController) AwaitOrderBtn] showDotBadge];
        }
    });
    

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldHideRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldShowRedNotifacation object:nil];
}

- (void)setModel:(WQWaitOrderModel *)model {
    _model = model;
    subjectLabel.text = model.subject;
    forwardingNumberLabel.text = model.share_count;
    checkTheNumberLabel.text = model.view_count;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
