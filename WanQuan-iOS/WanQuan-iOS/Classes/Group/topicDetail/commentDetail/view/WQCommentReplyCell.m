//
//  WQCommentReplyCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/16.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQCommentReplyCell.h"
#import "WQUserProfileController.h"
#import <NSAttributedString+YYText.h>
#import "NSDate+Category.h"
@interface WQCommentReplyCell ()<UITextViewDelegate,YYTextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyDeleteBtn;

@end

@implementation WQCommentReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _avatar.layer.cornerRadius = 15;
    _avatar.layer.masksToBounds = YES;
    [_avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
    
    _commentTextVIew = [[YYTextView alloc] init];
    [self.contentView addSubview:_commentTextVIew];
    _commentTextVIew.selectable = YES;
    _commentTextVIew.frame = CGRectMake(_postTimeLabel.x, _postTimeLabel.height + _postTimeLabel.y ,kScreenWidth - _postTimeLabel.x - 10, 10);
    
    _commentTextVIew.editable = NO;
    _commentTextVIew.delegate = self;
    _commentTextVIew.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    
    
}

- (void)setModel:(WQGroupReplyModel *)model {
    _model = model;
    
    _replyDeleteBtn.hidden =! model.canDelete;
    
    [_avatar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)]
                        options:YYWebImageOptionProgressive];
    _userNameLabel.text = model.user_name?:@"名字";
    NSString * time = [NSDate WQDescriptionBeforWithPastSecond:model.past_second];
    _postTimeLabel.text = time;
    
    UIFont * font = [UIFont systemFontOfSize:13];
    UIColor * linkColor = WQ_LIGHT_PURPLE;
    UIColor * commenColor = [UIColor colorWithHex:0x333333];
    
    //    NSDictionary * userNameAttr = @{
    //                                    NSForegroundColorAttributeName:linkColor,
    //                                    NSLinkAttributeName:model.user_id
    //                                    };
    
    NSDictionary * replyNameAttr = @{
                                     NSForegroundColorAttributeName:linkColor,
                                     NSLinkAttributeName:model.reply_user_id?:@"",
                                     NSFontAttributeName:font
                                     };
    
    NSDictionary * commonAttr = @{
                                  NSForegroundColorAttributeName:commenColor,
                                  NSFontAttributeName:font
                                  };
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:@"" attributes:commonAttr];
    
    if (model.reply) {
        NSString * replyName = [NSString stringWithFormat:@"@%@:",model.reply_user_name];
        
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:replyName attributes:replyNameAttr]];
    }
    
    [attr yy_setTextHighlightRange:NSMakeRange(0, attr.length)
                             color:nil
                   backgroundColor:nil
                         tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                             WQUserProfileController * vc = [[WQUserProfileController alloc] initWithUserId:self.model.user_id];
                             [self.viewController.navigationController pushViewController:vc animated:YES];
                         }];
    
    NSString * content = model.content.length ? model.content : @"";
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:content  attributes:commonAttr]];
    
    [attr yy_setTextHighlightRange:NSMakeRange(attr.length - content.length, content.length)
                             color:nil
                   backgroundColor:nil
                         tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                             if (self.select) {
                                 self.select(self);
                             }
                         }];
    
    
    
    
    _commentTextVIew.attributedText = attr;
    
    _commentTextVIew.textContainerInset = UIEdgeInsetsMake(_commentTextVIew.textContainerInset.top,
                                                           0,
                                                           _commentTextVIew.textContainerInset.bottom,
                                                           _commentTextVIew.textContainerInset.right);
    
    _commentTextVIew.frame = CGRectMake(_commentTextVIew.x, _commentTextVIew.y, _commentTextVIew.width, _commentTextVIew.contentSize.height);
    _commentTextVIew.delegate = self;
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    WQUserProfileController * vc = [[WQUserProfileController alloc] initWithUserId:URL.absoluteString];
    
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
    return NO;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)onTap {
    
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
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:im_namelogin];
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }else {
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:self.model.user_id];
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)textView:(YYTextView *)textView shouldLongPressHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange {
    return YES;
}
- (void)textView:(YYTextView *)textView didLongPressHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect {
    
}
- (IBAction)deleteReply:(id)sender {
    if (self.deleteReply) {
        self.deleteReply(_model);
    }
}

@end
