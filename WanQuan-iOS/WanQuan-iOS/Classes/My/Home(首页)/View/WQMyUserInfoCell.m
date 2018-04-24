//
//  WQMyUserInfoCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQMyUserInfoCell.h"

@interface WQMyUserInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *workingCompany;
@property (weak, nonatomic) IBOutlet UIButton *confimButton;

@end


@implementation WQMyUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _avatar.layer.cornerRadius = 27;
    _avatar.layer.masksToBounds = YES;
    _confimButton.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontap)]];
    _confimButton.showsTouchWhenHighlighted = NO;
    _confimButton.adjustsImageWhenHighlighted = NO;
    
}



- (IBAction)goConfim:(id)sender {
    
    if ([self.model.idcard_status isEqualToString:@"STATUS_UNVERIFY"]) {
        if (self.confimOnclick) {
            self.confimOnclick();
        }
    }
}

- (void)ontap {
    
}

- (void)setModel:(WQUserProfileModel *)model {
    
    _model = model;
    
    [_avatar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    _userName.text = model.true_name;
//    _graduationSchool.text = model.tag[0];
    _workingCompany.text = [model.tag count] ? model.tag[0] : @"";
    /**
     当前用户的认证状态实名认证状态：
     STATUS_UNVERIFY=未实名认证；
     STATUS_VERIFIED=已实名认证；
     STATUS_VERIFING=已提交认证正在等待管理员审批
     */
    _confimButton.hidden = [model.idcard_status isEqualToString:@"STATUS_VERIFIED"];
    
    if (![model.idcard_status isEqualToString:@"STATUS_VERIFIED"]) {
        
        if ([model.idcard_status isEqualToString:@"STATUS_UNVERIFY"]) {
            [_confimButton setImage:[UIImage imageNamed:@"woyaoshimingrenzheng"] forState:UIControlStateNormal];
        }
        
        if ([model.idcard_status isEqualToString:@"STATUS_VERIFING"]) {
            [_confimButton setImage:[UIImage imageNamed:@"dengdaihoutaishenhe"] forState:UIControlStateNormal];
        }
    }
}

@end
