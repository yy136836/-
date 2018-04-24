//
//  WQrecommendFriendsTwoTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQrecommendFriendsTwoTableViewCell.h"
#import "WQfriend_listModel.h"

@interface WQrecommendFriendsTwoTableViewCell () 
@property (nonatomic, strong) UIImageView *headimageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *additionalInformationLabel;
@property (nonatomic, strong) UIButton *agreeBtn;
@end

@implementation WQrecommendFriendsTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setModel:(WQfriend_listModel *)model {
    _model = model;
    //NSString *imageUrl = [imageUrlString stringByAppendingString:model.pic_truename];
    [_headimageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)] options:0];
    self.nameLabel.text = model.true_name;
}
#pragma mark -- 初始化UI
- (void)setupUI
{
    [self addSubview:self.headimageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.additionalInformationLabel];
    [self addSubview:self.agreeBtn];
    
    [_headimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(40);
        make.top.left.equalTo(self).offset(8);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headimageView.mas_top);
        make.left.equalTo(_headimageView.mas_right).offset(8);
    }];
    [_additionalInformationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.bottom.equalTo(_headimageView.mas_bottom);
    }];
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        //make.top.equalTo(self).offset(8);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(67, 33));
    }];
}

- (void)friendsAddBtnClike {
    if (self.friendsAddBtnClikeBlock) {
        self.friendsAddBtnClikeBlock();
    }
}

#pragma mark -- 懒加载
- (UIImageView *)headimageView
{
    if (!_headimageView) {
        _headimageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
        _headimageView.contentMode = UIViewContentModeScaleAspectFill;
        _headimageView.layer.cornerRadius = 5;
        _headimageView.layer.masksToBounds = YES;
    }
    return _headimageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"用户名";
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}

- (UIButton *)agreeBtn
{
    if (!_agreeBtn) {
        _agreeBtn = [[UIButton alloc]init];
        [_agreeBtn addTarget:self action:@selector(friendsAddBtnClike) forControlEvents:UIControlEventTouchUpInside];
        _agreeBtn.layer.cornerRadius = 5;
        _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _agreeBtn.backgroundColor = [UIColor colorWithHex:0x5d2a89];
        [_agreeBtn setTitle:@" 添加" forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
        [_agreeBtn setImage:[UIImage imageNamed:@"addFriends"] forState:UIControlStateNormal];
    }
    return _agreeBtn;
}
- (UILabel *)additionalInformationLabel
{
    if (!_additionalInformationLabel) {
        _additionalInformationLabel = [[UILabel alloc]init];
        _additionalInformationLabel.text = @"推荐好友";
        _additionalInformationLabel.font = [UIFont systemFontOfSize:13];
        _additionalInformationLabel.textColor = [UIColor colorWithHex:0Xcacaca];
    }
    return _additionalInformationLabel;
}

@end
