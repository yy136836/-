//
//  WQParticularCommentCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/30.
//  Copyright © 2017年 WQ. All rights reserved.
//

#define kNotFriendLink @"notFriend"

#import "WQParticularCommentCell.h"
#import "WQUserProfileController.h"

@interface WQParticularCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avartar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTimelabel;
@property (weak, nonatomic) IBOutlet UILabel *commentlabel;
@property (weak, nonatomic) IBOutlet UIButton *creditButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

/**
 实际显示的详情
 */
@property (nonatomic, retain) YYLabel * showCommentlabel;

@end

@implementation WQParticularCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _avartar.layer.masksToBounds = YES;
    _avartar.layer.cornerRadius = 20;
    _creditButton.layer.cornerRadius = 2;
    _avartar.userInteractionEnabled = YES;
    _creditButton.layer.masksToBounds = YES;
    [_avartar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontap)]];

}

- (IBAction)commetOnclick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(particularCommentCellReplyTo:)]) {
        [self.delegate particularCommentCellReplyTo:self.model];
    }
}

- (void)setModel:(WQcommentListModel *)model {
    
    if (!model.reply_user_name.length) {
        model.reply_user_name = @"好友的好友";
    }
    _model = model;

    if (self.showCommentlabel) {
        [self.showCommentlabel removeFromSuperview];
    }
    
//    if (model.reply_user) {
//        _commentButton.hidden = YES;
//    } else {
//        _commentButton.hidden = NO;
//    }
    
    
    [_avartar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)] options:YYWebImageOptionProgressive];
    _userNameLabel.text = model.user_name;
//    TODOHanyang 接入信用分
//    [_creditButton setTitle:[NSString stringWithFormat:@"%@分",model.] forState:<#(UIControlState)#>]
    _postTimelabel.text = [NSDate WQDescriptionBeforWithPastSecond:model.past_second];
    
    _commentlabel.text = model.content;
    
    _commentlabel.hidden = YES;
    
    [_creditButton setTitle:[NSString stringWithFormat:@"%@分",model.user_creditscore.stringValue] forState:UIControlStateNormal];
    
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    
    NSDictionary * commenAttribute = @{NSFontAttributeName:_commentlabel.font,
                                       NSForegroundColorAttributeName:_commentlabel.textColor,
                                       NSParagraphStyleAttributeName:style};
    
    NSMutableDictionary * replyerAttibute = @{NSFontAttributeName:_commentlabel.font,
                                       NSForegroundColorAttributeName:HEX(0x9767d0),
                                       NSParagraphStyleAttributeName:style}.mutableCopy;
    
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] init];
    
    _showCommentlabel = [[YYLabel alloc] initWithFrame:CGRectMake(72,
                                                                  _commentlabel.y,
                                                                  kScreenWidth - 80,
                                                                  25)];
    
    _showCommentlabel.numberOfLines = 0;
