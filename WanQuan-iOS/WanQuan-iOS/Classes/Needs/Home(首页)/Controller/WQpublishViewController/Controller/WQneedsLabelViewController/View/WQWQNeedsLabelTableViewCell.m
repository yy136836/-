//
//  WQWQNeedsLabelTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/26.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQWQNeedsLabelTableViewCell.h"
#import "WQNeedsLabelModel.h"

@implementation WQWQNeedsLabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setNeedsLabelModel:(WQNeedsLabelModel *)needsLabelModel
{
    _needsLabelModel = needsLabelModel;
    self.propellingXml.text = needsLabelModel.propellingXml;
}

- (IBAction)deleteBtnClike:(UIButton *)sender {
    if (self.ClikeBlock != nil) {
        self.ClikeBlock();
    }
}

@end
