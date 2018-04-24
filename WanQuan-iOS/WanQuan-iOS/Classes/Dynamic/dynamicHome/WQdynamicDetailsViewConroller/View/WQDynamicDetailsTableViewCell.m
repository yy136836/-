//
//  WQDynamicDetailsTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQDynamicDetailsTableViewCell.h"
#import "WQparticularsModel.h"
#import "WQdynamicUserInformationView.h"
#import "WQDynamicDetailsToolBarView.h"
#import "WQDynamicDetailsContentView.h"
#import "WQlikeListView.h"
#import "WQreward_ListView.h"
#import "WQLinksContentView.h"
#import "WQTopicArticleController.h"

@interface WQDynamicDetailsTableViewCell () <WQdynamicUserInformationViewDelegate,WQdynamicTableViewCellDelegate>

/**
 用户信息的view
 */
@property (nonatomic, strong) WQdynamicUserInformationView *userInformationView;

/**
 动态的view
 */
@property (nonatomic, strong) WQDynamicDetailsContentView *dynamicContentView;

/**
 底部栏的view
 */
@property (nonatomic, strong) WQDynamicDetailsToolBarView *toolBarView;

/**
 赞的view
 */
@property (nonatomic, strong) WQlikeListView *likeListView;

/**
 打赏的view
 */
@property (nonatomic, strong) WQreward_ListView *reward_ListView;

/**
 外链的view
 */
@property (nonatomic, strong) WQLinksContentView *linksContentView;

@end

@implementation WQDynamicDetailsTableViewCell

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
    // 用户信息的view
    WQdynamicUserInformationView *userInformationView = [[WQdynamicUserInformationView alloc] init];
    userInformationView.guanzhuBtn.hidden = YES;
    userInformationView.essenceImageView.hidden = YES;
    userInformationView.delegate = self;
    self.userInformationView = userInformationView;
    [self.contentView addSubview:userInformationView];
    [userInformationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.contentView);
        make.height.offset(65);
    }];
    
    // 动态的view
    WQDynamicDetailsContentView *dynamicContentView = [[WQDynamicDetailsContentView alloc] init];
    self.dynamicContentView = dynamicContentView;
    [self.contentView addSubview:dynamicContentView];
    [self.dynamicContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userInformationView.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    // 外链的view
    WQLinksContentView *linksContentView = [[WQLinksContentView alloc] init];
    linksContentView.layer.borderWidth = 1.0f;
    linksContentView.layer.borderColor = [UIColor colorWithHex:0xeeeeee].CGColor;
    self.linksContentView = linksContentView;
    linksContentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *linksContentViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(linksContentViewClick)];
    [linksContentView addGestureRecognizer:linksContentViewTap];
    linksContentView.isWanquanHome = YES;
    [self.contentView addSubview:linksContentView];
    [linksContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kScaleY(ghSpacingOfshiwu));
        make.right.equalTo(self.contentView).offset(kScaleY(-ghSpacingOfshiwu));
        make.top.equalTo(dynamicContentView.mas_bottom).offset(ghStatusCellMargin);
        make.height.offset(60);
    }];
    
    // 底部栏的view
    WQDynamicDetailsToolBarView *toolBarView = [[WQDynamicDetailsToolBarView alloc] init];
    toolBarView.delegate = self;
    self.toolBarView = toolBarView;
    [self.contentView addSubview:toolBarView];
    [self.toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linksContentView.mas_bottom).offset(-ghStatusCellMargin);
        make.height.offset(40);
        make.left.right.equalTo(self.contentView);
    }];
    
    // 赞的view
    WQlikeListView *likeListView = [[WQlikeListView alloc] init];
    self.likeListView = likeListView;
    [self.contentView addSubview:likeListView];
    [self.likeListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolBarView.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    // 打赏的view
    WQreward_ListView *rewrd_listView = [[WQreward_ListView alloc] init];
    self.reward_ListView = rewrd_listView;
    [self.contentView addSubview:rewrd_listView];
    [self.reward_ListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeListView.mas_bottom).offset(ghStatusCellMargin);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-ghStatusCellMargin);
    }];
}

