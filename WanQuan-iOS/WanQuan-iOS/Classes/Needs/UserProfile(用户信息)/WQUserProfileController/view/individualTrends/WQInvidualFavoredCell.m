//
//  WQInvidualFavoredCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQInvidualFavoredCell.h"

@interface WQInvidualFavoredCell()
@property (weak, nonatomic) IBOutlet UILabel *favoredTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoredImage;
@property (weak, nonatomic) IBOutlet UILabel *favoredContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgSlide;
@property (nonatomic, retain) UIImage * sliceImage;
@property (nonatomic, retain) UIView * sep;

@end

@implementation WQInvidualFavoredCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _sliceImage = _imgSlide.image;
    _sliceImage = [_sliceImage stretchableImageWithLeftCapWidth:0 topCapHeight:_sliceImage.size.height -1];
    _sep = [[UIView alloc] init];
    [self.contentView addSubview:_sep];
    _sep.backgroundColor = HEX(0xcecece);
    [_sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgSlide.mas_right).offset(11);
        make.bottom.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    self.contentView.clipsToBounds = YES;
}

- (void)setModel:(WQUserProfileInvidualTrendsModel *)model {
    _model = model;
    
    UIImage * img = _imgSlide.image;
    img = [img stretchableImageWithLeftCapWidth:0 topCapHeight:img.size.height -1];
    _imgSlide.image = img;
    _favoredTitleLabel.text = model.moment_choicest_article.subject;
    _favoredContent.text = model.moment_choicest_article.desc;
    [_favoredImage yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_LARGE_URLSTRING(model.moment_choicest_article.cover_pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    _favoredImage.clipsToBounds = YES;
    _imgSlide.image = _sliceImage;
    
}

- (CGFloat)heightWithModel:(WQUserProfileInvidualTrendsModel *)model {
    CGFloat addHeight = 0;
    _favoredTitleLabel.text = model.moment_choicest_article.subject;
    CGSize size = [_favoredTitleLabel sizeThatFits:CGSizeMake(kScreenWidth - 37 - 37, CGFLOAT_MAX)];
    addHeight += (size.height > 21 ? size.height : 21);
    CGFloat imageHeight = (kScreenWidth - (375 - 323)) / 323 * 130;
    
    CGFloat adjuster = imageHeight - 130;
    
    size = [_favoredContent sizeThatFits:CGSizeMake(kScreenWidth - 37 - 15, CGFLOAT_MAX)];
    addHeight += (size.height > 17 ? size.height : 17);
    
    return 223 + addHeight + adjuster;
    
}


- (void)adjustSapratorForLast {
    [_imgSlide mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(-10);
        make.left.equalTo(@15);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    [_sep mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}

- (void)adjustForCommon {
    [_imgSlide mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(-10);
        make.left.equalTo(@15);
        make.bottom.greaterThanOrEqualTo(@0);
    }];
    [_sep mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgSlide.mas_right).offset(11);
        make.bottom.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}


@end
