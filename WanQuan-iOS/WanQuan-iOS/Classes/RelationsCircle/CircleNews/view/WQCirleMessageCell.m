//
//  WQCircleDynamicCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQCirleMessageCell.h"
#import "WQUserProfileController.h"
#import "WQparticularsViewController.h"
#import "WQTopicDetailController.h"
#import "WQCommentDetailController.h"
#import "YYLabel+WQGhLabel.h"
#import "WQPhotoBrowser.h"
#import "WQEssenceDetailController.h"
#import "WQEssenceModel.h"
#import "WQCommentDetailsViewController.h"
#import "WQdynamicDetailsViewConroller.h"
#import "WQNeedsSecondaryReplyModel.h"
#import "WQdetailsConrelooerViewController.h"
#import "WQorderViewController.h"

@interface WQCirleMessageCell ()<MWPhotoBrowserDelegate>
@property (retain, nonatomic)  UIImageView *avatar;
@property (retain, nonatomic)  UILabel *userName;

/**
 回复主题评论或好友圈
 */
@property (retain, nonatomic)  UILabel *actionLabel;

/**
 发表的评论的内容
 */
@property (nonatomic, retain)  YYLabel * commentLabel;

/**
 被评论的内容
 */
@property (retain, nonatomic)  YYLabel *topicInfoShowLabel;

/**
 被评论的图片
 */
@property (nonatomic, retain)  UIImageView * commentImage;

@property (nonatomic, strong) YYLabel *titleLabel;

@property (retain, nonatomic)  UILabel *timeLabel;
@property (retain, nonatomic)  UIButton *replyButton;
@property (nonatomic, retain)  UIView * sep;

@end


@implementation WQCirleMessageCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//    _avatar.backgroundColor = [UIColor lightGrayColor];
//    _avatar.layer.cornerRadius = 5;
//    _avatar.layer.masksToBounds = YES;
//
//
//
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupConstraints];
        //        [self setData];
    }
    
    return self;
}



- (void)setupUI {
    _avatar = [[UIImageView alloc] initWithFrame:CGRectZero];
    _avatar.backgroundColor = [UIColor lightGrayColor];
    _avatar.image = [UIImage imageNamed:@"zhanweitu"];
    _avatar.layer.cornerRadius = 20;
    _avatar.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatar];
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
    _avatar.userInteractionEnabled = YES;
    [_avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontap)]];
    
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
    _replyButton.showsTouchWhenHighlighted = NO;
    
    _commentLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_commentLabel];
    _commentLabel.numberOfLines = 0;
    _commentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _commentLabel.font = [UIFont systemFontOfSize:15];
    _commentLabel.textColor = HEX(0x111111);

    _topicInfoShowLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
    _topicInfoShowLabel.backgroundColor = HEX(0xf3f3f3);
    _topicInfoShowLabel.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.contentView addSubview:_topicInfoShowLabel];
    _topicInfoShowLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _topicInfoShowLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    _topicInfoShowLabel.font = [UIFont boldSystemFontOfSize:14];
    _topicInfoShowLabel.layer.borderWidth = 1.0f;
    _topicInfoShowLabel.layer.borderColor = [UIColor colorWithHex:0xeeeeee].CGColor;
    
    _commentImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_commentImage];
    _commentImage.contentMode = UIViewContentModeScaleAspectFill;
    _commentImage.clipsToBounds = YES;
    
    _topicInfoShowLabel.textColor = HEX(0x666666);
    _topicInfoShowLabel.numberOfLines = 0;
    __weak typeof(self) weakself = self;
    [_topicInfoShowLabel setTextTapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        __strong typeof(self) strongSelf = weakself;
        [strongSelf showDetail];
    }];
    
    _topicInfoShowLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_timeLabel];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = HEX(0x666666);
    
    
    _sep = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_sep];
    _sep.backgroundColor = HEX(0xeeeeee);
    
    self.titleLabel = [[YYLabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHex:0x666666];
    self.titleLabel.text = @"12131232131";
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.backgroundColor = HEX(0xf3f3f3);
    self.titleLabel.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.titleLabel.layer.borderWidth = 1.0f;
    self.titleLabel.layer.borderColor = [UIColor colorWithHex:0xeeeeee].CGColor;
    self.titleLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel setTextTapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        __strong typeof(self) strongSelf = weakself;
        [strongSelf titleClick];
    }];
}

