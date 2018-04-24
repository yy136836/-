//
//  WQTemporaryInquiryCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTemporaryInquiryCell.h"
#import "WQWaitOrderModel.h"
#import "WQdetailsConrelooerViewController.h"
#import "WQMyOrderViewController.h"

@interface   WQTemporaryInquiryCell()
// 标题
@property (strong, nonatomic) UILabel *subject;
// 分享数量
@property (strong, nonatomic) UILabel *forwardingNumber;
// 查看数量
@property (strong, nonatomic) UILabel *checkTheNumber;
@end

@implementation WQTemporaryInquiryCell

#pragma mark - 接单人员点击事件
//- (IBAction)personnelClike:(id)sender {
//    //订单详情控制器
//    if (self.personnelClikeBlock) {
//        self.personnelClikeBlock();
//    }
//}

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
        make.top.left.equalTo(self.contentView).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
        make.bottom.equalTo(self.contentView);
    }];
    
    // 标题
    self.subject = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    [self.contentView addSubview:self.subject];
    [self.subject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(backgroundImageView).offset(ghSpacingOfshiwu);
        make.right.equalTo(backgroundImageView).offset(ghSpacingOfshiwu);
    }];
    
    // 分享图片
    UIImageView *sharImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdanzhuanfa"]];
    [self.contentView addSubview:sharImageView];
    [sharImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundImageView).offset(ghSpacingOfshiwu);
        make.top.equalTo(self.subject.mas_bottom).offset(ghSpacingOfshiwu);
    }];
    
    // 分享数量
    self.forwardingNumber = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    [self.contentView addSubview:self.forwardingNumber];
    [self.forwardingNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sharImageView.mas_centerY);
        make.left.equalTo(sharImageView.mas_right).offset(5);
    }];
    
    // 观看图片
    UIImageView *checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdanliulan"]];
    [self.contentView addSubview:checkImageView];
    [checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sharImageView.mas_centerY);
        make.left.equalTo(self.forwardingNumber.mas_right).offset(ghDistanceershi);
    }];
    
    // 观看数量
    self.checkTheNumber = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    [self.contentView addSubview:self.checkTheNumber];
    [self.checkTheNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(checkImageView.mas_centerY);
        make.left.equalTo(checkImageView.mas_right).offset(5);
    }];
    
    // 联系发单人按钮
    self.contactBiderButton = [[UIButton alloc] init];
    self.contactBiderButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contactBiderButton setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
    [self.contactBiderButton setImage:[UIImage imageNamed:@"dingdanlianxifadanren2"] forState:UIControlStateNormal];
    [self.contactBiderButton setTitle:@" 联系发单人" forState:UIControlStateNormal];
    [self.contentView addSubview:self.contactBiderButton];
    [self.contactBiderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.checkTheNumber.mas_centerY);
        make.right.equalTo(backgroundImageView.mas_right).offset(-ghSpacingOfshiwu);
    }];
    
    // 红点
    self.redDotView = [[UIView alloc] init];
    self.redDotView.backgroundColor = [UIColor redColor];
    self.redDotView.layer.cornerRadius = 3;
    self.redDotView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.redDotView];
    [self.redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contactBiderButton);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];
}

- (void)setWaitorderModel:(WQWaitOrderModel *)waitorderModel {
    _waitorderModel = waitorderModel;
    self.subject.text = waitorderModel.subject;
    self.forwardingNumber.text = waitorderModel.share_count;
    self.checkTheNumber.text = waitorderModel.view_count;
}

- (void)hideOrShowDot:(NSNotification *)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL haveRed = [WQUnreadMessageCenter haveUnreadTmpChatForBid:self.waitorderModel.id];
        self.redDotView.hidden = !haveRed;
        if ([self.viewController isKindOfClass:[WQMyOrderViewController class]] && haveRed) {
//            [[(WQMyOrderViewController *)(self.viewController) AwaitOrderBtn] showDotBadge];
        }
    });
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldHideRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldShowRedNotifacation object:nil];
}

@end

