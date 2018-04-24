//
//  WQDynamicDetailsCommentTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQDynamicDetailsCommentTableViewCell.h"
#import "WQDynamicLevelOncCommentModel.h"
#import "WQDynamicLevelSecondaryModel.h"
#import "WQSecondaryReplyView.h"
#import "WQCommentDetailsViewController.h"
@class WQEssenceDetailController;
@interface WQDynamicDetailsCommentTableViewCell () <UITableViewDelegate, UITableViewDataSource,WQSecondaryReplyViewDelegate>

/**
 头像
 */
@property (nonatomic, strong) UIImageView *user_pic;

/**
 姓名
 */
@property (nonatomic, strong) UILabel *user_name;

/**
 信用分的背景view
 */
@property (nonatomic, strong) UIView *creditBackgroundView;

/**
 几度好友
 */
@property (nonatomic, strong) UILabel *aFewDegreesBackgroundLabel;

/**
 信用分图标
 */
@property (nonatomic, strong) UIImageView *creditImageView;

/**
 信用分数
 */
@property (nonatomic, strong) UILabel *creditLabel;

/**
 评论
 */
@property (nonatomic, strong) UIButton *commentsBtn;

/**
 时间
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 二级回复
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 底部分割线
 */
@property (nonatomic, strong) UIView *lineView;

/**
 二级回复的View
 */
@property (nonatomic, strong) WQSecondaryReplyView *replyView;

@end

