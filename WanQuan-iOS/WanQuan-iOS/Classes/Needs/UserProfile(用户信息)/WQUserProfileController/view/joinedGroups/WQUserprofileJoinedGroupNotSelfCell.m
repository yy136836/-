//
//  WQUserprofileJoinedGroupNotSelfCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUserprofileJoinedGroupNotSelfCell.h"

@interface WQUserprofileJoinedGroupNotSelfCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *groupName;

@property (weak, nonatomic) IBOutlet UILabel *groupDes;

@end


@implementation WQUserprofileJoinedGroupNotSelfCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _avatar.layer.cornerRadius = 3;
    _avatar.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(WQUserProfileGroupModel *)model {
    // TODO: 设置数据
    _model = model;
    [_avatar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    _groupName.text = model.name;
    _groupDes.text = model.desc;
}


@end
