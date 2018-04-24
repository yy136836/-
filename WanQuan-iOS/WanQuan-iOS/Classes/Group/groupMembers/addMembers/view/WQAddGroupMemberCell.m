//
//  WQAddGroupMemberCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQAddGroupMemberCell.h"


@interface WQAddGroupMemberCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation WQAddGroupMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _avatar.layer.cornerRadius = 5;
    _avatar.layer.masksToBounds = YES;
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setModel:(WQfriend_listModel *)model {
    _model = model;
    self.nameLabel.text = model.true_name;
    [self.avatar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)] options:YYWebImageOptionProgressive];
}


- (void)setGroupMemberModel:(WQGroupMemberModel *)groupMemberModel {
    _groupMemberModel = groupMemberModel;
    self.nameLabel.text = groupMemberModel.user_name;
    [self.avatar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(groupMemberModel.user_pic)] options:YYWebImageOptionProgressive];
    
    
}
@end
