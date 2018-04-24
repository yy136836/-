//
//  WQMySetupTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQMySetupTableViewCell.h"
#import "WQMySetupModel.h"

@interface WQMySetupTableViewCell() 
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@end

@implementation WQMySetupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setModel:(WQMySetupModel *)model {
    _model = model;
    [self.image setImage:[UIImage imageNamed:model.image]];
    self.title.text = model.title;
}

@end
