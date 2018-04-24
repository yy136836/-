//
//  WQTopicImagesCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTopicImagesCell.h"

@interface WQTopicImagesCell ()

@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;


@end

@implementation WQTopicImagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picOntap)];
    [_topicImageView addGestureRecognizer:tap];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WQImageInfoModel *)model {
    _model = model;
    [_topicImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_URLSTRING(self.model.imageId)] options:YYWebImageOptionProgressive];
}


- (void)picOntap {
    if (self.ontap) {
        self.ontap();
    }
}


@end