- (void)setModel:(WQparticularsModel *)model {
    _model = model;
    
    if (model == nil) {
        return;
    }
        
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    
    if ([model.user_name isEqualToString:@"万圈小助手"]) {
        [self.userInformationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self.contentView);
            make.height.offset(65);
        }];
    }
    
    // 是否可以赞
    if (!model.can_like) {
        // 不是自己发的
        if (![model.user_id isEqualToString:im_namelogin]) {
            [self.toolBarView.unlikeBtn setImage:[UIImage imageNamed:@"dynamicyidianzan"] forState:UIControlStateNormal];
            [self.toolBarView.unlikeBtn setTitleColor:[UIColor colorWithHex:0xee9b11] forState:UIControlStateNormal];
        }
    }else {
        [self.toolBarView.unlikeBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
        [self.toolBarView.unlikeBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    }
    
    // 赞的数量
    if (model.like_count == 0) {
        // 赞的数量为O时  显示赞
        [self.toolBarView.unlikeBtn setTitle:@" 赞" forState:UIControlStateNormal];
    }else {
        [self.toolBarView.unlikeBtn setTitle:[@"   " stringByAppendingString:[NSString stringWithFormat:@"%d",model.like_count]] forState:UIControlStateNormal];
    }
    
    // 踩的数量
    if (model.dislike_count == 0) {
        // 没有踩
        [self.toolBarView.retweetbtn setTitle:@"  踩" forState:UIControlStateNormal];
    }else {
        // 有踩
        [self.toolBarView.retweetbtn setTitle:[NSString stringWithFormat:@"  %d",model.dislike_count] forState:UIControlStateNormal];
    }
    
    // 内容
    self.dynamicContentView.contentString = model.content;
    self.dynamicContentView.picArray = model.pic;
    // 头像
    [self.userInformationView.user_picImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    // 姓名
    self.userInformationView.nameLabel.text = model.user_name;
    // 信用分
    self.userInformationView.creditLabel.text = [model.user_creditscore stringByAppendingString:@"分"];
    // 标签
    self.userInformationView.user_tagLabel.text = [[model.user_tag.firstObject stringByAppendingString:@"  "] stringByAppendingString:model.user_tag.lastObject];
    
    NSInteger time = model.past_second;
    if (time < 60) {
        self.toolBarView.releaseTimeLabel.text = [NSString stringWithFormat:@"刚刚"];
    }else if (time < 3600) {
        self.toolBarView.releaseTimeLabel.text = [NSString stringWithFormat:@"%zd 分钟前",time / 60];
    }else if (time / (60 * 60 * 24) >= 1) {
        self.toolBarView.releaseTimeLabel.text = [NSString stringWithFormat:@"%zd 天前",time / (60 * 60 * 24)];
    }else{
        self.toolBarView.releaseTimeLabel.text = [NSString stringWithFormat:@"%zd 小时前",time / 3600];
    }
    // 几度好友
    NSString *user_degree;
    if ([model.user_degree integerValue] == 0) {
        user_degree = [@" " stringByAppendingString:[@"自己" stringByAppendingString:@" "]];
    }else if ([model.user_degree integerValue] <= 2) {
        user_degree = [@" " stringByAppendingString:[@"2度内好友" stringByAppendingString:@" "]];
    }else if ([model.user_degree integerValue] == 3) {
        user_degree = [@" " stringByAppendingString:[@"3度好友" stringByAppendingString:@" "]];
    }else {
        user_degree = [@" " stringByAppendingString:[@"4度外好友" stringByAppendingString:@" "]];
    }
    self.userInformationView.aFewDegreesBackgroundLabel.text = user_degree;
    self.likeListView.likeArray = model.like_list;
    self.reward_ListView.reward_list = model.reward_list;
    self.userInformationView.workArray = model.user_tag;
    
    // 没有外链
    if ([model.link_url isEqualToString:@""]) {
        // 隐藏外链的view
        self.linksContentView.hidden = YES;
        [self.linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [self.toolBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dynamicContentView.mas_bottom).offset(-ghStatusCellMargin);
            make.height.offset(40);
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(5);
        }];
    }else {
        if ([model.link_img isEqualToString:@""]) {
            self.linksContentView.linksImage.image = [UIImage imageNamed:@"lianjie占位图"];
        }else {
            [self.linksContentView.linksImage yy_setImageWithURL:[NSURL URLWithString:model.link_img] placeholder:[UIImage imageNamed:@"lianjie占位图"]];
        }
        [self.linksContentView.linksLabel setText:model.link_txt];
        
        // 显示外链的view
        self.linksContentView.hidden = NO;
        [self.linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kScaleY(ghSpacingOfshiwu));
            make.right.equalTo(self.contentView).offset(kScaleY(-ghSpacingOfshiwu));
            make.top.equalTo(self.dynamicContentView.mas_bottom).offset(ghStatusCellMargin);
            make.height.offset(60);
        }];
        [self.toolBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.linksContentView.mas_bottom);
            make.height.offset(40);
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(5);
        }];
    }
    
    // 有人点赞或者有人打赏
    if (model.like_list.count >= 1 || model.reward_list.count >= 1) {
        // 有人点赞有人打赏
        if (model.like_list.count >= 1 && model.reward_list.count >= 1) {
            [self.toolBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if ([model.link_url isEqualToString:@""]) {
                    make.top.equalTo(self.dynamicContentView.mas_bottom).offset(-ghStatusCellMargin);
                }else {
                    make.top.equalTo(self.linksContentView.mas_bottom);
                }
                make.height.offset(40);
                make.left.right.equalTo(self.contentView);
            }];
            [self.likeListView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.toolBarView.mas_bottom);
                make.left.right.equalTo(self.contentView);
            }];
            [self.reward_ListView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.likeListView.mas_bottom).offset(ghStatusCellMargin);
                make.left.right.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView).offset(-ghStatusCellMargin);;
            }];
        }else {
            // 没有人点赞
            if (!model.like_list.count) {
                [self.toolBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    if ([model.link_url isEqualToString:@""]) {
                        make.top.equalTo(self.dynamicContentView.mas_bottom).offset(-ghStatusCellMargin);
                    }else {
                        make.top.equalTo(self.linksContentView.mas_bottom);
                    }
                    make.height.offset(40);
                    make.left.right.equalTo(self.contentView);
                }];
                [self.reward_ListView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.toolBarView.mas_bottom);
                    make.left.right.equalTo(self.contentView);
                    make.bottom.equalTo(self.contentView);
                }];
            }
            // 没有人打赏
            if (!model.reward_list.count) {
                [self.toolBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    if ([model.link_url isEqualToString:@""]) {
                        make.top.equalTo(self.dynamicContentView.mas_bottom).offset(-ghStatusCellMargin);
                    }else {
                        make.top.equalTo(self.linksContentView.mas_bottom);
                    }
                    make.height.offset(40);
                    make.left.right.equalTo(self.contentView);
                }];
                self.likeListView.bottomLineView.hidden = YES;
                [self.likeListView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.toolBarView.mas_bottom);
                    make.left.right.equalTo(self.contentView);
                    make.bottom.equalTo(self.contentView);
                }];
            }
        }
    }else {
        [self.toolBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if ([model.link_url isEqualToString:@""]) {
                make.top.equalTo(self.dynamicContentView.mas_bottom);
            }else {
                make.top.equalTo(self.linksContentView.mas_bottom);
            }
            make.height.offset(40);
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(5);
        }];
    }
}

