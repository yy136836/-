//
//  WQGroupDynamicTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupDynamicTableViewCell.h"
#import "WQWQGroupUserInformationView.h"
#import "WQGroupContentView.h"
#import "WQGroupDynamicHomeModel.h"
#import "WQForwardingNeedsView.h"
#import "WQThemeImageView.h"
#import "WQThemeImageCollectionViewCell.h"
#import "WQLinksContentView.h"
#import "WQGroupDynamicActlvltyView.h"

@interface WQGroupDynamicTableViewCell () <WQWQGroupUserInformationViewDelegate>

@property (nonatomic, strong) WQWQGroupUserInformationView *userInformationView;;
// 转发
@property (nonatomic, strong) WQForwardingNeedsView *forwardingNeedsView;
// 底部的分隔线
@property (nonatomic, strong) UIView *bottomLineView;
// 内容
@property (nonatomic, strong) WQGroupContentView *groupContentView;

/**
 活动
 */
@property (nonatomic, strong) WQGroupDynamicActlvltyView *actlvltyView;

@end

@implementation WQGroupDynamicTableViewCell {
    WQLinksContentView *linksContentView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        // 栅8格化
        // 屏幕滚动时绘制成一张图像
        self.layer.shouldRasterize = YES;
        // 指定分辨率  默认分别率 * 1
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        // 异步绘制  cell 复杂的时候用
        self.layer.drawsAsynchronously = YES;
    }
    return self;
}

#pragma mark -- 初始化contentView
- (void)setupContentView {    
    // 用户信息抽出来的view
    WQWQGroupUserInformationView *userInformationView = [[WQWQGroupUserInformationView alloc] init];
    userInformationView.delegate = self;
    self.userInformationView = userInformationView;
    [self.contentView addSubview:userInformationView];
    [userInformationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        //make.height.offset(60);
    }];
    
    // 内容
    WQGroupContentView *groupContentView = [[WQGroupContentView alloc] init];
    self.groupContentView = groupContentView;
    [self.contentView addSubview:groupContentView];
    [groupContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userInformationView.mas_bottom).offset(12);
        make.left.right.equalTo(self.contentView);
    }];
    
    // 转发需求
    WQForwardingNeedsView *forwardingNeedsView = [[WQForwardingNeedsView alloc] init];
    self.forwardingNeedsView = forwardingNeedsView;
    [self.contentView addSubview:forwardingNeedsView];
    [forwardingNeedsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(groupContentView.mas_bottom).offset(-5);
        make.left.equalTo(groupContentView.mas_left).offset(ghStatusCellMargin);
        make.right.equalTo(groupContentView.mas_right).offset(-ghStatusCellMargin);
    }];
    
    // 图片
    WQThemeImageView *picView = [[WQThemeImageView alloc] init];
    self.picView = picView;
    [self.contentView addSubview:picView];
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forwardingNeedsView.mas_bottom);
        make.left.equalTo(groupContentView.mas_left);
        make.height.offset(kScaleY(0));
    }];
    
    WQGroupDynamicActlvltyView *actlvltyView = [[WQGroupDynamicActlvltyView alloc] init];
    self.actlvltyView = actlvltyView;
    actlvltyView.userInteractionEnabled = YES;
    UITapGestureRecognizer *actlvltyViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actlvltyViewClick:)];
    [actlvltyView addGestureRecognizer:actlvltyViewTap];
    [self.contentView addSubview:actlvltyView];
    [actlvltyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(groupContentView);
        make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
        make.top.equalTo(picView.mas_bottom).offset(ghSpacingOfshiwu);
    }];
    
    linksContentView = [[WQLinksContentView alloc] init];
    linksContentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *linksContentViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(linksContentViewClick:)];
    [linksContentView addGestureRecognizer:linksContentViewTap];
    linksContentView.isWanquanHome = YES;
    [self.contentView addSubview:linksContentView];
    
    [linksContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
//        make.top.equalTo(picView.mas_bottom).offset(ghSpacingOfshiwu);
        make.top.equalTo(actlvltyView.mas_bottom).offset(ghSpacingOfshiwu);
        make.height.offset(60);
    }];
    
    // 底部的分隔线
    UIView *bottomLineView = [[UIView alloc] init];
    self.bottomLineView = bottomLineView;
    bottomLineView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linksContentView.mas_bottom).offset(ghSpacingOfshiwu);
        make.right.left.bottom.equalTo(self.contentView);
        make.height.offset(ghStatusCellMargin);
    }];
}

