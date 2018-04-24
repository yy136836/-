//
//  WQGroupListCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupListCell.h"

@interface WQGroupListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupLabelName;
@property (weak, nonatomic) IBOutlet UILabel *GroupTitleLabel;

@end

@implementation WQGroupListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _avatarImageView.layer.cornerRadius = 5;
    _avatarImageView.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}



@end