@implementation WQDynamicDetailsCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -- 初始化contentView
- (void)setupContentView {
    // 头像
    self.user_pic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    self.user_pic.contentMode = UIViewContentModeScaleAspectFill;
    self.user_pic.layer.cornerRadius = 20;
    self.user_pic.layer.masksToBounds = YES;
    self.user_pic.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headBtnClike)];
    [self.user_pic addGestureRecognizer:tap];
    [self.contentView addSubview:self.user_pic];
    [self.user_pic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.top.equalTo(self.contentView).offset(ghSpacingOfshiwu);
    }];
    
    // 姓名
    self.user_name = [UILabel labelWithText:@"石子晶" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:14];
    [self.contentView addSubview:self.user_name];
    [self.user_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.left.equalTo(self.user_pic.mas_right).offset(kScaleY(ghSpacingOfshiwu));
        make.height.offset(16);
    }];
    
    // 信用分的背景view
    [self.contentView addSubview:self.creditBackgroundView];
    [_creditBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.user_name.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(38, 14));
        make.left.equalTo(self.user_name.mas_right).offset(ghStatusCellMargin);
    }];
    // 几度好友
    [self.contentView addSubview:self.aFewDegreesBackgroundLabel];
    [_aFewDegreesBackgroundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_creditBackgroundView.mas_centerY);
        make.left.equalTo(_creditBackgroundView.mas_right).offset(6);
        make.height.offset(14);
    }];
    // 信用分图标
    [_creditBackgroundView addSubview:self.creditImageView];
    [_creditImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_creditBackgroundView.mas_centerY);
        make.left.equalTo(_creditBackgroundView.mas_left).offset(5);
    }];
    // 信用分数
    [_creditBackgroundView addSubview:self.creditLabel];
    [_creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_creditBackgroundView.mas_centerY);
        make.left.equalTo(_creditImageView.mas_right).offset(1);
    }];
    
    // 评论
    UIButton *commentsBtn = [[UIButton alloc] init];
    self.commentsBtn = commentsBtn;
    commentsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [commentsBtn addTarget:self action:@selector(commentsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [commentsBtn setImage:[UIImage imageNamed:@"huifuxiaoxi"] forState:UIControlStateNormal];
    [self addSubview:commentsBtn];
    [commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.user_pic.mas_centerY);
        make.right.equalTo(self).offset(kScaleX(-ghSpacingOfshiwu));
        make.height.equalTo(@30);
    }];
    
    // 赞
    UIButton *praiseBtn = [[UIButton alloc] init];
    self.praiseBtn = praiseBtn;
    praiseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [praiseBtn addTarget:self action:@selector(praiseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [praiseBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
    [praiseBtn setTitle:@" 赞" forState:UIControlStateNormal];
    [praiseBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [self addSubview:praiseBtn];
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.user_pic.mas_centerY);
        make.right.equalTo(commentsBtn.mas_left).offset(kScaleX(-28));
        make.height.equalTo(@30);
    }];
    
    // 时间
    UILabel *timeLabel = [UILabel labelWithText:@"2分钟前" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:12];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.user_name.mas_left);
        make.top.equalTo(self.user_name.mas_bottom).offset(6);
        make.height.offset(14);
    }];
    
    // 一级回复
    UILabel *replyLabel = [UILabel labelWithText:@"咱们加个好友讨论一下咱们加个好友讨论一下咱们加个好友讨论一下" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:15];
    replyLabel.numberOfLines = 0;
    replyLabel.userInteractionEnabled = YES;
    self.replyLabel = replyLabel;
    [self.contentView addSubview:replyLabel];
    [replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_left);
        make.top.equalTo(timeLabel.mas_bottom).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.contentView).offset(-ghDistanceershi);
    }];
    
    WQSecondaryReplyView *replyView = [[WQSecondaryReplyView alloc] init];
    replyView.delegate = self;
    self.replyView = replyView;
    [self.contentView addSubview:replyView];
    [replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(replyLabel.mas_left);
        make.top.equalTo(replyLabel.mas_bottom).offset(ghStatusCellMargin);
        make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
    }];
    
    // 底部分割线
    UIView *lineView = [[UIView alloc] init];
    self.lineView = lineView;
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.right.bottom.equalTo(self.contentView);
        make.left.equalTo(timeLabel.mas_left);
        make.top.equalTo(replyView.mas_bottom).offset(ghSpacingOfshiwu);
    }];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)setModel:(WQDynamicLevelOncCommentModel *)model {
    _model = model;
    self.replyLabel.text = model.content;
    self.user_name.text = model.user_name;
    
    // 是否有赞
    if (model.like_count >= 1) {
        [self.praiseBtn setTitle:[NSString stringWithFormat:@"   %d",model.like_count] forState:UIControlStateNormal];
    }else {
        [self.praiseBtn setTitle:[NSString stringWithFormat:@" 赞"] forState:UIControlStateNormal];
    }
    
    // 已过时间
       NSInteger time = [model.past_second integerValue];
        self.timeLabel.text =[WQTool getCommentTime:time];
    
    // 是否赞过
    if (model.isLiked) {
        [self.praiseBtn setTitleColor:[UIColor colorWithHex:0xee9b11] forState:UIControlStateNormal];
        [self.praiseBtn setImage:[UIImage imageNamed:@"dynamicyidianzan"] forState:UIControlStateNormal];
    }else {
        [self.praiseBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        [self.praiseBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
    }
    
    [self.user_pic yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_MIDDLE_URLSTRING(model.user_pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];

    self.aFewDegreesBackgroundLabel.text = [WQTool friendship:[model.user_degree integerValue]];
    self.creditLabel.text = [[NSString stringWithFormat:@"%@",model.user_creditscore] stringByAppendingString:@"分"];
    
    if (model.comment_children_count > 0) {
        self.replyView.comment_children_count = model.comment_children_count;
        self.replyView.dataArray = model.comment_children;
        self.replyView.hidden = NO;
        [self.replyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.replyLabel.mas_left);
            make.top.equalTo(self.replyLabel.mas_bottom).offset(ghStatusCellMargin);
            make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
        }];
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0.5);
            make.right.bottom.equalTo(self.contentView);
            make.left.equalTo(self.timeLabel.mas_left);
            make.top.equalTo(self.replyView.mas_bottom).offset(ghSpacingOfshiwu);
        }];
    }else {
        self.replyView.hidden = YES;
        [self.replyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0.5);
            make.right.bottom.equalTo(self.contentView);
            make.left.equalTo(self.timeLabel.mas_left);
            make.top.equalTo(self.replyLabel.mas_bottom).offset(ghSpacingOfshiwu);
        }];
    }
}

#pragma mark -- 头像的响应事件
- (void)headBtnClike {
    if ([self.delegate respondsToSelector:@selector(wqHeadBtnClike:)]) {
        [self.delegate wqHeadBtnClike:self];
    }
}

#pragma mark -- 赞的响应事件
- (void)praiseBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqPraiseBtnClick:)]) {
        [self.delegate wqPraiseBtnClick:self];
    }
}

#pragma mark -- 评论的响应事件
- (void)commentsBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqCommentsBtnClick:)]) {
        [self.delegate wqCommentsBtnClick:self];
    }
}

