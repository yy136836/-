//
//  WQInvidualCircleCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQInvidualCircleCell.h"
#import "WQUserProfileImageListView.h"
#import "WQProfileLinkView.h"

@interface WQInvidualCircleCell()

@property (nonatomic, retain) UIImageView * slideImageView;
@property (nonatomic, retain) UILabel * conttentLabel;
@property (nonatomic, retain) WQUserProfileImageListView * imageListView;
@property (nonatomic, retain) WQProfileLinkView * linkView;
@property (nonatomic, retain) UIImage * slideImg;
@end


@implementation WQInvidualCircleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _slideImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_slideImageView];
        [_slideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(-10);
            make.left.equalTo(@15);
            make.bottom.greaterThanOrEqualTo(@0);
        }];
        
        _conttentLabel = [[UILabel alloc] init];
        _conttentLabel.textColor = HEX(0x333333);
        _conttentLabel.numberOfLines = 0;
        _conttentLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_conttentLabel];
        [_conttentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@35);
            make.right.equalTo(@-30);
            make.top.equalTo(@15);
            make.height.lessThanOrEqualTo(@115);
        }];
        
        _slideImg = [UIImage imageNamed:@"Slice2"];
        
        _slideImg = [_slideImg stretchableImageWithLeftCapWidth:0
                                                   topCapHeight:_slideImg.size.height - 1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        _sep = [[UIView alloc] init];
        [self.contentView addSubview:_sep];
        _sep.backgroundColor = HEX(0xcecece);
        [_sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_slideImageView.mas_right).offset(11);
            make.bottom.right.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
        
        self.contentView.clipsToBounds = YES;
        
    }
    return self;
}


- (void)setModel:(WQUserProfileInvidualTrendsModel *)model {
    _model = model;
    _slideImageView.image = _slideImg;
    WQUserProfileMomentModel * momentModel  = model.moment_status;
    
    _conttentLabel.text = momentModel.content;
    if (_imageListView) {
        [_imageListView removeFromSuperview];
        _imageListView = nil;
    }
    
    
    
    
    _imageListView = [[WQUserProfileImageListView alloc] initWithImageIds:momentModel.pic];
    
//    UIView * up = momentModel.content.length ? _conttentLabel : self.contentView;
    
    if (_imageListView) {
        [self.contentView addSubview:_imageListView];
        [_imageListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_conttentLabel.mas_left);
            
            if (momentModel.content.length) {
                make.top.equalTo(_conttentLabel.mas_bottom).offset(15);
            } else {
                make.top.equalTo(self.contentView).offset(15);
            }

            make.width.equalTo(@(kScreenWidth));
            make.height.equalTo(@(80));
        }];
      
    }
    
    if (_linkView) {
        [_linkView removeFromSuperview];
        _linkView = nil;
    }

    if (momentModel.link_url.length) {
        _linkView = [[WQProfileLinkView alloc] init];
        [self addSubview:_linkView];
        [_linkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_conttentLabel.mas_left);
            make.right.equalTo(@-15);
            make.height.equalTo(@60);
            make.top.equalTo(_imageListView ? _imageListView.mas_bottom: _conttentLabel.mas_bottom).offset(15);
        }];
        [_linkView.linkImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(momentModel.link_img)]
                                        placeholder:[UIImage imageNamed:@"lianjie占位图"]];
        _linkView.linkTextlabel.text = momentModel.link_txt;

        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkOnTap:)];

        [_linkView addGestureRecognizer:tap];
    }
    
}


- (void)adjustSapratorForLast {
    [_slideImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(-10);
        make.left.equalTo(@15);
        make.bottom.equalTo(@-10);
    }];
    [_sep mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}

- (void)adjustForCommon {
    [_slideImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(-10);
        make.left.equalTo(@15);
        make.bottom.greaterThanOrEqualTo(@0);
    }];
    [_sep mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_slideImageView.mas_right).offset(11);
        make.bottom.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}



- (CGFloat)heightWithModel:(WQUserProfileInvidualTrendsModel *)model {
    
    CGFloat ret = 15;
    WQUserProfileMomentModel * momentModel = model.moment_status;
    
    _conttentLabel.text = momentModel.content;
    
    if (momentModel.content.length) {
        CGSize size = [_conttentLabel sizeThatFits:CGSizeMake(kScreenWidth - 30 - 35, CGFLOAT_MAX)];
        ret += size.height > 115 ? 115 : size.height;
        ret += 15;
    }
    
    if (momentModel.pic.count) {
        ret += 80 + 15;
    }
    
    if (momentModel.link_url.length) {
        ret += 60 + 15;
    }
    return ret;
}



- (void)linkOnTap:(UITapGestureRecognizer *)sender {
    UIGestureRecognizerState state = sender.state;
    switch (state) {
        case UIGestureRecognizerStateEnded: {
            
            if (_linkOnTap) {
                _linkOnTap();
            }
            break;
        }
            
        default:
            break;
    }
    
    
}
@end
