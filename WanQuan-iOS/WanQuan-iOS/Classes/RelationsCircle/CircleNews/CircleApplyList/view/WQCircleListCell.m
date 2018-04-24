//
//  WQCircleListCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQCircleListCell.h"
#import "WQUserProfileController.h"

@interface WQCircleListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avartar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *creditNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendDegreeLabel;
@property (weak, nonatomic) IBOutlet UIButton *circleNameButton;
@property (weak, nonatomic) IBOutlet UILabel *verifyMessageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *degreeWidth;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creditWidth;

@end

@implementation WQCircleListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _avartar.layer.cornerRadius = 22;
    _avartar.layer.masksToBounds = YES;
    [_avartar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avartarOntap)]];
    
    
    _agreeButton.layer.cornerRadius = 5;
    _agreeButton.layer.masksToBounds = YES;
    
    _friendDegreeLabel.layer.cornerRadius = 2;
    _friendDegreeLabel.layer.masksToBounds = YES;
    _creditNumberLabel.layer.cornerRadius = 2;
    _creditNumberLabel.layer.masksToBounds = YES;

    [_agreeButton setBackgroundImage:[UIImage imageWithColor:WQ_LIGHT_PURPLE] forState:UIControlStateNormal];
    [_agreeButton setBackgroundImage:[UIImage imageWithColor: HEX(0xcbcbcb)] forState:UIControlStateDisabled];
    
    _verifyMessageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
}

- (void)setModel:(WQCircleApplyModel *)model {
    _model = model;
    [_avartar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)] options:YYWebImageOptionProgressive];
    _userName.text = model.user_name;
    
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] init];
    NSTextAttachment * atta = [[NSTextAttachment alloc] init];
    UIImage * img = [UIImage imageNamed:@"shouyexinyongfen"];
//    img = [img imageWithAlignmentRctInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    atta.image = img;
    atta.bounds = CGRectMake(0,-3,12, 14);
    NSAttributedString * attach = [NSAttributedString attributedStringWithAttachment:atta];
    [att appendAttributedString:attach];
    
    
//    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    
    NSString * str = [NSString stringWithFormat:@" %@分",model.user_score];
    
    
    NSAttributedString * number = [[NSAttributedString alloc] initWithString:str
                                                                  attributes:@{NSFontAttributeName:_creditNumberLabel.font,
                                                                               NSForegroundColorAttributeName:WQ_LIGHT_PURPLE}];
    [att appendAttributedString:number];
    
    _creditNumberLabel.attributedText = att;
    CGSize size = [_creditNumberLabel sizeThatFits:CGSizeMake(0, 0)];
//    _creditNumberLabel.frame = CGRectMake(_creditNumberLabel.x, _creditNumberLabel.y, size.width + 5, _creditNumberLabel.height);
//    _creditWidth.constant = size.width + 5;

    _creditNumberLabel.backgroundColor = HEX(0xf4f0ff);
    
//    model.user_degree = @"3";
    NSString * user_degree;
    NSString * friendsString = model.user_degree;
    if ([friendsString integerValue] == 0) {
        user_degree = [@" " stringByAppendingString:[@"自己" stringByAppendingString:@" "]];
    }else if ([friendsString integerValue] <= 2) {
        user_degree = [@" " stringByAppendingString:[@"2度内好友" stringByAppendingString:@" "]];
    }else if ([friendsString integerValue] == 3) {
        user_degree = [@" " stringByAppendingString:[@"3度好友" stringByAppendingString:@" "]];
    }else {
        user_degree = [@" " stringByAppendingString:[@"4度外好友" stringByAppendingString:@" "]];
    }
//    NSString * degree = [NSString stringWithFormat:@"%@%@好友",[model.user_degree intValue] <= 2?model.user_degree:@"2度以上",[model.user_degree intValue] <= 2?@"度":@""];
    _friendDegreeLabel.text = user_degree;
    _friendDegreeLabel.textColor = HEX(0xc9c9c9);
    _friendDegreeLabel.backgroundColor = HEX(0xf5f5f5);
    
    
    [_creditNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width + 5));
    }];
    
    

    
    NSMutableAttributedString * groupName = [[NSMutableAttributedString alloc] init];
    NSDictionary * attr = @{NSFontAttributeName : [UIFont systemFontOfSize:14],NSForegroundColorAttributeName : HEX(0x333333)};
    NSDictionary * attr1 = @{NSFontAttributeName : [UIFont systemFontOfSize:14],NSForegroundColorAttributeName : WQ_LIGHT_PURPLE};
    [groupName appendAttributedString:[[NSAttributedString alloc] initWithString:@"申请加入: " attributes:attr]];
    
    [groupName appendAttributedString:[[NSAttributedString alloc] initWithString:model.group_name  attributes:attr1]];
    
    [_circleNameButton setAttributedTitle:groupName  forState:UIControlStateNormal];
    _circleNameButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _circleNameButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    _circleNameButton.showsTouchWhenHighlighted = NO;
    
    CGRect rect = [groupName.string boundingRectWithSize:CGSizeMake(kScreenWidth - 140, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    
    [_circleNameButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(rect.size.height));
    }];
    
    
    NSMutableAttributedString * verifyInfomation = [[NSMutableAttributedString alloc]init];
    [verifyInfomation appendAttributedString:[[NSAttributedString alloc] initWithString:@"验证消息: " attributes:attr]];
    [verifyInfomation appendAttributedString:[[NSAttributedString alloc] initWithString:model.message attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : _verifyMessageLabel.textColor}]];
    _verifyMessageLabel.attributedText = verifyInfomation;
    if ([model.user_degree intValue] > 2) {
        _degreeWidth.constant = 67;

    } else {
        _degreeWidth.constant = 46;
    }
    
}


-(void)avartarOntap {
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
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:self.model.user_id];
//        vc.ismyaccount = YES;
        vc.selfEditing = YES;
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }else {
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:self.model.user_id];
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }
    
}
- (IBAction)circleNameOnclick:(id)sender {
    if (self.circleNameOnclick) {
        self.circleNameOnclick();
    }
}

- (IBAction)agreeOnclick:(id)sender {
    UIButton * btn = sender;
    if (!btn.isEnabled) {
        return;
    }
    if (self.agreeOnclick) {
        self.agreeOnclick(btn);
    }
}
@end
