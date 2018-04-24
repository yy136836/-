//
//  WQFavoritesCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/10/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQFavoritesCell.h"
@interface WQFavoritesCell()
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIImageView *favorImageView;
@property (weak, nonatomic) IBOutlet UILabel *labFavorConttent;
@property (weak, nonatomic) IBOutlet UILabel *labFavorTag;
@property (weak, nonatomic) IBOutlet UILabel *labFavorCreatTime;

@end
@implementation WQFavoritesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(WQFavoritesModel *)model {
    _model = model;
    [_favorImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.favorite_pic)] options:YYWebImageOptionProgressive];
    _labTitle.text = model.favorite_title;
    _labFavorConttent.text = _model.favorite_desc;
//    TODOHanyang
    _labFavorTag.text = @"";
    _labFavorCreatTime.text = [NSDate WQDescriptionBeforWithPastSecond:model.favorite_createtime];
}


@end
