//
//  WQCommentDetailsTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/15.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQCommentDetailsTableViewCell.h"
#import "WQDynamicLevelSecondaryModel.h"
#import "WQUserProfileController.h"

@interface WQCommentDetailsTableViewCell ()

/**
 头像
 */
@property (strong, nonatomic) UIImageView *user_pic;

/**
 用户名
 */
@property (strong, nonatomic) UILabel *user_name;

/**
 时间
 */
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation WQCommentDetailsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
        [self setupContentView];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark -- 初始化setupContentView
- (void)setupContentView {
    // 头像
    self.user_pic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    self.user_pic.contentMode = UIViewContentModeScaleAspectFill;
    self.user_pic.layer.cornerRadius = 15;
    self.user_pic.layer.masksToBounds = YES;
    self.user_pic.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headBtnClike)];
    [self.user_pic addGestureRecognizer:tap];
    [self.contentView addSubview:self.user_pic];
    [self.user_pic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.equalTo(self.contentView).offset(ghSpacingOfshiwu);
        make.top.equalTo(self.contentView).offset(ghStatusCellMargin);
    }];
    
    // 姓名
    self.user_name = [UILabel labelWithText:@"陈亮" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:12];
    [self.contentView addSubview:self.user_name];
    [self.user_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(11);
        make.left.equalTo(self.user_pic.mas_right).offset(ghStatusCellMargin);
    }];
    
    // 时间
    UILabel *timeLabel = [UILabel labelWithText:@"2分钟前" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:10];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.user_name.mas_left);
        make.top.equalTo(self.user_name.mas_bottom).offset(3);
    }];
    
    // 内容
    self.contentLabel = [UILabel labelWithText:@"这是内容呀!" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:15];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.user_name.mas_left);
        make.top.equalTo(timeLabel.mas_bottom).offset(ghStatusCellMargin);
        make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
    }];
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xdddddd];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(ghStatusCellMargin);
        make.left.equalTo(self.user_name);
        make.height.offset(0.5);
        make.bottom.right.equalTo(self.contentView);
    }];
    
    // 赞
    UIButton *praiseBtn = [[UIButton alloc] init];
    self.praiseBtn = praiseBtn;
    praiseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [praiseBtn addTarget:self action:@selector(praiseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [praiseBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
    [praiseBtn setTitle:@" 赞" forState:UIControlStateNormal];
    [praiseBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [self.contentView addSubview:praiseBtn];
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(ghStatusCellMargin);
        make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
    }];
}

- (void)setModel:(WQDynamicLevelSecondaryModel *)model {
    _model = model;
    // 头像
    [self.user_pic yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_MIDDLE_URLSTRING(model.user_pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    // 姓名
    self.user_name.text = model.user_name;
    // 已过时间
    NSInteger time = [model.past_second integerValue];
    if (time < 60) {
        self.timeLabel.text = [NSString stringWithFormat:@"刚刚"];
    }else if (time < 3600) {
        self.timeLabel.text = [NSString stringWithFormat:@"%zd 分钟前",time / 60];
    }else if (time / (60 * 60 * 24) >= 1) {
        self.timeLabel.text = [NSString stringWithFormat:@"%zd 天前",time / (60 * 60 * 24)];
    }else{
        self.timeLabel.text = [NSString stringWithFormat:@"%zd 小时前",time / 3600];
    }
    // 内容
    if (model.reply_user_name.length) {
        NSString *originalName = [@"@" stringByAppendingString:[model.reply_user_name stringByAppendingString:@": "]];
        NSString *nameAddcontent = [originalName stringByAppendingString:model.content];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:nameAddcontent];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x9767d0] range:NSMakeRange(0, originalName.length)];
        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, nameAddcontent.length)];
        self.contentLabel.attributedText = text;
    }else {
        self.contentLabel.text = model.content;
    }
    // 是否有赞
    if (model.like_count >= 1) {
        [self.praiseBtn setTitle:[NSString stringWithFormat:@"   %d",model.like_count] forState:UIControlStateNormal];
    }else {
        [self.praiseBtn setTitle:[NSString stringWithFormat:@" 赞"] forState:UIControlStateNormal];
    }
    
    // 是否赞过
    if (model.isLiked) {
        [self.praiseBtn setTitleColor:[UIColor colorWithHex:0xee9b11] forState:UIControlStateNormal];
        [self.praiseBtn setImage:[UIImage imageNamed:@"dynamicyidianzan"] forState:UIControlStateNormal];
    }else {
        [self.praiseBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        [self.praiseBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
    }
}

#pragma mark -- 头像的响应事件
- (void)headBtnClike {
    if (self.headBtnClikeBlock) {
        self.headBtnClikeBlock();
    }
}

#pragma mark -- 赞的响应事件
- (void)praiseBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqPraiseBtnClick:)]) {
        [self.delegate wqPraiseBtnClick:self];
    }
}

@end