#pragma mark -- WQSecondaryReplyViewDelegate
- (void)wqReplyNumberLabelTap:(WQSecondaryReplyView *)view {
    if ([self.role_id isEqualToString:@"200"]) {
        if ([self.delegate respondsToSelector:@selector(wqVisitorsLogIn:)]) {
            [self.delegate wqVisitorsLogIn:self];
        }
        return;
    }
    WQCommentDetailsViewController *vc = [[WQCommentDetailsViewController alloc] init];
    vc.mid = self.mid;
    vc.model = self.model;
    vc.model.user_name = self.model.user_name;
    if ([self.viewController isKindOfClass:NSClassFromString(@"WQdetailsConrelooerViewController")] || [self.viewController isKindOfClass:NSClassFromString(@"WQorderViewController")]) {
//        vc.type = CommentDetaiTypeNeeds;
//        vc.isnid = YES;
        if ([self.delegate respondsToSelector:@selector(wqtextcClick:)]) {
            [self.delegate wqtextcClick:self];
        }
        return;
    }
    if ([self.viewController isKindOfClass:NSClassFromString(@"WQEssenceDetailController")]) {
        vc.type = CommentDetailTypeEssence;
        if ([_delegate respondsToSelector:@selector(wqJingxuanCommentClick:)]) {
            [_delegate wqJingxuanCommentClick:self];
            return;
        }
        
    }
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)wqTagLabelTap:(WQSecondaryReplyView *)view {
    if ([self.role_id isEqualToString:@"200"]) {
        if ([self.delegate respondsToSelector:@selector(wqVisitorsLogIn:)]) {
            [self.delegate wqVisitorsLogIn:self];
        }
        return;
    }
    WQCommentDetailsViewController *vc = [[WQCommentDetailsViewController alloc] init];
    vc.mid = self.mid;
    vc.model = self.model;
    if ([self.viewController isKindOfClass:NSClassFromString(@"WQdetailsConrelooerViewController")] || [self.viewController isKindOfClass:NSClassFromString(@"WQorderViewController")]) {
//        vc.type = CommentDetaiTypeNeeds;
//        vc.isnid = YES;
        if ([self.delegate respondsToSelector:@selector(wqtextcClick:)]) {
            [self.delegate wqtextcClick:self];
        }
        return;
    }
    if ([self.viewController isKindOfClass:NSClassFromString(@"WQEssenceDetailController")]) {
        vc.type = CommentDetailTypeEssence;
        if ([_delegate respondsToSelector:@selector(wqJingxuanCommentClick:)]) {
            [_delegate wqJingxuanCommentClick:self];
            return;
        }
        
    }
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)wqTwoTagLabelTap:(WQSecondaryReplyView *)view {
    if ([self.role_id isEqualToString:@"200"]) {
        if ([self.delegate respondsToSelector:@selector(wqVisitorsLogIn:)]) {
            [self.delegate wqVisitorsLogIn:self];
        }
        return;
    }
    WQCommentDetailsViewController *vc = [[WQCommentDetailsViewController alloc] init];
    vc.mid = self.mid;
    vc.model = self.model;
    
    if ([self.viewController isKindOfClass:NSClassFromString(@"WQdetailsConrelooerViewController")] || [self.viewController isKindOfClass:NSClassFromString(@"WQorderViewController")]) {
//        vc.type = CommentDetaiTypeNeeds;
//        vc.isnid = YES;
        if ([self.delegate respondsToSelector:@selector(wqtextcClick:)]) {
            [self.delegate wqtextcClick:self];
        }
        return;
    }
    if ([self.viewController isKindOfClass:NSClassFromString(@"WQEssenceDetailController")]) {
        vc.type = CommentDetailTypeEssence;
        if ([_delegate respondsToSelector:@selector(wqJingxuanCommentClick:)]) {
            [_delegate wqJingxuanCommentClick:self];
            return;
        }
    }

    [self.viewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 懒加载
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

// 几度好友的背景颜色
- (UILabel *)aFewDegreesBackgroundLabel {
    if (!_aFewDegreesBackgroundLabel) {
        _aFewDegreesBackgroundLabel = [UILabel labelWithText:@"2度好友" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:9];
        _aFewDegreesBackgroundLabel.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        _aFewDegreesBackgroundLabel.layer.cornerRadius = 2;
        _aFewDegreesBackgroundLabel.layer.masksToBounds = YES;
    }
    return _aFewDegreesBackgroundLabel;
}

// 信用分图标
- (UIImageView *)creditImageView {
    if (!_creditImageView) {
        _creditImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyexinyongfen"]];
    }
    return _creditImageView;
}

// 信用分数
- (UILabel *)creditLabel {
    if (!_creditLabel) {
        _creditLabel = [UILabel labelWithText:@"29分" andTextColor:[UIColor colorWithHex:0x9872ca] andFontSize:9];
    }
    return _creditLabel;
}

@end
