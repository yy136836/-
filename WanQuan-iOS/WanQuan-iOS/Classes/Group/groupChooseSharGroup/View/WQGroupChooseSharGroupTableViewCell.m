//
//  WQGroupChooseSharGroupTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupChooseSharGroupTableViewCell.h"
#import "WQGroupModel.h"

@interface WQGroupChooseSharGroupTableViewCell ()
// 群头像
@property (weak, nonatomic) IBOutlet UIImageView *groupPic;
// 群名称
@property (weak, nonatomic) IBOutlet UILabel *groupName;
// 主题
@property (weak, nonatomic) IBOutlet UILabel *groupSubject;
@end

@implementation WQGroupChooseSharGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.groupPic.contentMode = UIViewContentModeScaleAspectFill;
    self.groupPic.layer.cornerRadius = 25;
    self.groupPic.layer.masksToBounds = YES;
}

- (void)setModel:(WQGroupModel *)model {
    NSString *picUrl = [imageUrlString stringByAppendingString:model.pic];
    [self.groupPic yy_setImageWithURL:[NSURL URLWithString:picUrl] options:YYWebImageOptionShowNetworkActivity];
    self.groupName.text = model.name;
// MARK: test
//    self.groupName.text = @"dfalsdfalksdhflkadnfsdnf,kfnadfnladfnklasdnfklasdfnaksdfnaklsdfnasldf";
    self.groupSubject.text = model.latest_topic_name;
}

@end
