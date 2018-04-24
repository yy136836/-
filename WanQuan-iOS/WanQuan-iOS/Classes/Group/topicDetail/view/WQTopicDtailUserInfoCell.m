//
//  WQTopicDtailUserInfoCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTopicDtailUserInfoCell.h"
#import "WQUserProfileController.h"

@interface WQTopicDtailUserInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
// 信用分
@property (weak, nonatomic) IBOutlet UIButton *creditButton;
// 好友
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;


@end

@implementation WQTopicDtailUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _avatar.backgroundColor = [UIColor lightGrayColor];
    _avatar.layer.cornerRadius = 23.5;
    _avatar.layer.masksToBounds = YES;
    [_avatar addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(avatarOntap)]];
    _degreeLabel.layer.cornerRadius = 2;
    _degreeLabel.layer.masksToBounds = YES;
    _creditButton.layer.cornerRadius = 2;
    _creditButton.layer.masksToBounds = YES;
    _creditButton.imageView.contentMode = UIViewContentModeCenter;
}

- (void)setModel:(WQTopicModel *)model {
    _model = model;
    
    [_avatar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)] options:YYWebImageOptionProgressive];
    _userNameLabel.text = model.user_name?:@"用户名";
    _postTimeLabel.text = model.createtime?:@"时间";
    _topicTitleLabel.text = model.subject?:@"主题";
    _topicConttentLabel.attributedText = [self getAttributedStringWithString:model.content lineSpace:5];
//    _creditButton setTitle:model forState:
    [_creditButton setTitle:[NSString stringWithFormat:@"%@分",model.user_creditscore] forState:UIControlStateNormal];
    // MARK: 测试
//    [_creditButton setTitle:@"100分" forState:UIControlStateNormal];
    if ([_creditButton.currentTitle isEqualToString:@"100分"]) {
        [_creditButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@47);
        }];
    }

    
    NSString * degreeStr ;
    
    NSInteger degree = model.user_degree.integerValue;
    if (degree == 0) {
        degreeStr = @"自己";
    }else if (degree <= 2) {
         degreeStr = @"2度内好友";
    } else if (degree == 3){
        degreeStr = @"3度好友";
    } else {
         degreeStr = @"4度外好友";
    }
    
    
    
    _degreeLabel.text = degreeStr;
    CGSize size = [_degreeLabel sizeThatFits:CGSizeMake(kScreenWidth, MAXFLOAT)];
    
    [_degreeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_creditButton.mas_right).offset(10);
        make.height.equalTo(_creditButton.mas_height);
        make.width.width.equalTo(@(size.width + 10));
    }];
    
}



- (void)avatarOntap {
    
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

- (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    return attributedString;
}

@end
