//
//  WQPrasiseListCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/19.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQPrasiseListCell.h"
#import "WQUserProfileController.h"
#import "WQparticularsViewController.h"
#import "WQEssenceDetailController.h"
#import "WQEssenceModel.h"
#import "WQCommentDetailsViewController.h"
#import "WQdynamicDetailsViewConroller.h"

@interface WQPrasiseListCell ()
@property (retain, nonatomic)  UIImageView *avatar;
@property (retain, nonatomic)  UILabel *userName;
@property (retain, nonatomic)  UILabel *actionLabel;
//@property (nonatomic, retain)  YYLabel * commentLabel;
@property (retain, nonatomic)  YYLabel *topicInfoShowLabel;
@property (retain, nonatomic)  UILabel *timeLabel;
@property (retain, nonatomic)  UIButton *replyButton;
@property (nonatomic, retain)  UIView * sep;
@end

@implementation WQPrasiseListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupConstraints];
        self.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
    }
    
    return self;
}


- (void)setupUI {
    _avatar = [[UIImageView alloc] initWithFrame:CGRectZero];
    _avatar.backgroundColor = [UIColor lightGrayColor];
    _avatar.layer.cornerRadius = 20;
    _avatar.image = [UIImage imageNamed:@"zhanweitu"];
    _avatar.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatar];
    _avatar.userInteractionEnabled = YES;
    [_avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontap)]];
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
    _userName = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_userName];
    _userName.font = [UIFont systemFontOfSize:14];
    _userName.textColor = HEX(0x111111);
    
    _actionLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_actionLabel];
    _actionLabel.textColor = HEX(0x666666);
    _actionLabel.font = [UIFont systemFontOfSize:12];
    
    
    _replyButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_replyButton];
    
    [_replyButton setImage:[UIImage imageNamed:@"group_pinglun"] forState:UIControlStateNormal];
    
    [_replyButton addTarget:self action:@selector(commentOnclick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    _commentLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
    //    [self.contentView addSubview:_commentLabel];
    //    _commentLabel.numberOfLines = 0;
    //    _commentLabel.font = [UIFont systemFontOfSize:15];
    //    _commentLabel.textColor = HEX(0x111111);
    
    _topicInfoShowLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
    _topicInfoShowLabel.backgroundColor = HEX(0xf3f3f3);
    _topicInfoShowLabel.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.contentView addSubview:_topicInfoShowLabel];
    _topicInfoShowLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _topicInfoShowLabel.font = [UIFont systemFontOfSize:14];
    
    _topicInfoShowLabel.textColor = HEX(0x666666);
    _topicInfoShowLabel.numberOfLines = 0;
    __weak typeof(self) weakself = self;
    [_topicInfoShowLabel setTextTapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        __strong typeof(self) strongSelf = weakself;
        [strongSelf showDetail];
    }];
    
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_timeLabel];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = HEX(0x666666);
    
    
//    _sep = [[UIView alloc] initWithFrame:CGRectZero];
//    [self.contentView addSubview:_sep];
//    _sep.backgroundColor = HEX(0xececec);
    
}

- (void)setupConstraints {
    
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@10);
        make.height.width.equalTo(@40);
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatar.mas_right).offset(10);
        make.height.equalTo(@20);
        make.top.equalTo(_avatar.mas_top).offset(3);
    }];
    
    [_actionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userName.mas_bottom).offset(3);
        make.height.equalTo(@15);
        make.left.equalTo(_userName.mas_left);
    }];
    
    [_replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_avatar.mas_top).offset(3);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [_topicInfoShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth - 70));
        make.left.equalTo(_userName);
        make.top.equalTo(_actionLabel.mas_bottom).offset(10);
        make.height.mas_greaterThanOrEqualTo(@34);
    }];
    
    
    
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_actionLabel);
        make.top.equalTo(_topicInfoShowLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
//    [_sep mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_userName);
//        make.bottom.equalTo(self.contentView.mas_bottom);
//        make.right.equalTo(self.contentView);
//        make.height.equalTo(@0.5);
//    }];
    
}







- (void)ontap {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    
    __weak typeof(self) weakSelf = self;
    if ([role_id isEqualToString:@"200"]) {
        //游客登录
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请注册/登录后查看更多" preferredStyle:UIAlertControllerStyleAlert];
        
        [self.viewController presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return ;
    }
    
    
    
    if (![WQDataSource sharedTool].verified) {
        // 快速注册的用户
        UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"实名认证后可查看用户信息"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 NSLog(@"取消");
                                                             }];
        UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"实名认证"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:[WQDataSource sharedTool].userIdString];
                                                                      [self.viewController.navigationController pushViewController:vc animated:YES];
                                                                  }];
        [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
        [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
        
        [alertController addAction:cancelButton];
        [alertController addAction:destructiveButton];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    
    
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    // 是当前账户
    if ([self.model.user_id isEqualToString:im_namelogin]) {
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:self.model.user_id];
      
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }else {
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:self.model.user_id];
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }

}

