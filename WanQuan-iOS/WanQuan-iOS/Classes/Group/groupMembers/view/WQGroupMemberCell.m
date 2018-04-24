//
//  WQGroupMemberCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupMemberCell.h"

@interface WQGroupMemberCell ()

@property (weak, nonatomic) IBOutlet UILabel *quanzhuLabel;
@property (weak, nonatomic) IBOutlet UILabel *guanliyuanLabel;

@end



@implementation WQGroupMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.quanzhuLabel.layer.cornerRadius = 2;
    self.quanzhuLabel.layer.masksToBounds = YES;
    self.quanzhuLabel.hidden = YES;
    self.guanliyuanLabel.layer.cornerRadius = 2;
    self.guanliyuanLabel.layer.masksToBounds = YES;
    self.guanliyuanLabel.hidden = YES;
    
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
    _avatar.layer.cornerRadius = 25;
    _avatar.layer.masksToBounds = YES;
    _avatar.image = nil;
    _userNameLabel.text = @"";
    _avatar.image = [UIImage imageWithColor: [UIColor lightGrayColor]];
}

- (void)setModel:(WQGroupMemberModel *)model {
    _model = model;
    
    UIImage * placeHolderImage;
    UIColor * userNameColor;
    
    if (model.user_virtual) {
        placeHolderImage = [UIImage imageNamed:@""];
        userNameColor = HEX(0x999999);
    } else {
        placeHolderImage = [UIImage imageNamed:@"zhanweitu"];
        userNameColor = HEX(0x666666);
    }
    [_avatar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)] placeholder:placeHolderImage];

    _userNameLabel.textColor = userNameColor;
    _userNameLabel.text = model.user_name;
    
    // 是管理员
    if ([model.isAdmin boolValue]) {
        // 是圈主
        if ([model.isOwner boolValue]) {
            self.quanzhuLabel.hidden = NO;
            self.guanliyuanLabel.hidden = YES;
            
            [self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.avatar.mas_centerX);
                make.top.equalTo(self.quanzhuLabel.mas_bottom).offset(4);
            }];
        }else {
            // 是管理员
            self.quanzhuLabel.hidden = YES;
            self.guanliyuanLabel.hidden = NO;
            
            [self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.avatar.mas_centerX);
                make.top.equalTo(self.guanliyuanLabel.mas_bottom).offset(4);
            }];
        }
    }else {
        // 不是管理员
        self.quanzhuLabel.hidden = YES;
        self.guanliyuanLabel.hidden = YES;
        
        [self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.avatar.mas_centerX);
            make.top.equalTo(self.avatar.mas_bottom).offset(ghStatusCellMargin);
        }];
    }
}

@end
