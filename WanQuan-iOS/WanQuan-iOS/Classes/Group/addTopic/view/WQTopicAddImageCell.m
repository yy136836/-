//
//  WQTopicAddImageCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTopicAddImageCell.h"

@interface WQTopicAddImageCell ()


@end



@implementation WQTopicAddImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _showingImage.clipsToBounds = YES;
    _showingImage.layer.cornerRadius = 5;
    _showingImage.layer.masksToBounds = YES;
}

@end
