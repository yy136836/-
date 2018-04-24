//
//  WQloseAbidTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/12.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQloseAbidTableViewCell.h"
#import "WQWaitOrderModel.h"

@interface WQloseAbidTableViewCell()
// 历史会话的按钮
@property (strong, nonatomic) UIButton *historyBtn;
// 分享的数量
@property (strong, nonatomic) UILabel *forwardingNumber;
// 分享的图片
@property (strong, nonatomic) UIImageView *forwardingImageView;
// 被查看的数量
@property (strong, nonatomic) UILabel *checkTheNumber;
// 查看的图片
@property (strong, nonatomic) UIImageView *checkImageView;
//需求内容简介
@property (strong, nonatomic) UILabel *subject;
// 中间的分割线
@property (nonatomic, strong) UIView *centenLine;
// 分割线
@property (nonatomic, strong) UIView *lineView;

@end

@implementation WQloseAbidTableViewCell


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
    self.lineView = lineView;
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(sharImageView.mas_bottom).offset(ghStatusCellMargin);
        make.height.offset(0.5);
    }];
    
    // 中间的分割线
    UIView *centenLine = [[UIView alloc] init];
    self.centenLine = centenLine;
    centenLine.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:centenLine];
    [centenLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.offset(0.5);
        make.height.offset(ghDistanceershi);
        make.top.equalTo(lineView.mas_bottom).offset(7);
    }];
    
    // 评价的按钮
    self.evaluationBtn = [[UIButton alloc] init];
    self.evaluationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.evaluationBtn setTitle:@" 评价" forState:UIControlStateNormal];
    [self.evaluationBtn addTarget:self action:@selector(EvaluateClike:) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluationBtn setTitleColor:[UIColor colorWithHex:0x5d2a89] forState:UIControlStateNormal];
    [self.evaluationBtn setImage:[UIImage imageNamed:@"pingjiagaoliang"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.evaluationBtn];
    [self.evaluationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centenLine.mas_right).offset(kScaleY(40));
        make.centerY.equalTo(centenLine.mas_centerY);
    }];
    
    // 历史会话
    self.historyBtn = [[UIButton alloc] init];
    self.historyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.historyBtn setTitle:@"历史会话" forState:UIControlStateNormal];
    [self.historyBtn setTitleColor:[UIColor colorWithHex:0x5d2a89] forState:UIControlStateNormal];
    [self.historyBtn setImage:[UIImage imageNamed:@"linshihuihua"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.historyBtn];
    [self.historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(centenLine.mas_centerY);
        make.right.equalTo(centenLine.mas_left).offset(kScaleY(-40));
    }];
    [_historyBtn addTarget:self action:@selector(chatHistoryButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)chatHistoryButtonOnClick:(UIButton *)sender {
    if (self.chatHistoryOnCkick) {
        self.chatHistoryOnCkick();
    }
}

- (void)EvaluateClike:(id)sender {
    if (self.evaluateBtnClikeBlock) {
        self.evaluateBtnClikeBlock();
    }
}

- (void)setModel:(WQWaitOrderModel *)model {
    _model =model;
    self.subject.text = model.subject;
    self.forwardingNumber.text = model.share_count;
    self.checkTheNumber.text = model.view_count;
    
    // 如果是BSS的话不要临时会话和评价
    if ([self.model.category_level_1 isEqualToString:@"BBS"]) {
        self.centenLine.hidden = YES;
        self.historyBtn.hidden = YES;
        self.evaluationBtn.hidden = YES;
        self.lineView.hidden = YES;
    }else {
        self.centenLine.hidden = NO;
        self.historyBtn.hidden = NO;
        self.evaluationBtn.hidden = NO;
        self.lineView.hidden = NO;
    }
}

@end