- (void)commentOnclick {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    
    __weak typeof(self) weakSelf = self;
    if ([role_id isEqualToString:@"200"]) {
        //游客登录
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请注册/登录后查看更多" preferredStyle:UIAlertControllerStyleAlert];
        
        [self.viewController presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return ;
    }
    
    if (!self.model.user_truename) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"实名用户匿名状态" preferredStyle:UIAlertControllerStyleAlert];
        
        [weakSelf.viewController presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.viewController.navigationController popViewControllerAnimated:YES];
            });
        }];
        return ;
    }
    
    if (![WQDataSource sharedTool].verified) {
        // 快速注册的用户
        UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"实名认证后可查看用户信息"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 NSLog(@"取消");
                                                             }];
        UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"实名认证"
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:[WQDataSource sharedTool].userIdString];
                                                                      [self.viewController.navigationController pushViewController:vc animated:YES];
                                                                  }];
        [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
        [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
        
        [alertController addAction:cancelButton];
        [alertController addAction:destructiveButton];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    
    
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    // 是当前账户
    if ([self.model.user_id isEqualToString:im_namelogin]) {
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:self.model.user_id];
      
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }else {
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:self.model.user_id];
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }

    
}

- (void)showDetail {
    if ([_model.targettype isEqualToString:@"TARGET_TYPE_CHOICEST_ARTICLE"]) {
        WQEssenceDetailController * vc = [[WQEssenceDetailController alloc] init];
        WQEssenceModel * essenceModel= [WQEssenceModel new];
        essenceModel.id = _model.targetid;
        essenceModel.favorited = NO;
        vc.model = essenceModel;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    
    if ([_model.targettype isEqualToString:@"TARGET_TYPE_MOMENT_STATUS"]) {
        WQdynamicDetailsViewConroller * vc = [[WQdynamicDetailsViewConroller alloc] init];
        vc.mid = _model.targetid;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    
// 对于攒了你的评论， 该字段为TARGET_TYPE_MOMENT_STATUS时，进入动态详情页面；为TARGET_TYPE_COMMENT时，进入动态评论详情页面；为TARGET_TYPE_CHOICEST_ARTICLE时，进入精选详情页面；为TARGET_TYPE_CHOICEST_COMMENT时，进入精选评论详情
    if ([_model.targettype isEqualToString:@"TARGET_TYPE_COMMENT"]) {
        WQCommentDetailsViewController * vc = [[WQCommentDetailsViewController alloc] init];
        vc.type = CommentDetailTypeMoment;
        vc.commentId = self.model.targetid;
//        WQDynamicLevelOncCommentModel * model = [[WQDynamicLevelOncCommentModel alloc] init];
//        model.user_id = self.model.user_id;
//        model.user_pic = self.model.user_pic;
//        vc.model = model;
        // TODO: 需要跳转评论详情页
        
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    
    if ([_model.targettype isEqualToString:@"TARGET_TYPE_CHOICEST_COMMENT"]) {
        WQCommentDetailsViewController * vc = [[WQCommentDetailsViewController alloc] init];
        vc.type = CommentDetailTypeEssence;
        vc.commentId = self.model.targetid;
        // TODO: 需要跳转评论详情页
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }    
}


- (void)setModel:(WQPraiseListModel *)model {
    _model = model;
    [_avatar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    _userName.text = model.user_name;
    //    _actionLabel.text =
    _actionLabel.text = [NSString stringWithFormat:@"%@",model.title];
    
    _topicInfoShowLabel.text = model.subject.length?model.subject:@"我的动态";
    CGSize size = [_topicInfoShowLabel sizeThatFits:CGSizeMake(kScreenWidth - 75, MAXFLOAT)];
    [_topicInfoShowLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(size.height));
    }];
    NSTimeInterval interval = model.posttime_pastseconds.doubleValue;

    _timeLabel.text = [self descOfTimeInterval:interval];
    //    targetid的类型：TARGET_TYPE_MOMENT_STATUS=万圈状态； TARGET_TYPE_NEED=需求； TARGET_TYPE_GROUP=圈子； TARGET_TYPE_GROUP_TOPIC=圈子主题；
    
    _replyButton.hidden = YES;
    
}


- (NSString *)descOfTimeInterval:(NSTimeInterval)interval {
    NSInteger time = interval;
    if (time < 60) {
        return  [NSString stringWithFormat:@"刚刚"];
    }else if (time < 3600) {
        return [NSString stringWithFormat:@"%zd 分钟前",time / 60];
    }else if (time / (60 * 60 * 24) >= 1) {
        return [NSString stringWithFormat:@"%zd 天前",time / (60 * 60 * 24)];
    }else{
        return [NSString stringWithFormat:@"%zd 小时前",time / 3600];
    }
}

@end