- (void)setModel:(WQGroupDynamicHomeModel *)model {
    _model = model;
    // 用户头像
    [self.userInformationView.HeadPortraitImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    // 用户名
    self.userInformationView.userLabel.text = model.user_name;
    // 发布时间
    self.userInformationView.timeLbale.text = model.createtime;
    // 主题
/***************话题****************/
    if ([model.type isEqualToString:@"TYPE_TOPIC"]) {
        self.userInformationView.isActlvlty = NO;
        self.userInformationView.type = @"主题";
        self.groupContentView.type = @"主题";
        self.groupContentView.height = NO;
        self.userInformationView.timeLbale.hidden = NO;
        // 取消隐藏内容view的Content
        self.groupContentView.contentLabel.hidden = NO;
        // 主题不显示紫色的条
        self.userInformationView.articlePurpleView.hidden = YES;
        // 防止复用
        self.userInformationView.tagOncLabel.hidden = YES;
        self.userInformationView.tagTwoLabel.hidden = YES;
        self.userInformationView.moneyLabel.hidden = YES;
        self.userInformationView.distanceLabel.hidden = YES;
        self.userInformationView.stopTimeImageView.hidden = YES;
        self.userInformationView.distanceImageView.hidden = YES;
        self.userInformationView.stopTimeLabel.hidden = YES;
        self.userInformationView.hongbaoImageView.hidden = YES;
        self.userInformationView.creditBackgroundView.hidden = NO;
        self.userInformationView.creditImageView.hidden = NO;
        self.userInformationView.creditLabel.hidden = NO;
        self.userInformationView.aFewDegreesBackgroundLabel.hidden = NO;
        self.actlvltyView.titleLabel.hidden = YES;
        self.actlvltyView.addrLabel.hidden = YES;
        self.actlvltyView.timeLabel.hidden = YES;
        self.actlvltyView.actlvltyImageView.hidden = YES;
        self.groupContentView.titleLabel.hidden = NO;
        // 如果是主题的话标题显示一行
        self.groupContentView.titleLabel.numberOfLines = 1;
        // 让个人信息的view高度为60
        [self.userInformationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self.contentView);
//            make.height.offset(60);
        }];
        [self.actlvltyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        // 隐藏转发需求的view
        self.forwardingNeedsView.hidden = YES;
        [self.groupContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userInformationView.mas_bottom).offset(ghSpacingOfshiwu);
            make.left.right.equalTo(self.userInformationView);
        }];
        
        // 判断有没有图片
        if (model.pic.count >= 1) {
            // 有图片
            [self.picView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.groupContentView.mas_bottom);
                make.left.equalTo(self.groupContentView.mas_left);
                make.right.equalTo(self.groupContentView.mas_right);
                make.height.offset(kScaleY(90));
            }];
            // 赋值图片
            self.picView.pic = model.pic;
            
            // 判断是否有链接
            if ([model.link_url isEqualToString:@""]) {
                linksContentView.hidden = YES;
                // 没有链接
                [linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                }];
                // 让底部的线的top等于图片的底部
                [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.picView.mas_bottom).offset(ghSpacingOfshiwu);
                    make.right.left.bottom.equalTo(self.contentView);
                    make.height.offset(ghStatusCellMargin);
                }];
            }else {
                linksContentView.hidden = NO;
                // 有链接
                [linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView).offset(ghSpacingOfshiwu);
                    make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
                    make.top.equalTo(self.picView.mas_bottom).offset(ghSpacingOfshiwu);
                    make.height.offset(60);
                }];
                // 让底部的线的top等于外链的底部
                [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(linksContentView.mas_bottom).offset(ghSpacingOfshiwu);
                    make.right.left.bottom.equalTo(self.contentView);
                    make.height.offset(ghStatusCellMargin);
                }];
            }
        }else {
            [self.picView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            self.picView.picArray = model.pic;
            
            // 判断是否有链接
            if ([model.link_url isEqualToString:@""]) {
                linksContentView.hidden = YES;
                // 没有链接
                [linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                }];
                // 让底部的线的top等于内容的底部
                [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.groupContentView.mas_bottom).offset(ghSpacingOfshiwu);
                    make.right.left.bottom.equalTo(self.contentView);
                    make.height.offset(ghStatusCellMargin);
                }];
            }else {
                linksContentView.hidden = NO;
                // 有链接  让链接的顶部等于内容的底部
                [linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView).offset(ghSpacingOfshiwu);
                    make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
                    make.top.equalTo(self.groupContentView.mas_bottom).offset(ghSpacingOfshiwu);
                    make.height.offset(60);
                }];
                
                // 让底部的线的top等于外链的底部
                [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(linksContentView.mas_bottom).offset(ghSpacingOfshiwu);
                    make.right.left.bottom.equalTo(self.contentView);
                    make.height.offset(ghStatusCellMargin);
                }];
            }
            
        }
        
        if ([model.link_img isEqualToString:@""]) {
            linksContentView.linksImage.image = [UIImage imageNamed:@"lianjie占位图"];
        }else {
            [linksContentView.linksImage yy_setImageWithURL:[NSURL URLWithString:model.link_img] placeholder:[UIImage imageNamed:@"lianjie占位图"]];
        }
        linksContentView.linksLabel.text = model.link_txt;
        
        // 评论数量
        self.userInformationView.replyBtn.hidden = NO;
        [self.userInformationView.replyBtn setTitle:[@" " stringByAppendingString:model.post_count] forState:UIControlStateNormal];
        // 主题标题
        self.groupContentView.titleLabel.text = model.subject;
        // 主题内容
        self.groupContentView.contentLabel.attributedText = [self getAttributedStringWithString:model.content lineSpace:3];
        // 几度好友
        self.userInformationView.aFewDegreesBackgroundLabel.text = [WQTool friendship:[model.user_degree integerValue]];
        // 信用分数
        self.userInformationView.creditLabel.text = [model.user_creditscore stringByAppendingString:@"分"];
