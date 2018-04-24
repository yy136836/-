//
//  WQpublishTwoTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/22.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQpublishTwoTableViewCell.h"
#import "WQpublishModel.h"
#import "WQpublishViewController.h"

@interface WQpublishTwoTableViewCell ()
@end

@implementation WQpublishTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setPublishModel:(WQpublishModel *)publishModel
{
    _publishModel = publishModel;
    self.publishTwoLabel.text = publishModel.WQsendNeeds;
    //[self.publishTwoBtn setImage:[UIImage imageNamed:publishModel.WQimageNeeds] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