- (void)titleClick {
    // 需求二级评论
    if ([self.model.targettype isEqualToString:@"TARGET_TYPE_NEED_COMMENT"]){
        WQCommentDetailsViewController * vc = [[WQCommentDetailsViewController alloc] init];
        vc.type = CommentDetaiTypeNeeds;
        WQNeedsSecondaryReplyModel *replyModel = self.model.targetOperation;
        vc.nid = replyModel.neeID;
        WQDynamicLevelOncCommentModel *model = [[WQDynamicLevelOncCommentModel alloc] init];
        model.id = self.model.targetid;
        vc.model = model;
        vc.mid = self.model.targetid;
        vc.isnid = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

- (void)setupConstraints {
    
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@15);
        make.height.width.equalTo(@40);
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatar.mas_right).offset(10);
        make.top.equalTo(@17);
    }];
    
    [_actionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userName.mas_bottom).offset(6);
        make.left.equalTo(_userName.mas_left);
    }];
    
    [_replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_avatar.mas_top).offset(6);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth - 70));
        make.top.equalTo(_avatar.mas_bottom).offset(13);
        make.left.equalTo(_actionLabel);
    }];
    
    
    [_commentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_commentLabel.mas_bottom).offset(10);
        make.left.equalTo(_commentLabel.mas_left);
        make.width.height.equalTo(@200);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_commentLabel.mas_bottom).offset(10);
        make.left.equalTo(_userName);
        make.width.equalTo(@(kScreenWidth - 75));
//        make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
    }];
    
    [_topicInfoShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth - 75));
//        make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
        make.left.equalTo(_userName);
        //make.top.equalTo(_commentLabel.mas_bottom).offset(10);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(-0.5);
        make.height.mas_greaterThanOrEqualTo(@34);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(35);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_actionLabel);
        //        make.top.equalTo(_topicInfoShowLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [_sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userName);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}


- (void)setModel:(WQCircleNewsModel *)model {
    _model = model;
    [_avatar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)]
                        placeholder:[UIImage imageNamed:@"zhanweitu"]];
    _addHeight = 0;
    _userName.text = model.user_name;
    _actionLabel.text = [NSString stringWithFormat:@"%@",model.title];
    NSMutableAttributedString * attrstr = [[NSMutableAttributedString alloc] initWithString:model.content attributes:@{NSForegroundColorAttributeName : HEX(0x111111),NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    attrstr.yy_lineSpacing = 5;
    _commentLabel.attributedText = attrstr;
    NSTimeInterval interval = model.posttime_pastseconds.doubleValue;
    
    _timeLabel.text = [self descOfTimeInterval:interval];
    //    targetid的类型：TARGET_TYPE_MOMENT_STATUS=万圈状态； TARGET_TYPE_NEED=需求； TARGET_TYPE_GROUP=圈子； TARGET_TYPE_GROUP_TOPIC=圈子主题；
    _replyButton.hidden = !([self.model.targettype isEqualToString:@"TARGET_TYPE_GROUP_TOPIC"]||
                            [self.model.targettype isEqualToString:@"TARGET_TYPE_GROUP_TOPIC_POST"]);
    
    
    
    CGSize size = [ _commentLabel sizeThatFits:CGSizeMake(kScreenWidth - 75, MAXFLOAT)];
    
    
    
    [_commentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth - 70));
        make.top.equalTo(_actionLabel.mas_bottom).offset(10);
        make.left.equalTo(_actionLabel);
        make.height.offset(size.height);
    }];
    
    _commentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    
    if (size.height > 20) {
        _addHeight = size.height - 20;
    }
    
    
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:model.subject attributes:@{}];
    attr.yy_color = HEX(0x333333);
    attr.yy_lineSpacing = 10;
    attr.yy_font = [UIFont boldSystemFontOfSize:14];
    
    _topicInfoShowLabel.attributedText = model.subject.length ? attr:[[NSAttributedString alloc] initWithString:@"分享链接" attributes:@{}];
    
    // 需求一级评论
    if ([model.targettype isEqualToString:@"TARGET_TYPE_NEED"]) {
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[[WQDataSource sharedTool].user_name stringByAppendingString:@":\n"]
            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],                                                                                NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333]}]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:model.subject                                   attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],                                   NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333]}]];
        
        str.yy_lineSpacing = 5;
        _topicInfoShowLabel.attributedText = str;
    }
    
    // 需求二级评论
    if ([model.targettype isEqualToString:@"TARGET_TYPE_NEED_COMMENT"]){
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_commentLabel.mas_bottom).offset(10);
            make.left.equalTo(_userName);
            make.width.equalTo(@(kScreenWidth - 75));
        }];
        self.titleLabel.text = model.subject;
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
        WQNeedsSecondaryReplyModel *replyModel = model.targetOperation;
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[replyModel.needUser stringByAppendingString:@":\n"]
                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],                                                                                NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333]}]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:replyModel.needTitle                                   attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],                                   NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333]}]];
        
        str.yy_lineSpacing = 5;
        _topicInfoShowLabel.attributedText = str;
    }else{
        self.titleLabel.text = @"";
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_commentLabel.mas_bottom).offset(10);
            make.height.offset(0);
        }];
    }
    
    
    
    YYLabel * lab = [[YYLabel alloc] init];
    lab.numberOfLines = 0;
    lab.font = attr.yy_font = [UIFont boldSystemFontOfSize:14];
    lab.attributedText = _topicInfoShowLabel.attributedText;
    
    
    size = [lab sizeThatFits:CGSizeMake(kScreenWidth - 75 - 20, MAXFLOAT)];
    
    
    //    UILabel
    
    CGFloat lines =  (size.height)  / (_topicInfoShowLabel.font.lineHeight + 10);
    
    //    NSLog(@"%@ ------- %lf-------%lf",model.subject,_topicInfoShowLabel.font.lineHeight,lines);
    
    CGFloat infoLabelAddHeight = 0;
    
    
    CGSize size0 = CGSizeMake(0, 0);
    if (lines <= 1) {
        
        
        _addHeight += 0;
        size0.height = 34;
        //        NSLog(@"%@",model.subject);
        
    } else if (lines <= 2 ) {
        _addHeight += _topicInfoShowLabel.font.lineHeight + 10 ;
        //        NSLog(@"");
        infoLabelAddHeight = _topicInfoShowLabel.font.lineHeight + 15;
        _topicInfoShowLabel.numberOfLines = 2;
        
        size0 = [_topicInfoShowLabel sizeThatFits:CGSizeMake(kScreenWidth - 75, MAXFLOAT)];
        
        
        
    } else {
        _addHeight += (_topicInfoShowLabel.font.lineHeight + 10) * 2;
        _topicInfoShowLabel.numberOfLines = 3;
        infoLabelAddHeight = (_topicInfoShowLabel.font.lineHeight + 10) * 2 + 5;
        size0 = [_topicInfoShowLabel sizeThatFits:CGSizeMake(kScreenWidth - 75, MAXFLOAT)];
        
    }
    
    
    
    
    if (model.pic.count) {
        
        _commentImage.hidden = NO;
        
        [_commentImage yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_LARGE_URLSTRING(model.pic[0])] options:YYWebImageOptionProgressive];
        _addHeight += 220;
        
        _commentImage.userInteractionEnabled = YES;
        [_commentImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picOnTap:)]];
        
    } else {
        _commentImage.image = [UIImage new];
        _commentImage.hidden = YES;
    }
    //    [_commentLabel sizeThatFits:CGSizeMake(kScreenWidth - 75, MAXFLOAT)];