//    如果不是回复
    if (!self.model.reply_user) {
        if (model.content.length) {
            [att appendAttributedString:[[NSAttributedString alloc] initWithString:model.content attributes:commenAttribute]];
        }
        
    } else {
//    如果是回复

        [att appendAttributedString:[[NSAttributedString alloc] initWithString:@"回复" attributes:commenAttribute]];
//        如果能显示回复人信息
        if (model.reply_user_truename) {
            replyerAttibute[NSLinkAttributeName] = model.reply_user_id;
            
            

        } else {
//            如果不能显示回复人信息
            replyerAttibute[NSLinkAttributeName] = kNotFriendLink;
            
        }
        [att appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: " ,model.reply_user_name] attributes:replyerAttibute]];
        [att appendAttributedString:[[NSAttributedString alloc] initWithString:model.content attributes:commenAttribute]];
        
    }
    
    
    
    
    _showCommentlabel.attributedText = att;
    
    NSRange linkRange = [att.string rangeOfString:[NSString stringWithFormat:@"%@: " ,model.reply_user_name]];
//    [att yy_setTextHighlightRange:linkRange
//                            color:nil
//                  backgroundColor:nil
//                        tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//
//                            NSString * link = replyerAttibute[NSLinkAttributeName];
//
//                            if (!link.length) {
//                                return;
//                            }
//
//                            if ([link isEqualToString:kNotFriendLink]) {
//                                [WQAlert showAlertWithTitle:nil message:@"非好友,无法查看详情" duration:1.3];
//                            } else {
//                                WQUserProfileController * vc = [[WQUserProfileController alloc] initWithUserId:link];
//                                [self.viewController.navigationController pushViewController:vc animated:YES];
//                            }
//
//
//                        }];
    
//    __weak typeof(self) weakself = self;
//    _showCommentlabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//        if ( linkRange.location<=range.location <= linkRange.location + linkRange.length) {
//            NSString * link = replyerAttibute[NSLinkAttributeName];
//            
//            if (!link.length) {
//                return;
//            }
//            
//            if ([link isEqualToString:kNotFriendLink]) {
//                [WQAlert showAlertWithTitle:nil message:@"非好友,无法查看详情" duration:1.3];
//            } else {
//                WQUserProfileController * vc = [[WQUserProfileController alloc] initWithUserId:link];
//                [weakself.viewController.navigationController pushViewController:vc animated:YES];
//            }
//        }
//    };
    
    

    CGSize size = [_showCommentlabel sizeThatFits:CGSizeMake(kScreenWidth - 80, MAXFLOAT)];
//    _showCommentlabel.frame = CGRectMake(_showCommentlabel.x, _showCommentlabel.y, kScreenWidth - 80, size.height);
    [self.contentView addSubview:_showCommentlabel];

    [_showCommentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(_showCommentlabel.x));
        make.top.equalTo(@(_showCommentlabel.y));
        make.width.equalTo(@(kScreenWidth - 80));
        make.height.equalTo(@(size.height));
    }];
}

- (CGFloat)heightWhithModel:(WQcommentListModel *)model {
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    
    NSDictionary * commenAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                       NSForegroundColorAttributeName:_commentlabel.textColor,
                                       NSParagraphStyleAttributeName : style};

    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] init];
    
    YYLabel * lab = [[YYLabel alloc] initWithFrame:CGRectMake(_commentlabel.x, _commentlabel.y, kScreenWidth - 80, 26)];
    lab.numberOfLines = 0;

    if (!model.reply_user) {
        if (model.content.length) {
            [att appendAttributedString:[[NSAttributedString alloc] initWithString:model.content attributes:commenAttribute]];
        }
       
    } else {
        //    如果是回复
        [att appendAttributedString:[[NSAttributedString alloc] initWithString:@"回复" attributes:commenAttribute]];
        [att appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: " ,model.reply_user_name] attributes:commenAttribute]];
        [att appendAttributedString:[[NSAttributedString alloc] initWithString:model.content?:@"" attributes:commenAttribute]];
    }
    
    lab.attributedText = att;
    
    CGSize size = [lab sizeThatFits:CGSizeMake(kScreenWidth - 80, MAXFLOAT)];

    
    
    if (size.height  > 24 ) {
        return 93 + size.height - (24) + 8;
    }
    
    return 93;
}

- (void)ontap {
    
//    if (!_model.reply_user_truename) {
//
//        return;
//    }
    //    if (!_model.reply_user_truename || self) {
    //        return;
    //    }
    
    if ([_model.user_name isEqualToString:@"好友的好友"]) {
        return;
    }
    
    NSString *role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(particularCommentCellshowLogin)]) {
            [self.delegate particularCommentCellshowLogin];
            
        }
        return;
    }
    
    
    
    if (![WQDataSource sharedTool].verified) {
        // 快速注册的用户
        UIAlertController *alertController =
         [UIAlertController alertControllerWithTitle:nil
                                            message:@"实名认证后可查看用户信息"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton =
        [UIAlertAction actionWithTitle:@"取消"
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * _Nonnull action) {
                                   NSLog(@"取消");
                               }];
        UIAlertAction *destructiveButton =
        [UIAlertAction actionWithTitle:@"实名认证"
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
    
    

    
    
    NSString *im_namelogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"im_namelogin"];
    // 是当前账户
    if ([self.model.user_id isEqualToString:im_namelogin]) {
        WQUserProfileController *vc = [[WQUserProfileController alloc] init];
        vc.userId = self.model.user_id;
        vc.selfEditing = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }else {
        WQUserProfileController *vc = [[WQUserProfileController alloc] init];
        vc.userId = self.model.user_id;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}
@end
