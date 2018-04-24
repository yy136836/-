//
//  WQfriendsTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQfriendsTableViewCell.h"
#import "WQUserProfileModel.h"
#import "WQfriend_listModel.h"

@interface WQfriendsTableViewCell()
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, retain) UILabel * creditLabel;
@end

@implementation WQfriendsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- 初始化UI
- (void)setupUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.tagLabel];
    [self.contentView addSubview:self.creditLabel];
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(44);
        make.top.left.equalTo(self.contentView).offset(15);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_top).offset(3);
        make.left.equalTo(_avatarImageView.mas_right).offset(15);
    }];
    
    [_creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).offset(5);
        make.centerY.equalTo(_titleLabel.mas_centerY);
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_avatarImageView.mas_bottom).offset(-1);
        make.left.equalTo(_titleLabel.mas_left);
    }];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.right.bottom.equalTo(self.contentView);
        make.left.equalTo(_avatarImageView.mas_left);
    }];
}

- (void)setModel:(WQfriend_listModel *)model {
    _model = model;
    _titleLabel.text = model.true_name;
    NSString *picString = [imageUrlString stringByAppendingString:model.pic_truename];
    [_avatarImageView yy_setImageWithURL:[NSURL URLWithString:picString] placeholder:[UIImage imageWithColor:HEX(0xededed)]];
    if (model.tag.count) {
        _tagLabel.text = [NSString stringWithFormat:@"%@",model.tag.firstObject];
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarImageView.mas_top).offset(3);
            make.left.equalTo(_avatarImageView.mas_right).offset(15);
        }];
    } else {
        _tagLabel.text = @"";
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView.mas_right).offset(15);
            make.centerY.equalTo(self.contentView);
        }];
    }
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] init];
    NSTextAttachment * atta = [[NSTextAttachment alloc] init];
    UIImage * img = [UIImage imageNamed:@"shouyexinyongfen"];
    atta.image = img;
    atta.bounds = CGRectMake(0,-3, 11, 12);
    NSAttributedString * attach = [NSAttributedString attributedStringWithAttachment:atta];
    [att appendAttributedString:attach];
    NSString * str = [NSString stringWithFormat:@" %@分",@(model.creditscore)];
    NSAttributedString * number = [[NSAttributedString alloc] initWithString:str
                                                                  attributes:@{NSFontAttributeName:self.creditLabel.font,
                                                                               NSForegroundColorAttributeName:WQ_LIGHT_PURPLE}];
    [att appendAttributedString:number];
    _creditLabel.attributedText = att;
    
    CGSize size = [_creditLabel sizeThatFits:CGSizeMake(MAXFLOAT, 14)];
    CGFloat labWidth = size.width + 5;
    
    [_creditLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).offset(5);
        make.height.equalTo(@14);
        make.width.equalTo(@(labWidth));
        make.centerY.equalTo(_titleLabel.mas_centerY);
    }];
    _creditLabel.layer.cornerRadius = 2;
    _creditLabel.layer.masksToBounds = YES;
}

- (void)setUserProfileModel:(WQUserProfileModel *)userProfileModel {
    _userProfileModel = userProfileModel;
    self.titleLabel.text = userProfileModel.true_name;
    [self.avatarImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(userProfileModel.pic_truename)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    
    

}

#pragma mark -- 懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return _titleLabel;
}


- (UILabel *)creditLabel {
    if (!_creditLabel) {
        _creditLabel = [[UILabel alloc] init];
        _creditLabel.font = [UIFont systemFontOfSize:9];
        _creditLabel.textColor = WQ_LIGHT_PURPLE;
        _creditLabel.textAlignment = NSTextAlignmentCenter;
        _creditLabel.backgroundColor = HEX(0xf2eeff);
    }
    return _creditLabel;
}
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.cornerRadius = 22;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}
- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    }
    return _tagLabel;
}

@end
