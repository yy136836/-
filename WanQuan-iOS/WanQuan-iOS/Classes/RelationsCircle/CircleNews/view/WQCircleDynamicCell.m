//
//  WQCircleDynamicCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQCircleDynamicCell.h"
#import "WQUserProfileController.h"
#import "WQparticularsViewController.h"
#import "WQTopicDetailController.h"
#import "WQCommentDetailController.h"
#import "YYLabel+WQGhLabel.h"
#import "WQdynamicDetailsViewConroller.h"

@interface WQCircleDynamicCell ()
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
@property (retain, nonatomic)  UILabel *timeLabel;
@property (retain, nonatomic)  UIButton *replyButton;
@property (nonatomic, retain)  UIView * sep;

@end


@implementation WQCircleDynamicCell

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
    _avatar.layer.cornerRadius = 20;
    _avatar.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatar];
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
    _topicInfoShowLabel.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.contentView addSubview:_topicInfoShowLabel];
    _topicInfoShowLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _topicInfoShowLabel.font = [UIFont systemFontOfSize:14];
    
    
    _commentImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_commentImage];
    _commentImage.contentMode = UIViewContentModeScaleAspectFill;
    
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
    
    
    _sep = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_sep];
    _sep.backgroundColor = HEX(0xeeeeee);
    
}

- (void)setupConstraints {
    
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@15);
        make.height.width.equalTo(@40);
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatar.mas_right).offset(10);
        make.top.equalTo(_avatar.mas_top).offset(2);
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
    
    [_topicInfoShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth - 70));
        make.left.equalTo(_userName);
        make.top.equalTo(_commentLabel.mas_bottom).offset(10);
        make.height.mas_greaterThanOrEqualTo(@34);
    }];
    
    
    
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_actionLabel);
        make.top.equalTo(_topicInfoShowLabel.mas_bottom).offset(10);
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
                        options:YYWebImageOptionProgressive];
    _addHeight = 0;
    _userName.text = model.user_name;
    _actionLabel.text = [NSString stringWithFormat:@"%@",model.title];
    _commentLabel.text = model.content;
    NSTimeInterval interval = model.posttime_pastseconds.doubleValue;
    
    _timeLabel.text = [self descOfTimeInterval:interval];
    //    targetid的类型：TARGET_TYPE_MOMENT_STATUS=万圈状态； TARGET_TYPE_NEED=需求； TARGET_TYPE_GROUP=圈子； TARGET_TYPE_GROUP_TOPIC=圈子主题；
    _replyButton.hidden = !([self.model.targettype isEqualToString:@"TARGET_TYPE_GROUP_TOPIC"]||
                            [self.model.targettype isEqualToString:@"TARGET_TYPE_GROUP_TOPIC_POST"]);
    

    
    CGSize size = [ _commentLabel sizeThatFits:CGSizeMake(kScreenWidth - 75, MAXFLOAT)];
    
    
    [_commentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth - 70));
        make.top.equalTo(_avatar.mas_bottom).offset(5);
        make.left.equalTo(_actionLabel);
        make.height.offset(size.height);
    }];
    
    
    
    if (size.height > 20) {
        _addHeight = size.height - 20 + 10;
    }
    
    _topicInfoShowLabel.text = model.subject.length? model.subject:@"我的动态";
    
    [_topicInfoShowLabel changeLineSpaceForLabel:_topicInfoShowLabel WithSpace:10];
    
    size = [_topicInfoShowLabel sizeThatFits:CGSizeMake(kScreenWidth - 70, MAXFLOAT)];
    

//    UILabel

    CGFloat lines =  (size.height - 12)  / (_topicInfoShowLabel.font.lineHeight + 10);
    
//    NSLog(@"%@ ------- %lf-------%lf",model.subject,_topicInfoShowLabel.font.lineHeight,lines);
    
    
    if (lines <= 1) {
        
        
        _addHeight += 0;
        //        NSLog(@"%@",model.subject);
        
    } else if (lines <= 2 ) {
        _addHeight += _topicInfoShowLabel.font.lineHeight;;
        //        NSLog(@"");
        
    } else {
        _addHeight += (_topicInfoShowLabel.font.lineHeight + 10) * 2;
        
    }
    
    

    
    if (model.pic.count) {
        
    /**
     TODOhanyang

     @return void
     */
        
        
        
//        [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:WEB_IMAGE_URLSTRING(model.pic[0])] options:YYWebImageOptionProgressive progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            
//        } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
//            return nil;
//        } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                CGFloat picHeight = 0;
//                CGFloat picWidth = 0;
//                
//                CGFloat width = image.size.width;
//                CGFloat height = image.size.height;
//                
//                CGFloat factor = width / height;
//                
//                CGFloat minFactor = 0.75;
//                CGFloat macFactor = 1.33;
//                CGFloat maxLengthOfSide = 200;
//                CGFloat minLengthOfSide = 150;
//                
//                
//                
//                if (factor < minFactor) {
//                    picHeight = maxLengthOfSide;
//                    picWidth = minLengthOfSide;
//                } else if (factor > macFactor) {
//                    picWidth = minLengthOfSide;
//                    picHeight = maxLengthOfSide;
//                } else {
//                    picHeight = maxLengthOfSide;
//                    picWidth = maxLengthOfSide;
//                }
//                
//                NSMutableAttributedString * att = _topicInfoShowLabel.attributedText.mutableCopy;
//                NSTextAttachment * atta = [[NSTextAttachment alloc] init];
//                atta.image = image;
//                atta.bounds = CGRectMake(0, 0, picWidth, picHeight);
//                
//                _topicInfoShowLabel.contentMode = UIViewContentModeScaleAspectFill;
//                
//                [att appendAttributedString:[NSAttributedString attributedStringWithAttachment:atta]];
//                
//                _topicInfoShowLabel.attributedText = att;
//                
//                _addHeight += (picHeight + 10);
//                
//                
//                
//                [_topicInfoShowLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.width.equalTo(@(kScreenWidth - 70));
//                    make.left.equalTo(_userName);
//                    make.top.equalTo(_commentLabel.mas_bottom).offset(5);
//                    make.height.equalTo(@(_addHeight + 30));
//                    make.bottom.equalTo(self.contentView).offset(-10);
//                }];
//                
//            });
        
            
            
//        }];
    }
    //        else {
    
    [_topicInfoShowLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth - 70));
        make.left.equalTo(_userName);
        make.top.equalTo(_commentLabel.mas_bottom).offset(5);
        make.height.equalTo(@(_addHeight + 30));
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    //    }
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




@end
