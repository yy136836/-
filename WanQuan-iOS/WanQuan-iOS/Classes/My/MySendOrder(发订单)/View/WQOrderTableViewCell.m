//
//  WQOrderTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/6.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQOrderTableViewCell.h"
#import "WQWaitOrderModel.h"
#import "WQdetailsConrelooerViewController.h"
#import "WQMyOrderViewController.h"
@interface WQOrderTableViewCell()
@property (strong, nonatomic) UILabel *subject;    //内容
@property (strong, nonatomic) UILabel *forwardingNumber;
@property (strong, nonatomic) UILabel *checkTheNumber;
@property (strong, nonatomic) UILabel *timeLabel;
@property (copy, nonatomic) NSString *huanxinID;
@property (weak, nonatomic) UIView *leftView;
@property (weak, nonatomic) UIView *bootomView;
@property (weak, nonatomic) UIView *reghtView;
@property (weak, nonatomic) UIView *topView;




@end

@implementation WQOrderTableViewCell

- (void)setWaitorderModel:(WQWaitOrderModel *)waitorderModel {
    _waitorderModel = waitorderModel;
    self.subject.text = waitorderModel.subject;
    self.forwardingNumber.text = waitorderModel.share_count;
    self.checkTheNumber.text = waitorderModel.view_count;
    self.timeLabel.text = waitorderModel.finished_date;
}

#pragma mark - 接单人员点击事件
//- (IBAction)personnelClike:(id)sender {
//    //订单详情控制器
//    if (self.personnelClikeBlock) {
//        self.personnelClikeBlock();
//    }
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.alpha = 1;
    self.redDotView.layer.cornerRadius = 3;
    self.redDotView.layer.masksToBounds = YES;
    self.backgroundView.layer.cornerRadius = 5;
    self.backgroundView.layer.masksToBounds = YES;
    self.leftView.backgroundColor = [UIColor colorWithHex:0xededed];
    self.reghtView.backgroundColor = [UIColor colorWithHex:0xededed];
    self.topView.backgroundColor = [UIColor colorWithHex:0xededed];
    self.bootomView.backgroundColor = [UIColor colorWithHex:0xededed];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQShouldHideRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQShouldShowRedNotifacation object:nil];
    
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
    self.subject = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
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
        //make.centerY.equalTo(sharImageView.mas_centerY);
        make.bottom.equalTo(sharImageView.mas_bottom);
        make.left.equalTo(self.forwardingNumber.mas_right).offset(ghDistanceershi);
    }];
    
    // 观看数量
    self.checkTheNumber = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    [self.contentView addSubview:self.checkTheNumber];
    [self.checkTheNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(checkImageView.mas_centerY);
        make.left.equalTo(checkImageView.mas_right).offset(5);
    }];
    
    // 红点
    self.redDotView = [[UIView alloc] init];
    self.redDotView.backgroundColor = [UIColor redColor];
    self.redDotView.layer.cornerRadius = 3;
    self.redDotView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.redDotView];
    [self.redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backgroundImageView.mas_centerY);
        make.right.equalTo(backgroundImageView).offset(-ghSpacingOfshiwu);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];
}

- (void)hideOrShowDot:(NSNotification *)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL haveRed = [WQUnreadMessageCenter haveUnreadMessageForBid:self.waitorderModel.id];
        self.redDotView.hidden = !haveRed;
        if ([self.viewController isKindOfClass:[WQMyOrderViewController class]] && haveRed) {
            [[(WQMyOrderViewController *)(self.viewController) AwaitOrderBtn] showDotBadge];
        }
    });
    

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldHideRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldShowRedNotifacation object:nil];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
