//
//  WQShareToFriendCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/7.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQShareToFriendCell.h"

@interface WQShareToFriendCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@end

@implementation WQShareToFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _avatar.layer.cornerRadius = 22;
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
    _avatar.layer.masksToBounds = YES;
}

- (void)setModel:(WQfriend_listModel *)model {
    _model = model;
    _userName.text = model.true_name;
    [_avatar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)] options:YYWebImageOptionProgressive];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _selectedBtn.selected = selected;

}

@end
