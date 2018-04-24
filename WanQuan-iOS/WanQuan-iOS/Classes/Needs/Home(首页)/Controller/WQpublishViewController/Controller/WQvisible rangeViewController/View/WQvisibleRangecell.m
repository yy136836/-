//
//  WQvisibleRangecell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/24.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQvisibleRangecell.h"
#import "WQvisibleRangeModel.h"
#import "WQvisibleRangeViewController.h"

@interface WQvisibleRangecell() 

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation WQvisibleRangecell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setVisibleRangemodel:(WQvisibleRangeModel *)visibleRangemodel
{
    _visibleRangemodel = visibleRangemodel;
    self.nameLabel.text = visibleRangemodel.visualRangeName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
