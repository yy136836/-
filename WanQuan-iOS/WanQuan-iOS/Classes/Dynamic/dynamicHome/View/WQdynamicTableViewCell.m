//
//  WQdynamicTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQdynamicTableViewCell.h"
#import "WQdynamicUserInformationView.h"
#import "WQdynamicContentView.h"
#import "WQessenceView.h"
#import "WQdynamicToobarView.h"
#import "WQdynamicHomeModel.h"
#import "WQmoment_statusModel.h"
#import "WQmoment_choicest_articleModel.h"
#import "WQLinksContentView.h"
#import "WQfeedbackViewController.h"

@interface WQdynamicTableViewCell () <WQdynamicUserInformationViewDelegate,WQdynamicToobarViewDelegate>

/**
 精选的view
 */
@property (nonatomic, strong) WQessenceView *essenceView;

/**
 外链的view
 */
@property (nonatomic, strong) WQLinksContentView *linksContentView;

@end

@implementation WQdynamicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        // 栅格化  屏幕滚动时绘制成一张图像
        self.layer.shouldRasterize = YES;
        // 指定分辨率  默认分别率 * 1
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        // 异步绘制  cell 复杂的时候用
//        self.layer.drawsAsynchronously = YES;
    }
    return self;
}

#pragma mark -- 初始化contentView
- (void)setupContentView {
    // 用户信息的view
    WQdynamicUserInformationView *userInformationView = [[WQdynamicUserInformationView alloc] init];
    userInformationView.delegate = self;
    self.userInformationView = userInformationView;
    [self.contentView addSubview:userInformationView];
    [userInformationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.contentView);
        //make.height.offset(65);
    }];
    
    // 动态的view
    WQdynamicContentView *dynamicContentView = [[WQdynamicContentView alloc] init];
    __weak typeof(self) weakSelf = self;
    // 文字的响应事件
    [dynamicContentView setWqContentLabelClickBlock:^{
        if ([weakSelf.delegate respondsToSelector:@selector(wqContentLabelClick:)]) {
            [weakSelf.delegate wqContentLabelClick:weakSelf];
        }
    }];
    
    self.dynamicContentView = dynamicContentView;
    [self.contentView addSubview:dynamicContentView];
    [dynamicContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userInformationView.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    // 精选的view
    WQessenceView *essenceView = [[WQessenceView alloc] init];
    __weak typeof(essenceView) weakeSsenceView = essenceView;
    [essenceView setGroupNameClickBlock:^{
        if ([self.delegate respondsToSelector:@selector(wqGroupNameClick:cell:)]) {
            [self.delegate wqGroupNameClick:weakeSsenceView cell:self];
        }
    }];
    
    self.essenceView = essenceView;
    [self.contentView addSubview:essenceView];
    [essenceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dynamicContentView.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    // 外链的view
    WQLinksContentView *linksContentView = [[WQLinksContentView alloc] init];
    self.linksContentView = linksContentView;
    linksContentView.layer.borderWidth = 1.0f;
    linksContentView.layer.borderColor = [UIColor colorWithHex:0xeeeeee].CGColor;
    linksContentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *linksContentViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(linksContentViewClick)];
    [linksContentView addGestureRecognizer:linksContentViewTap];
    linksContentView.isWanquanHome = YES;
    [self.contentView addSubview:linksContentView];
    [linksContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kScaleY(ghSpacingOfshiwu));
        make.right.equalTo(self.contentView).offset(kScaleY(-ghSpacingOfshiwu));
        make.top.equalTo(essenceView.mas_bottom).offset(ghStatusCellMargin);
        make.height.offset(60);
    }];
    
    // 底部栏
    WQdynamicToobarView *toobarView = [[WQdynamicToobarView alloc] init];
    toobarView.delegate = self;
    self.toobarView = toobarView;
    [self.contentView addSubview:toobarView];
    [toobarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linksContentView.mas_bottom);
        make.height.offset(60);
        make.bottom.left.right.equalTo(self.contentView);
    }];
}