/******************活动*********************/
    }else if ([model.type isEqualToString:@"TYPE_ACTIVITY"]) {
        self.userInformationView.isActlvlty = YES;
        self.userInformationView.type = @"活动";
        // 活动
        self.actlvltyView.titleLabel.hidden = NO;
        self.actlvltyView.addrLabel.hidden = NO;
        self.actlvltyView.timeLabel.hidden = NO;
        self.userInformationView.creditBackgroundView.hidden = NO;
        self.userInformationView.creditImageView.hidden = NO;
        self.userInformationView.creditLabel.hidden = NO;
        self.userInformationView.aFewDegreesBackgroundLabel.hidden = NO;
        self.actlvltyView.actlvltyImageView.hidden = NO;
        self.userInformationView.tagOncLabel.hidden = YES;
        self.userInformationView.tagTwoLabel.hidden = YES;
        self.userInformationView.moneyLabel.hidden = YES;
        self.userInformationView.distanceLabel.hidden = YES;
        self.userInformationView.stopTimeImageView.hidden = YES;
        self.userInformationView.distanceImageView.hidden = YES;
        self.userInformationView.stopTimeLabel.hidden = YES;
        self.userInformationView.hongbaoImageView.hidden = YES;
        self.groupContentView.titleLabel.hidden = YES;
        linksContentView.hidden = YES;
        // 没有链接
        [linksContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [self.picView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        
        self.actlvltyView.titleLabel.text = model.title;
        self.actlvltyView.addrLabel.text = [@"地点: " stringByAppendingString:model.addr];
        self.actlvltyView.timeLabel.text = [@"时间: " stringByAppendingString:model.time];
        [self.actlvltyView.actlvltyImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_HUGE_URLSTRING(model.cover_pic_id)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
        // 几度好友
        self.userInformationView.aFewDegreesBackgroundLabel.text = [WQTool friendship:[model.user_degree integerValue]];;
        // 信用分数
        self.userInformationView.creditLabel.text = [model.user_creditscore stringByAppendingString:@"分"];
//        [self.actlvltyView.actlvltyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.offset((kScreenWidth - 30) * ([model.cover_pic_height doubleValue] / [model.cover_pic_width doubleValue]));
//        }];
        [self.userInformationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self.contentView);
            make.height.offset(60);
        }];
        [self.actlvltyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userInformationView);
            make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
            make.top.equalTo(self.userInformationView.mas_bottom).offset(ghSpacingOfshiwu);
        }];
        [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.actlvltyView.mas_bottom).offset(ghSpacingOfshiwu);
            make.right.left.bottom.equalTo(self.contentView);
            make.height.offset(ghStatusCellMargin);
        }];
    }else {
/*************************需求*******************/
        [self.actlvltyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        self.userInformationView.isActlvlty = NO;
        // 需求显示紫色的条
        self.userInformationView.articlePurpleView.hidden = NO;
        // 需求是否转发
        if (model.isFw) {//转发的
            // 转发的需求显发布时间
            self.userInformationView.timeLbale.text = model.createtime;
            // 是转发的需求标题显示完
            self.groupContentView.titleLabel.numberOfLines = 0;
            self.userInformationView.type = @"转发需求";
            self.groupContentView.type = @"转发需求";
            //self.groupContentView.height = YES;
            // 取消隐藏内容view的Content
            self.groupContentView.contentLabel.hidden = YES;
            // 转发的view
            self.forwardingNeedsView.hidden = NO;
            // name
            self.userInformationView.userLabel.text = model.need_user_name;
            // 内容
            self.groupContentView.contentLabel.text = model.need_content;
            // 头像
            NSString *imageUrl = [imageUrlString stringByAppendingString:model.user_pic];
            [self.userInformationView.HeadPortraitImageView yy_setImageWithURL:[NSURL URLWithString:imageUrl] options:YYWebImageOptionShowNetworkActivity];
            // name
            self.userInformationView.userLabel.text = model.user_name;
            // 内容
            self.groupContentView.contentLabel.text = model.need_content;
            [self.userInformationView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.contentView);
                make.height.offset(80);
                //make.height.offset(60);

            }];
            [self.groupContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.userInformationView.mas_bottom);
                make.left.right.equalTo(self.userInformationView);
            }];
            // 防止复用把图片高设为0
            [self.picView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            // 更新底部的线,让他等于转发view的底部
            [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.forwardingNeedsView.mas_bottom).offset(ghSpacingOfshiwu);
                make.right.left.bottom.equalTo(self.contentView);
                make.height.offset(ghStatusCellMargin);
            }];
            self.userInformationView.timeLbale.hidden = NO;
            // 转发的附加信息
            self.groupContentView.titleLabel.text = model.fw_content;
            // 原创需求人姓名
            self.forwardingNeedsView.userNameLabel.text = [@"@ " stringByAppendingString:model.need_user_name];
            // 原创需求的金额
            self.forwardingNeedsView.moneyLabel.text = [@"¥ " stringByAppendingString:model.need_money];
            // 原创需求的标题
            self.forwardingNeedsView.titleLabel.text = model.need_subject;
            // 原创需求的内容
            self.forwardingNeedsView.contentLabel.text = model.need_content;
            // 评论数量
            self.userInformationView.replyBtn.hidden = NO;
            [self.userInformationView.replyBtn setTitle:[@" " stringByAppendingString:model.post_count] forState:UIControlStateNormal];
            // 几度好友
            self.userInformationView.aFewDegreesBackgroundLabel.text = [WQTool friendship:[model.user_degree integerValue]];
            // 信用分数
            self.userInformationView.creditLabel.text = [model.user_creditscore stringByAppendingString:@"分"];
            // 防止复用
            self.userInformationView.tagOncLabel.hidden = YES;
            self.userInformationView.tagTwoLabel.hidden = YES;
            self.userInformationView.moneyLabel.hidden = YES;
            self.userInformationView.distanceLabel.hidden = YES;
            self.userInformationView.stopTimeImageView.hidden = YES;
            self.userInformationView.distanceImageView.hidden = YES;
            self.userInformationView.stopTimeLabel.hidden = YES;
            self.userInformationView.hongbaoImageView.hidden = YES;
            linksContentView.hidden = YES;
            self.userInformationView.creditBackgroundView.hidden = NO;
            self.userInformationView.creditImageView.hidden = NO;
            self.userInformationView.creditLabel.hidden = NO;
            self.userInformationView.aFewDegreesBackgroundLabel.hidden = NO;
            self.actlvltyView.titleLabel.hidden = YES;
            self.actlvltyView.addrLabel.hidden = YES;
            self.actlvltyView.timeLabel.hidden = YES;
            self.actlvltyView.actlvltyImageView.hidden = YES;
            self.groupContentView.titleLabel.hidden = NO;
            
            // 如果是bbs显示红包不显示金额
            if ([model.need_category_level_1 isEqualToString:@"BBS"]) {
                self.forwardingNeedsView.moneyLabel.hidden = YES;
                self.forwardingNeedsView.forwarDingHongbao.hidden = NO;
            }else {
                self.forwardingNeedsView.moneyLabel.hidden = NO;
                self.forwardingNeedsView.forwarDingHongbao.hidden = YES;
            }
            
        }else {//不是转发的
            // 不是转发的需求标题显示一行
            self.groupContentView.titleLabel.numberOfLines = 1;
            // 转发需求隐藏内容view的Content
            self.groupContentView.contentLabel.hidden = NO;
            // 转发的需求显发布时间
            self.userInformationView.timeLbale.text = model.createtime;
            self.userInformationView.type = @"需求";
            self.groupContentView.type = @"需求";
            self.groupContentView.height = NO;

            [self.userInformationView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.contentView);
                make.height.offset(80);
            }];
            // 转发的需求的view
            self.forwardingNeedsView.hidden = YES;
            [self.groupContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.userInformationView.mas_bottom);
                make.left.right.equalTo(self.userInformationView);
            }];
            // 防止复用把图片高设为0
            [self.picView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            // 然底部的线等于原创需求的底部
            [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.groupContentView.mas_bottom).offset(ghSpacingOfshiwu);
                make.right.left.bottom.equalTo(self.contentView);
                make.height.offset(ghStatusCellMargin);
            }];
            // 评论数量
            self.userInformationView.replyBtn.hidden = YES;
            // 防止复用
            self.userInformationView.timeLbale.hidden = YES;
            self.actlvltyView.titleLabel.hidden = YES;
            self.actlvltyView.addrLabel.hidden = YES;
            self.actlvltyView.timeLabel.hidden = YES;
            self.actlvltyView.actlvltyImageView.hidden = YES;
            self.groupContentView.titleLabel.hidden = NO;
            // 标签
            // 是否匿名
            if (model.need_truename) {
                switch (model.user_tag.count) {
                    case 1:{
                        self.userInformationView.tagOncLabel.hidden = NO;
                        self.userInformationView.tagOncLabel.text = model.user_tag.firstObject;
                        self.userInformationView.tagTwoLabel.hidden = YES;
                        
                        [self.userInformationView.stopTimeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.userInformationView.tagOncLabel.mas_left);
                            make.top.equalTo(self.userInformationView.tagOncLabel.mas_bottom).offset(5);
                        }];
                    }
                        break;
                    case 2:{
                        self.userInformationView.tagOncLabel.hidden = NO;
                        self.userInformationView.tagTwoLabel.hidden = NO;
                        self.userInformationView.tagOncLabel.text = model.user_tag.firstObject;
                        self.userInformationView.tagTwoLabel.text = model.user_tag.lastObject;
                        
                        [self.userInformationView.stopTimeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.userInformationView.tagOncLabel.mas_left);
                            make.top.equalTo(self.userInformationView.tagOncLabel.mas_bottom).offset(5);
                        }];
                    }
                        break;
                    case 0:{
                        self.userInformationView.tagOncLabel.hidden = YES;
                        self.userInformationView.tagTwoLabel.hidden = YES;
                        
                        [self.userInformationView.stopTimeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.userInformationView.tagOncLabel.mas_left);
                            make.bottom.equalTo(self.userInformationView.HeadPortraitImageView.mas_bottom).offset(-2);
                        }];
                    }
                        break;
                    default:
                        break;
                }

                self.userInformationView.creditBackgroundView.hidden = NO;
                self.userInformationView.creditImageView.hidden = NO;
                self.userInformationView.creditLabel.hidden = NO;
                self.userInformationView.aFewDegreesBackgroundLabel.hidden = NO;
                // 几度好友
                self.userInformationView.aFewDegreesBackgroundLabel.text = [WQTool friendship:[model.user_degree integerValue]];
                // 信用分数
                self.userInformationView.creditLabel.text = [model.user_creditscore stringByAppendingString:@"分"];
            }else {
                // 匿名不显示信用分和几度好友
                self.userInformationView.creditBackgroundView.hidden = YES;
                self.userInformationView.creditImageView.hidden = YES;
                self.userInformationView.creditLabel.hidden = YES;
                self.userInformationView.aFewDegreesBackgroundLabel.hidden = YES;
                self.userInformationView.tagOncLabel.hidden = YES;
                self.userInformationView.tagTwoLabel.hidden = YES;
                // 截止时间
                [self.userInformationView.stopTimeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    //make.size.mas_equalTo(CGSizeMake(10, 11));
                    make.left.equalTo(self.userInformationView.tagOncLabel.mas_left);
                    make.bottom.equalTo(self.userInformationView.HeadPortraitImageView.mas_bottom).offset(-2);
                }];
            }
            linksContentView.hidden = YES;
            self.userInformationView.moneyLabel.hidden = NO;
            self.userInformationView.distanceLabel.hidden = NO;
            self.userInformationView.stopTimeImageView.hidden = NO;
            self.userInformationView.distanceImageView.hidden = NO;
            self.userInformationView.stopTimeLabel.hidden = NO;
            // 截止时间
            //self.userInformationView.stopTimeLabel.text = model.need_finished_date;
            NSInteger time = [[NSString stringWithFormat:@"%@",model.left_second] integerValue];
            self.userInformationView.stopTimeLabel.text = [WQTool getFinishTime:time];
            
            // 金额
            self.userInformationView.moneyLabel.text = [@"¥ " stringByAppendingString:model.need_money];
            // 距离
            NSInteger distance = [[NSString stringWithFormat:@"%@",model.need_distance] integerValue];
            if (distance > 10000) {
                NSInteger kmPosition = distance / 1000;
                self.userInformationView.distanceLabel.text = [[NSString stringWithFormat:@"%zd",kmPosition] stringByAppendingString:@"千米"];
            }else {
                self.userInformationView.distanceLabel.text = [[NSString stringWithFormat:@"%zd",distance] stringByAppendingString:@"米"];
            }
            // 标题
            self.groupContentView.titleLabel.text = model.need_subject;
            // name
            self.userInformationView.userLabel.text = model.need_user_name;
            // 内容
            self.groupContentView.contentLabel.text = model.need_content;
            // 头像
            NSString *imageUrl = [imageUrlString stringByAppendingString:model.need_user_pic];
            [self.userInformationView.HeadPortraitImageView yy_setImageWithURL:[NSURL URLWithString:imageUrl] options:YYWebImageOptionShowNetworkActivity];
            
            // 如果是BBS的话显示红包 让距离的顶部等于红包的底部
            if ([model.need_category_level_1 isEqualToString:@"BBS"]) {
                self.userInformationView.moneyLabel.hidden = YES;
                self.userInformationView.hongbaoImageView.hidden = NO;
                [self.userInformationView.distanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.userInformationView.mas_right).offset(-ghStatusCellMargin);
                    make.top.equalTo(self.userInformationView.moneyLabel.mas_bottom).offset(15);
                }];
            }else {
                self.userInformationView.moneyLabel.hidden = NO;
                self.userInformationView.hongbaoImageView.hidden = YES;
                // 让距离等于顶部等于金额的底部
                [self.userInformationView.distanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.userInformationView.stopTimeLabel.mas_centerY);
                    make.right.equalTo(self.userInformationView.mas_right).offset(-ghStatusCellMargin);
                }];
            }
        }
    }
    
}

- (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    return attributedString;
}

#pragma mark -- 外链的响应事件
- (void)linksContentViewClick:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(wqLinksContentViewClick:)]) {
        [self.delegate wqLinksContentViewClick:self];
    }
}

#pragma mark --活动的响应事件
- (void)actlvltyViewClick:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(wqActlvltyViewClick:)]) {
        [self.delegate wqActlvltyViewClick:self];
    }
}

#pragma mark -- userInformationViewDelegate
- (void)wqGroupUserInformationViewHeadPortraitCliek:(WQWQGroupUserInformationView *)groupUserInformationView {
    if ([self.delegate respondsToSelector:@selector(wqGroupDynamicTableViewCellHeadPortraitCliek:)]) {
        [self.delegate wqGroupDynamicTableViewCellHeadPortraitCliek:self];
    }
}

@end
