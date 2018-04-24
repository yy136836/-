//
//  WQCommentLevelOncTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/15.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQCommentLevelOncTableViewCell.h"
#import "WQDynamicLevelOncCommentModel.h"
#import "WQUserProfileController.h"
#import "WQCommentDetailsViewController.h"
#import "WQEssenceDetailController.h"
#import "WQdynamicDetailsViewConroller.h"
#import "WQorderViewController.h"

@interface WQCommentLevelOncTableViewCell ()

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

@implementation WQCommentLevelOncTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
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
    self.user_name = [UILabel labelWithText:@"陈亮" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:14];
    [self.contentView addSubview:self.user_name];
    [self.user_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.left.equalTo(self.user_pic.mas_right).offset(ghStatusCellMargin);
    }];
    
    // 时间
    UILabel *timeLabel = [UILabel labelWithText:@"2分钟前" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:12];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.user_name.mas_left);
        make.top.equalTo(self.user_name.mas_bottom).offset(6);
    }];
    
    // 内容
    self.contentLabel = [UILabel labelWithText:@"这是内容呀!" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:15];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.user_name.mas_left);
        make.top.equalTo(timeLabel.mas_bottom).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
    }];
    
    // 原内容的按钮
    UIButton *originalContentBtn = [[UIButton alloc] init];
    originalContentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [originalContentBtn setTitle:@"查看原主题内容" forState:UIControlStateNormal];
    [originalContentBtn setTitleColor:[UIColor colorWithHex:0x5288d8] forState:UIControlStateNormal];
    [originalContentBtn addTarget:self action:@selector(originalContentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:originalContentBtn];
    [originalContentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.user_name.mas_left);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(ghDistanceershi);
        make.bottom.equalTo(self.contentView);
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
        make.top.equalTo(self.contentView).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
    }];
}

- (void)setModel:(WQDynamicLevelOncCommentModel *)model {
    _model = model;
    // 头像
    [self.user_pic yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_MIDDLE_URLSTRING(model.user_pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    // 姓名
    self.user_name.text = model.user_name;
    
    // 已过时间
    long long time = [model.past_second longLongValue];
    if (time < 60) {
        self.timeLabel.text = [NSString stringWithFormat:@"刚刚"];
    }else if (time < 3600) {
        self.timeLabel.text = [NSString stringWithFormat:@"%lld 分钟前",time / 60];
    }else if (time / (60 * 60 * 24) >= 1) {
        self.timeLabel.text = [NSString stringWithFormat:@"%lld 天前",time / (60 * 60 * 24)];
    }else{
        self.timeLabel.text = [NSString stringWithFormat:@"%lld 小时前",time / 3600];
    }
    // 内容
    self.contentLabel.text = model.content;
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

#pragma mark -- 赞的响应事件
- (void)praiseBtnClick {
    NSString *urlString = @"api/moment/status/commentlike";
    if ([self.viewController isKindOfClass:[WQCommentDetailsViewController class]]) {
        WQCommentDetailsViewController * vc = self.viewController;
        if (vc.type == CommentDetailTypeEssence) {
            urlString = @"api/choicest/articlecommentlike";
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"comment_id"] = self.model.id;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        if ([response[@"success"] integerValue]) {
            self.model.like_count += 1;
            self.model.isLiked = !self.model.isLiked;
            if (self.refreshBlock) {
                self.refreshBlock();
            }
        }else {
            [UIAlertController wqAlertWithController:self.viewController addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
        }
    }];
}

#pragma mark -- 原内容的的响应事件
- (void)originalContentBtnClick {
    
    if (self.isnid) {
        WQorderViewController *orderVc = [[WQorderViewController alloc] initWithNeedsId:self.nid];
        [self.viewController.navigationController pushViewController:orderVc animated:YES];
        return;
    }
    
    if (self.fromMessage) {
        
        if (self.model.mid) {
            
            WQdynamicDetailsViewConroller * vc = [[WQdynamicDetailsViewConroller alloc] init];
            vc.mid = self.model.mid;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
        
        if (self.model.aid) {
            WQEssenceDetailController * essence = [[WQEssenceDetailController alloc] init];
            WQEssenceModel * model = [[WQEssenceModel alloc] init];
            model.id = self.model.aid;
            model.essenceLikeCount = self.model.like_count;
            essence.model = model;
            [self.viewController.navigationController pushViewController:essence animated:YES];
        }
        
    } else {
        [self.viewController.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- 头像的响应事件
- (void)headBtnClike {
    if (self.headBtnClikeBlock) {
        self.headBtnClikeBlock();
    }
}

@end