- (void)setModel:(WQdynamicHomeModel *)model {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];

    _model = model;
    self.toobarView.type = model.moment_type;
    
    [self.userInformationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.contentView);
    }];
    
    // 万圈状态
    if ([model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        // 隐藏右上角的图片
        self.userInformationView.essenceImageView.hidden = YES;
        // 隐藏右上角的关注按钮
        self.userInformationView.guanzhuBtn.hidden = YES;
        // 隐藏精选的view
        self.essenceView.hidden = YES;
        // 显示动态的view
        self.dynamicContentView.hidden = NO;

        // 头像
        [self.userInformationView.user_picImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.moment_status.user_pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
        // 姓名
        self.userInformationView.nameLabel.text = model.moment_status.user_name;
        // 信用分
        self.userInformationView.creditLabel.text = [model.moment_status.user_creditscore stringByAppendingString:@"分"];
        // 标签
        if (model.moment_status.user_tag.count == 0) {
            self.userInformationView.user_tagLabel.text = @"";
        }else if (model.moment_status.user_tag.count == 1) {
            self.userInformationView.user_tagLabel.text = model.moment_status.user_tag.firstObject;
        }else if (model.moment_status.user_tag.count == 2) {
            self.userInformationView.user_tagLabel.text = [[model.moment_status.user_tag.firstObject stringByAppendingString:@"  "] stringByAppendingString:model.moment_status.user_tag.lastObject];
        }
        // 几度好友
        self.userInformationView.aFewDegreesBackgroundLabel.text = [WQTool friendship:[model.moment_status.user_degree integerValue]];
        // 赞的数量
        if ([model.moment_status.like_count integerValue] == 0) {
            // 赞的数量为O时  显示赞
            [self.toobarView.praiseBtn setTitle:@" 赞" forState:UIControlStateNormal];
        }else {
            [self.toobarView.praiseBtn setTitle:[@"   " stringByAppendingString:model.moment_status.like_count] forState:UIControlStateNormal];
        }
        // 评论的数量
        if ([model.moment_status.comment_count integerValue] == 0) {
            // 评论的数量为O时  显示评论
            [self.toobarView.commentsBtn setTitle:@" 评论" forState:UIControlStateNormal];
        }else {
            [self.toobarView.commentsBtn setTitle:[@" " stringByAppendingString:model.moment_status.comment_count] forState:UIControlStateNormal];
        }
        // 踩的数量
        if (model.moment_status.dislike_count == 0) {
            // 没有踩
            [self.toobarView.caiBtn setTitle:@"  踩" forState:UIControlStateNormal];
        }else {
            // 有踩
            [self.toobarView.caiBtn setTitle:[NSString stringWithFormat:@"  %d",model.moment_status.dislike_count] forState:UIControlStateNormal];
        }
        
        self.userInformationView.aFewDegreesBackgroundLabel.text =  [WQTool friendship:[model.moment_status.user_degree integerValue]];

        self.dynamicContentView.model = model.moment_status;
        
        
        
        
        
    } else if ([model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        // 显示右上角的图片
        self.userInformationView.essenceImageView.hidden = NO;
        // 显示右上角的关注按钮
        self.userInformationView.guanzhuBtn.hidden = NO;
        // 隐藏精选的view
        self.essenceView.hidden = NO;
        // 隐藏动态的view
        self.dynamicContentView.hidden = YES;
        // 来自圈子
        self.essenceView.group_name = model.moment_choicest_article.article_group_name;
        // 头像
        [self.userInformationView.user_picImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.moment_choicest_article.user_pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
        // 姓名
        self.userInformationView.nameLabel.text = model.moment_choicest_article.user_name;
        // 信用分
        self.userInformationView.creditLabel.text = [model.moment_choicest_article.user_creditscore stringByAppendingString:@"分"];
        if (model.moment_choicest_article.user_tag.count == 0) {
            self.userInformationView.user_tagLabel.text = @"";
        }else if (model.moment_choicest_article.user_tag.count == 1) {
            // 标签
            self.userInformationView.user_tagLabel.text = model.moment_choicest_article.user_tag.firstObject;
        }else if (model.moment_choicest_article.user_tag.count == 2) {
            // 标签
            self.userInformationView.user_tagLabel.text = [[model.moment_choicest_article.user_tag.firstObject stringByAppendingString:@"  "] stringByAppendingString:model.moment_choicest_article.user_tag.lastObject];
        }
        // 几度好友
        self.userInformationView.aFewDegreesBackgroundLabel.text =  [WQTool friendship:[model.moment_status.user_degree integerValue]];
;
        // 二度以内好友不显示关注按钮
        if ([model.moment_choicest_article.user_degree integerValue] <= 2) {
            self.userInformationView.guanzhuBtn.hidden = YES;
        }else {
            self.userInformationView.guanzhuBtn.hidden = NO;
        }
        
        // 赞的数量
        if ([model.moment_choicest_article.like_count integerValue] == 0) {
            // 赞的数量为O时  显示赞
            [self.toobarView.praiseBtn setTitle:@" 赞" forState:UIControlStateNormal];
        }else {
            [self.toobarView.praiseBtn setTitle:[@"   " stringByAppendingString:model.moment_choicest_article.like_count] forState:UIControlStateNormal];
        }
        
        // 评论的数量
        if (model.moment_choicest_article.comment_count == 0) {
            // 评论的数量为O时  显示评论
            [self.toobarView.commentsBtn setTitle:@" 评论" forState:UIControlStateNormal];
        }else {
            [self.toobarView.commentsBtn setTitle:[@" " stringByAppendingString:[NSString stringWithFormat:@"%d",model.moment_choicest_article.comment_count]] forState:UIControlStateNormal];
        }
        
        // 是否已关注
        if (model.moment_choicest_article.user_followed) {
            self.userInformationView.guanzhuBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
            [self.userInformationView.guanzhuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.userInformationView.guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
        }else {
            self.userInformationView.guanzhuBtn.backgroundColor = [UIColor whiteColor];
            [self.userInformationView.guanzhuBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
            [self.userInformationView.guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
        }

        self.essenceView.model = model.moment_choicest_article;
    }
    
    // 万圈状态
    if ([model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        self.userInformationView.tagArray = model.moment_status.user_tag;
    } else if ([model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        // 精选状态
        self.userInformationView.tagArray = model.moment_choicest_article.user_tag;
    }

    // 万圈状态
    if ([model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        // 是否可以赞
        if (!model.moment_status.can_like) {
            // 不是自己发的
            if (![model.moment_status.user_id isEqualToString:im_namelogin]) {
                [self.toobarView.praiseBtn setImage:[UIImage imageNamed:@"dynamicyidianzan"] forState:UIControlStateNormal];
                [self.toobarView.praiseBtn setTitleColor:[UIColor colorWithHex:0xee9b11] forState:UIControlStateNormal];
            }else {
                [self.toobarView.praiseBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
                [self.toobarView.praiseBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
            }
        }else {
            [self.toobarView.praiseBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
            [self.toobarView.praiseBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        }
        // 没有外链
        if ([model.moment_status.link_url isEqualToString:@""]) {
            // 隐藏外链的view
            self.linksContentView.hidden = YES;
            [self.linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            [self.dynamicContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.userInformationView.mas_bottom);
                make.left.right.equalTo(self.contentView);
            }];
            [self.essenceView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
                make.top.equalTo(self.dynamicContentView.mas_bottom);
                make.left.right.equalTo(self.contentView);
            }];
            [self.toobarView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.essenceView.mas_bottom);
                make.height.offset(60);
                make.bottom.left.right.equalTo(self.contentView);
            }];
        }else {
            // 显示外链的view
            self.linksContentView.hidden = NO;

            if ([model.moment_status.link_img isEqualToString:@""]) {
                self.linksContentView.linksImage.image = [UIImage imageNamed:@"lianjie占位图"];
            }else {
                [self.linksContentView.linksImage yy_setImageWithURL:[NSURL URLWithString:model.moment_status.link_img] placeholder:[UIImage imageNamed:@"lianjie占位图"]];
            }
            [self.linksContentView.linksLabel setText:model.moment_status.link_txt];

            [self.dynamicContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.userInformationView.mas_bottom);
                make.left.right.equalTo(self.contentView);
            }];
            [self.essenceView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
                make.top.equalTo(self.dynamicContentView.mas_bottom);
                make.left.right.equalTo(self.contentView);
            }];
            [self.linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kScaleY(ghSpacingOfshiwu));
                make.right.equalTo(self.contentView).offset(kScaleY(-ghSpacingOfshiwu));
                make.top.equalTo(self.essenceView.mas_bottom).offset(ghStatusCellMargin);
                make.height.offset(60);
            }];
            [self.toobarView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.linksContentView.mas_bottom);
                make.height.offset(60);
                make.bottom.left.right.equalTo(self.contentView);
            }];
        }
    }
    
    
    
    
    if ([model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        // 是否可以赞
        if (!model.moment_choicest_article.can_like) {
            // 不是自己发的
            if (![model.moment_choicest_article.user_id isEqualToString:im_namelogin]) {
                [self.toobarView.praiseBtn setImage:[UIImage imageNamed:@"dynamicyidianzan"] forState:UIControlStateNormal];
                [self.toobarView.praiseBtn setTitleColor:[UIColor colorWithHex:0xee9b11] forState:UIControlStateNormal];
            }else {
                [self.toobarView.praiseBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
                [self.toobarView.praiseBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
            }
        }else {
            [self.toobarView.praiseBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
            [self.toobarView.praiseBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        }
        
        // 隐藏外链的view
        self.linksContentView.hidden = YES;
        [self.linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [self.dynamicContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.userInformationView.mas_bottom);
        }];
        [self.essenceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dynamicContentView.mas_bottom);
            make.left.right.equalTo(self.contentView);
        }];
        [self.toobarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.essenceView.mas_bottom).offset(3);
            make.height.offset(60);
            make.bottom.left.right.equalTo(self.contentView);
        }];
    }
}

#pragma makr -- 外链的响应事件
- (void)linksContentViewClick {
    if ([self.delegate respondsToSelector:@selector(wqLinksContentViewClick:cell:)]) {
        [self.delegate wqLinksContentViewClick:self.linksContentView cell:self];
    }
}

#pragma mark -- ViewDelegate
- (void)wqUser_picImageViewClick:(WQdynamicUserInformationView *)dynamicUserInformationView {
    // 头像的响应事件
    if ([self.delegate respondsToSelector:@selector(wqUser_picImageViewClick:)]) {
        [self.delegate wqUser_picImageViewClick:self];
    }
}

- (void)wqSharBtnClick:(WQdynamicToobarView *)toobarView {
    // 分享的响应事件
    if ([self.delegate respondsToSelector:@selector(wqSharBtnClick:cell:)]) {
        [self.delegate wqSharBtnClick:toobarView cell:self];
    }
}

- (void)wqCommentsBtnClick:(WQdynamicToobarView *)toobarView {
    // 评论的响应事件
    if ([self.delegate respondsToSelector:@selector(wqCommentsBtnClick:cell:)]) {
        [self.delegate wqCommentsBtnClick:toobarView cell:self];
    }
}

- (void)wqPraiseBtnClick:(WQdynamicToobarView *)toobarView {
    // 赞的响应事件
    if ([self.delegate respondsToSelector:@selector(wqPraiseBtnClick:cell:)]) {
        [self.delegate wqPraiseBtnClick:toobarView cell:self];
    }
}

- (void)wqGuanzhuBtnClick:(WQdynamicUserInformationView *)dynamicUserInformationView {
    // 关注按钮的响应事件
    if ([self.delegate respondsToSelector:@selector(wqGuanzhuBtnClick:)]) {
        [self.delegate wqGuanzhuBtnClick:self];
    }
}

- (void)wqEencourageBtnClick:(WQdynamicToobarView *)toobarView {
    // 鼓励的响应事件
    if ([self.delegate respondsToSelector:@selector(wqEencourageBtnClick:cell:)]) {
        [self.delegate wqEencourageBtnClick:toobarView cell:self];
    }
}

- (void)wqReportBtnClick:(WQdynamicToobarView *)toobarView {
    // 举报的响应事件
    // 万圈状态
    WQfeedbackViewController *vc = [[WQfeedbackViewController alloc] init];
    if ([_model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        vc.feedbackType = TYPE_MOMENT;
    } if ([_model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        // 精选状态
        vc.feedbackType = TYPE_CHOICEST_ARTICLE;
    }
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)wqCaiBtnClick:(WQdynamicToobarView *)toobarView {
    // 踩的响应事件
    if ([self.delegate respondsToSelector:@selector(wqCaiBtnClick:cell:)]) {
        [self.delegate wqCaiBtnClick:toobarView cell:self];
    }
}


- (void)wqBtnsClick:(WQdynamicToobarView *)toobarView {
    
    if ([self.delegate respondsToSelector:@selector(wqBtnsClick:cell:)]) {
        [self.delegate wqBtnsClick:toobarView cell:self];
    }
}

@end
