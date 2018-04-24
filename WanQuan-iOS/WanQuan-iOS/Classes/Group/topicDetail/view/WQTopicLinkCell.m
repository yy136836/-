//
//  WQTopicLinkCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTopicLinkCell.h"

@interface WQTopicLinkCell ()
@property (weak, nonatomic) IBOutlet UIView *linkBG;
@property (weak, nonatomic) IBOutlet UIImageView *linkImage;
@property (weak, nonatomic) IBOutlet UILabel *linkTitle;

@end

@implementation WQTopicLinkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _linkBG.layer.borderColor = HEX(0xeeeeee).CGColor;
    _linkBG.layer.borderWidth = 0.5;
    
}

- (void)setModel:(WQTopicLinkModel *)model {
    _model = model;
    _linkTitle.text = model.link_txt;
    _linkImage.clipsToBounds = YES;
    [_linkImage yy_setImageWithURL:[NSURL URLWithString:model.link_img] placeholder:[UIImage imageNamed:@"lianjie占位图"]];
}

@end
