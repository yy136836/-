//
//  WQUserProfileJoinedGroupLabel.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUserProfileJoinedGroupCell.h"
#import "WQGroupSwitchDataEntity.h"

@interface WQUserProfileJoinedGroupCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;



@end


@implementation WQUserProfileJoinedGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _avatar.layer.cornerRadius = 3;
    _avatar.layer.masksToBounds = YES;
    [_showSwitch addTarget:self action:@selector(switchStateChange:withEvent:)
          forControlEvents:UIControlEventValueChanged];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sholdOffSwitch:)
                                                 name:WQUserProfileMainSwitchDidOffNoti
                                               object:nil];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WQUserProfileGroupModel *)model {
    _model = model;
    [_avatar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_MIDDLE_URLSTRING(model.pic)]
                        placeholder:[UIImage imageNamed:@"zhanweitu"]];
    _groupNameLabel.text = model.name;
    _showSwitch.on = model.public_show;
}

- (void)switchStateChange:(WQSwitch *)sender withEvent:(UIEvent *)event {
    
    if(!sender.beOnWithNoti) {
        WQUserProfileGroupModel * model = [[WQUserProfileGroupModel alloc] init];
        model.gid = _model.gid;
        model.public_show = sender.on;
        [[WQGroupSwitchDataEntity sharedEntity] updateGroupSwitchStatusWith:@[model]];
    }
    
    if (sender.on && (!sender.beOnWithNoti)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WQUserProfileSubSwitchOnNoti
                                                            object:nil];
    }
    if (!sender.on) {
        _model.public_show = _showSwitch.on;
    }
    
    if (self.makePublic) {
        self.makePublic(sender.on , _showSwitch);
    }
    sender.beOnWithNoti = NO;
}

- (void)sholdOffSwitch:(NSNotification *)noti {
    UISwitch * switch1 = noti.object;
    if (!switch1.on) {
        _showSwitch.on = NO;
        _showSwitch.beOnWithNoti = NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:WQUserProfileMainSwitchDidOffNoti
                                                  object:nil];
}
@end
