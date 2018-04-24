//
//  WQEssencewCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQEssencewCell.h"
#import "WQEssenceArticleModel.h"
@interface WQEssencewCell()
@property (weak, nonatomic) IBOutlet UILabel *essenceTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *essenceImageView;
@property (weak, nonatomic) IBOutlet UILabel *essenceConttent;
@property (weak, nonatomic) IBOutlet UILabel *essenceType;
@property (weak, nonatomic) IBOutlet UILabel *postTime;
@end

@implementation WQEssencewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _essenceImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setModel:(WQEssenceModel *)model {
    _model = model;
    if (!model) {
        _essenceTitleLabel.text = @"一条迷样的道路 一段凌乱的旅途 一直挥不去命运的雾";
        _essenceImageView.image = [UIImage imageNamed:@"红包切图"];
        _essenceConttent.text = @"谁能改变 人生的长度 谁知道永恒有多么恐怖 谁了解生存往往比命运还残酷 只是没有人愿意认输 我们都在不断赶路忘记了出路 在失望中追求偶尔的满足";
        _essenceType.text = @"哲学";
        _postTime.text = @"1天前";
    } else {
        _essenceTitleLabel.text = model.choicest_article.subject;
        _essenceConttent.text = model.choicest_article.desc;
        [_essenceImageView yy_setImageWithURL:[NSURL URLWithString: WEB_IMAGE_LARGE_URLSTRING(model.choicest_article.cover_pic)] options:YYWebImageOptionProgressive];
        _essenceType.text = [model.choicest_article.tags componentsJoinedByString:@"  "];
        _postTime.text = [NSDate WQDescriptionBeforWithPastSecond:model.createtime_past_second];
    }
}

@end