//    [_topicInfoShowLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
////        make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
//        make.width.equalTo(@(kScreenWidth - 75));
//        make.left.equalTo(_userName);
//        //make.top.equalTo(_commentLabel.mas_bottom).offset(self.model.pic.count ? 220: 10);
////        if (self.model.pic.count) {
////            make.top.equalTo(_commentLabel.mas_bottom).offset(self.titleLabel.size.height + 230);
////        }else {
////            make.top.equalTo(_commentLabel.mas_bottom).offset(self.titleLabel.size.height + 20);
////        }
//        make.top.equalTo(self.titleLabel.mas_bottom).offset(-0.5);
//        make.height.equalTo(@(infoLabelAddHeight + 35));
//        make.bottom.equalTo(self.contentView).offset(-35);
//    }];
    //    }
    if (model.pic.count) {
        [_topicInfoShowLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kScreenWidth - 75));
            make.left.equalTo(_userName);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(-0.5);
            make.height.equalTo(@(infoLabelAddHeight + 35));
//            make.bottom.equalTo(self.contentView).offset(-35);
        }];
        [_commentImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topicInfoShowLabel.mas_bottom).offset(10);
            make.left.equalTo(_commentLabel.mas_left);
            make.width.height.equalTo(@200);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }else {
        [_topicInfoShowLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kScreenWidth - 75));
            make.left.equalTo(_userName);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(-0.5);
            make.height.equalTo(@(infoLabelAddHeight + 35));
            make.bottom.equalTo(self.contentView).offset(-35);
        }];
    }
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
                                                                      WQUserProfileController *vc = [[WQUserProfileController alloc] init];
                                                                      
                                                                      vc.userId = [WQDataSource sharedTool].userIdString;
                                                                      [self.viewController.navigationController pushViewController:vc animated:YES];
                                                                  }];
        [destructiveButton setValue:WQ_LIGHT_PURPLE forKey:@"titleTextColor"];
        [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
        
        [alertController addAction:cancelButton];
        [alertController addAction:destructiveButton];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    
    
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    // 是当前账户
    if ([self.model.user_id isEqualToString:im_namelogin]) {
        WQUserProfileController *vc = [[WQUserProfileController alloc] init];
        vc.userId = self.model.user_id;
        vc.selfEditing = YES;
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }else {
        WQUserProfileController *vc = [[WQUserProfileController alloc] init];
        vc.userId = self.model.user_id;
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)commentOnclick {
    
    if([self.model.targettype isEqualToString:@"TARGET_TYPE_GROUP_TOPIC"]){
        WQTopicDetailController * vc = [[WQTopicDetailController alloc] init];
        vc.tid = self.model.targetid;
        vc.detailType = TopicDetailTypeFromMessage;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    } else if([self.model.targettype isEqualToString:@"TARGET_TYPE_GROUP_TOPIC_POST"]) {
        WQCommentDetailController * vc = [[WQCommentDetailController alloc] init];
        vc.pid = self.model.targetid;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    
    if ([_model.targettype isEqualToString:@"TARGET_TYPE_COMMENT"]) {
        WQCommentDetailsViewController * vc = [[WQCommentDetailsViewController alloc] init];
        vc.type = CommentDetailTypeMoment;
        vc.commentId = self.model.targetid;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    
    if ([_model.targettype isEqualToString:@"TARGET_TYPE_CHOICEST_COMMENT"]) {
        WQCommentDetailsViewController * vc = [[WQCommentDetailsViewController alloc] init];
        vc.type = CommentDetailTypeEssence;
        vc.commentId = self.model.targetid;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

- (void)showDetail {
    
    //    新的以type开头旧的不以type开头暂时判断结尾如果再有改动再修改
    if([self.model.targettype hasSuffix:@"TYPE_MOMENT_STATUS"]) {
        //        回复万圈进入万圈详情
//        WQparticularsViewController * vc = [[WQparticularsViewController alloc] initWithmId:self.model.targetid];
        WQdynamicDetailsViewConroller *vc = [[WQdynamicDetailsViewConroller alloc] init];
        vc.mid = self.model.targetid;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    } else if([self.model.targettype isEqualToString:@"TARGET_TYPE_GROUP_TOPIC"]){
        //        回复主题进入主题详情
        WQTopicDetailController * vc = [[WQTopicDetailController alloc] init];
        vc.tid = self.model.targetid;
        vc.detailType = TopicDetailTypeFromMessage;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    } else if([self.model.targettype isEqualToString:@"TARGET_TYPE_GROUP_TOPIC_POST"]) {
        //        回复评论进入评论详情
        
        WQCommentDetailController * vc = [[WQCommentDetailController alloc] init];
        vc.pid = self.model.targetid;
        vc.isNeedsVC = NO;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    } else if([self.model.targettype isEqualToString:@"TARGET_TYPE_CHOICEST_ARTICLE"]) {
        WQEssenceDetailController * vc = [[WQEssenceDetailController alloc] init];
        WQEssenceModel * model = [WQEssenceModel new];
        model.id = self.model.targetid;
        model.favorited = NO;
        vc.model = model;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    
    
    
    if ([_model.targettype isEqualToString:@"TARGET_TYPE_COMMENT"]) {
        WQCommentDetailsViewController * vc = [[WQCommentDetailsViewController alloc] init];
        vc.type = CommentDetailTypeMoment;
        vc.commentId = self.model.targetid;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    
    if ([_model.targettype isEqualToString:@"TARGET_TYPE_CHOICEST_COMMENT"]) {
        WQCommentDetailsViewController * vc = [[WQCommentDetailsViewController alloc] init];
        vc.type = CommentDetailTypeEssence;
        vc.commentId = self.model.targetid;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    
    // 需求一级评论
    if ([self.model.targettype isEqualToString:@"TARGET_TYPE_NEED"]) {
        WQdetailsConrelooerViewController *vc = [[WQdetailsConrelooerViewController alloc]initWithmId:self.model.targetid wqOrderType:WQHomePushToDetailsVc];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    
    // 需求二级评论
    if ([self.model.targettype isEqualToString:@"TARGET_TYPE_NEED_COMMENT"]){
        WQdetailsConrelooerViewController *vc = [[WQdetailsConrelooerViewController alloc]initWithmId:self.model.targetOperation.neeID wqOrderType:WQHomePushToDetailsVc];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
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

- (void)picOnTap:(UIImageView *)sender {
    WQPhotoBrowser * browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
    browser .currentPhotoIndex = 0;
    browser.alwaysShowControls = NO;
    
    browser.displayActionButton = NO;
    
    browser.shouldTapBack = YES;
    
    browser.shouldHideNavBar = YES;
    
    [self.viewController.navigationController pushViewController:browser animated:YES];
}


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSURL * url = [NSURL URLWithString:WEB_IMAGE_LARGE_URLSTRING(_model.pic[0])];
    MWPhoto * photo = [MWPhoto photoWithURL:url];
    
    return photo;
}

@end
