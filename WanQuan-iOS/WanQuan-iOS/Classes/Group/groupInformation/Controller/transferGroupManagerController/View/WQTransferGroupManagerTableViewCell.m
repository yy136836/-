//
//  WQTransferGroupManagerTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTransferGroupManagerTableViewCell.h"
#import "WQGroupMemberModel.h"

@interface WQTransferGroupManagerTableViewCell () 
@property (weak, nonatomic) IBOutlet UIImageView *touxiang;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation WQTransferGroupManagerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.touxiang.contentMode = UIViewContentModeScaleAspectFill;
    self.touxiang.layer.cornerRadius = self.touxiang.width / 2;
    self.touxiang.layer.masksToBounds = YES;
    self.touxiang.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
    [self.touxiang addGestureRecognizer:tap];
}

- (void)handleTapGes:(UITapGestureRecognizer *)tap {
    if (self.headPortraitViewClickBlock) {
        self.headPortraitViewClickBlock();
    }
}

- (void)setModel:(WQGroupMemberModel *)model {
    _model = model;
    [self.touxiang yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)] placeholder:[UIImage imageNamed:@"tongxunlu"]];
    self.name.text = model.user_name;
}

@end
