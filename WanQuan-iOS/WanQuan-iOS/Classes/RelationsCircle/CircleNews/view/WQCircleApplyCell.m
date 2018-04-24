//
//  WQCircleApplyCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQCircleApplyCell.h"

@interface WQCircleApplyCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepHeight;

@end

@implementation WQCircleApplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _redDot.layer.cornerRadius = 5;
    _redDot.layer.masksToBounds = YES;
    _sepHeight.constant = 0.5;
    _redDot.hidden = YES;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





@end