#pragma makr -- 外链的响应事件
- (void)linksContentViewClick {
    WQTopicArticleController *vc = [[WQTopicArticleController alloc] init];
    vc.URLString = _model.link_url;
    vc.NavTitle = _model.link_txt;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 头像的响应事件
- (void)wqUser_picImageViewClick:(WQdynamicUserInformationView *)dynamicUserInformationView {
    if ([self.delegate respondsToSelector:@selector(wqUser_picImageViewClick:cell:)]) {
        [self.delegate wqUser_picImageViewClick:dynamicUserInformationView cell:self];
    }
}

#pragma mark -- WQdynamicTableViewCellDelegate
- (void)wqPlayTourBtnClike:(WQDynamicDetailsToolBarView *)toolBarView {
    // 鼓励的响应事件
    if ([self.delegate respondsToSelector:@selector(wqPlayTourBtnClike:cell:)]) {
        [self.delegate wqPlayTourBtnClike:toolBarView cell:self];
    }
}

- (void)wqUnlikeBtnClike:(WQDynamicDetailsToolBarView *)toolBarView {
    // 赞的响应事件
    if ([self.delegate respondsToSelector:@selector(wqUnlikeBtnClike:cell:)]) {
        [self.delegate wqUnlikeBtnClike:toolBarView cell:self];
    }
}

- (void)wqRetweetbtnClike:(WQDynamicDetailsToolBarView *)toolBarView {
    // 踩的响应事件
    if ([self.delegate respondsToSelector:@selector(wqRetweetbtnClike:cell:)]) {
        [self.delegate wqRetweetbtnClike:toolBarView cell:self];
    }
}

@end
