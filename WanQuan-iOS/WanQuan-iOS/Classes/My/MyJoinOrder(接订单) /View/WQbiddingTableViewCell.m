//
//  WQbiddingTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/12.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQbiddingTableViewCell.h"
#import "WQWaitOrderModel.h"
#import "WQMyReceivinganOrderViewController.h"
@interface WQbiddingTableViewCell()
//需求内容简介
@property (strong, nonatomic) UILabel *subject;
@property (strong, nonatomic) UILabel *checkTheNumber;
@property (strong, nonatomic) UILabel *forwardingNumber;
// 临时会话按钮
@property (strong, nonatomic) UIButton *linshihuahuaBtn;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wobjc-protocol-property-synthesis"
@implementation WQbiddingTableViewCell
#pragma clang diagnostic pop

- (void)billingPresonClike:(id)sender {
    if (self.billingPresonClikeBlock) {
        self.billingPresonClikeBlock();
    }
}
//完成申请付款
- (void)completeBtnClike:(id)sender {
    if (self.completeBlick) {
        self.completeBlick();
    }
}
//同意取消
- (void)agreedToCancel:(id)sender {
    if (self.agreedToCancelBlock) {
        self.agreedToCancelBlock();
    }
}

- (void)setModel:(WQWaitOrderModel *)model
{
    _model = model;
    self.subject.text = model.subject;
    self.forwardingNumber.text = model.share_count;
    self.checkTheNumber.text = model.view_count;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.agreedToCancelBtn.hidden = YES;
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.contentView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
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
    self.subject = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    [self.contentView addSubview:self.subject];
    [self.subject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundImageView).offset(ghSpacingOfshiwu);
        make.left.equalTo(backgroundImageView).offset(7);
        make.right.equalTo(backgroundImageView).offset(ghSpacingOfshiwu);
    }];
    
    // 分享图片
    UIImageView *sharImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdanzhuanfa"]];
    [self.contentView addSubview:sharImageView];
    [sharImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundImageView).offset(17);
        make.top.equalTo(self.subject.mas_bottom).offset(ghStatusCellMargin);
    }];
    
    // 分享数量
    self.forwardingNumber = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    [self.contentView addSubview:self.forwardingNumber];
    [self.forwardingNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sharImageView.mas_centerY);
        make.left.equalTo(sharImageView.mas_right).offset(5);
    }];
    
    // 观看图片
    UIImageView *checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdanliulan"]];
    [self.contentView addSubview:checkImageView];
    [checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sharImageView.mas_bottom);
        make.left.equalTo(self.forwardingNumber.mas_right).offset(ghDistanceershi);
    }];
    
    // 观看数量
    self.checkTheNumber = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    [self.contentView addSubview:self.checkTheNumber];
    [self.checkTheNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(checkImageView.mas_centerY);
        make.left.equalTo(checkImageView.mas_right).offset(5);
    }];
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(sharImageView.mas_bottom).offset(ghStatusCellMargin);
        make.height.offset(0.5);
    }];
    
    // 对方申请取消交易
    self.promptLabel = [UILabel labelWithText:@"对方申请取消交易" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    self.promptLabel.hidden = YES;
    [self.contentView addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.checkTheNumber.mas_centerY);
        make.right.equalTo(backgroundImageView.mas_right).offset(-ghStatusCellMargin);
    }];
    
    
    // 中间的线
    self.agreedToCancelBtn = [[UIButton alloc] init];
    [self.agreedToCancelBtn addTarget:self action:@selector(agreedToCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.agreedToCancelBtn setTitle:@"|" forState:UIControlStateNormal];
    [self.agreedToCancelBtn setTitleColor:[UIColor colorWithHex:0x5d2a89] forState:UIControlStateNormal];
    self.agreedToCancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.agreedToCancelBtn];
    [self.agreedToCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.promptLabel.mas_bottom).offset(8);
    }];
    
    self.linshihuahuaBtn = [[UIButton alloc] init];
    self.linshihuahuaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.linshihuahuaBtn addTarget:self action:@selector(billingPresonClike:) forControlEvents:UIControlEventTouchUpInside];
    [self.linshihuahuaBtn setImage:[UIImage imageNamed:@"linshihuihua"] forState:UIControlStateNormal];
    [self.linshihuahuaBtn setTitle:@"临时会话" forState:UIControlStateNormal];
    [self.linshihuahuaBtn setTitleColor:[UIColor colorWithHex:0x5d2a89] forState:UIControlStateNormal];
    [self.contentView addSubview:self.linshihuahuaBtn];
    [self.linshihuahuaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.agreedToCancelBtn.mas_left).offset(kScaleY(-33));
        make.centerY.equalTo(self.agreedToCancelBtn.mas_centerY);
    }];
    
    // 红点
    self.redDotView = [[UIView alloc] init];
    self.redDotView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.redDotView];
    [self.redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.left.top.equalTo(self.linshihuahuaBtn);
    }];
    
    // 完成申请付款
    self.completeBtn = [[UIButton alloc] init];
    self.completeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.completeBtn setImage:[UIImage imageNamed:@"wanchengshenqingfukuan"] forState:UIControlStateNormal];
    [self.completeBtn setTitle:@"完成申请付款" forState:UIControlStateNormal];
    [self.completeBtn addTarget:self action:@selector(completeBtnClike:) forControlEvents:UIControlEventTouchUpInside];
    [self.completeBtn setTitleColor:[UIColor colorWithHex:0x5d2a89] forState:UIControlStateNormal];
    [self.contentView addSubview:self.completeBtn];
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.agreedToCancelBtn.mas_centerY);
        make.left.equalTo(self.agreedToCancelBtn.mas_right).offset(kScaleY(33));
    }];
    
    // 黄色的图
    self.yellowEdges = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"duifangbutongyizhifu"]];
    self.yellowEdges.hidden = YES;
    [self.contentView addSubview:self.yellowEdges];
    [self.yellowEdges mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 24));
        make.top.equalTo(backgroundImageView).offset(2);
        make.right.equalTo(backgroundImageView).offset(-2);
    }];
    
    // 橘色的图
    self.orangeEdges = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"duifangshenqingquxiaojiaoyi"]];
    self.orangeEdges.hidden = YES;
    [self.contentView addSubview:self.orangeEdges];
    [self.orangeEdges mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 24));
        make.top.equalTo(backgroundImageView).offset(2);
        make.right.equalTo(backgroundImageView).offset(-2);
    }];
}

- (void)hideOrShowDot:(NSNotification *)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL haveRed = [WQUnreadMessageCenter haveUnreadBidChatForBid:self.model.id];
        self.redDotView.hidden = !haveRed;
        if ([self.viewController isKindOfClass:[WQMyOrderViewController class]] && haveRed) {
            [[(WQMyReceivinganOrderViewController *)(self.viewController) GettedBtn] showDotBadge];
        }
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldShowRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldHideRedNotifacation object:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
