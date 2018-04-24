//
//  WQPendingNewFriendCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/29.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQPendingNewFriendCell.h"
#import "WQUserProfileController.h"
@interface WQPendingNewFriendCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;

@property (weak, nonatomic) IBOutlet UIButton *userCriditButton;
@property (weak, nonatomic) IBOutlet UILabel *friendDegreeLabel;


@end


@implementation WQPendingNewFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _acceptBtn.layer.masksToBounds = YES;
    _acceptBtn.layer.cornerRadius = 5;
//    _acceptBtn.layer.borderWidth = 1;
    _acceptBtn.layer.backgroundColor = WQ_LIGHT_PURPLE.CGColor;
    _avatar.layer.cornerRadius = 22;
    _avatar.userInteractionEnabled = YES;
    [_avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontap)]];
    _userCriditButton.layer.cornerRadius = 2;
    _userCriditButton.layer.masksToBounds = YES;
}

- (void)setModel:(WQPendingNewFriendModel *)model {
    _model = model;
    [_avatar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)] placeholder:[UIImage imageWithColor:HEX(0xededed)]];
    _userNameLabel.text = model.true_name;
    [_acceptBtn addTarget:self action:@selector(acceptNewFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
    
    _detailLabel.text = model.friend_apply_message;
    [_userCriditButton setTitle:[NSString stringWithFormat:@"%@分",model.creditscore] forState:UIControlStateNormal];
    
    
    NSInteger degree = model.degree.integerValue;
    NSString * degreeText;
    if (degree == 0) {
        degreeText = @"自己";
    }else if (degree <= 2) {
        degreeText = @"2度内好友";
    } else if (degree == 3){
        degreeText = @"3度好友";
    } else {
        degreeText = @"4度外好友";
    }
    _friendDegreeLabel.text = degreeText;
   CGSize size = [_friendDegreeLabel sizeThatFits:CGSizeMake(0, 14)];
    _friendDegreeLabel.frame = CGRectMake(_friendDegreeLabel.x, _friendDegreeLabel.y, size.width + 5, 14);
}

- (void)acceptNewFriendRequest:(UIButton *)sender {
//    if (self.acceptFriendRequest) {
//        self.acceptFriendRequest(_model.friend_apply_id);
////    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(WQPendingNewFriendCell: accceptFriendRequestBtnClicked:)]) {
        [self.delegate WQPendingNewFriendCell:self accceptFriendRequestBtnClicked:sender];
    }
}

- (void)ontap {
    
    // 是当前账户
    
    WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:self.model.user_id];
    vc.fromFriendRequest = YES;
    vc.requestInfo = _model.friend_apply_message;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}

@end
