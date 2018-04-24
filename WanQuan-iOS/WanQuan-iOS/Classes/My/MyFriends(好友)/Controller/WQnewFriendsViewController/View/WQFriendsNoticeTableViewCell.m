//
//  WQFriendsNoticeTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQFriendsNoticeTableViewCell.h"
#import "WQUserProfileModel.h"

@interface WQFriendsNoticeTableViewCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *headimageView;
@property (nonatomic, strong) UIButton *agreedToBtn;
@property (nonatomic, strong) UILabel *friendRequestsLabel;
@end

@implementation WQFriendsNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    [self addSubview:self.headimageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.agreedToBtn];
    [self addSubview:self.friendRequestsLabel];
    
    [_headimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(40);
        make.top.left.equalTo(self).offset(8);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headimageView.mas_top);
        make.left.equalTo(_headimageView.mas_right).offset(8);
    }];
    [_agreedToBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-ghStatusCellMargin);
        make.size.mas_equalTo(CGSizeMake(67, 33));
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_friendRequestsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.bottom.equalTo(_headimageView.mas_bottom).offset(-3);
    }];
}

- (void)setModel:(WQUserProfileModel *)model {
    //NSString *imageUrl = [imageUrlString stringByAppendingString:model.pic_truename];
    [_headimageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)] options:0];
    _nameLabel.text = model.true_name;
}

- (void)agreedToBtnClike {
    if (self.agreedToBtnClikeBlock) {
        self.agreedToBtnClikeBlock();
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
- (UIButton *)agreedToBtn {
    if (!_agreedToBtn) {
        _agreedToBtn = [[UIButton alloc] init];
        _agreedToBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_agreedToBtn setTitle:@" 同意" forState:UIControlStateNormal];
        [_agreedToBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
        [_agreedToBtn setImage:[UIImage imageNamed:@"addFriends"] forState:UIControlStateNormal];
        _agreedToBtn.backgroundColor = [UIColor colorWithHex:0x5d2a89];
        [_agreedToBtn addTarget:self action:@selector(agreedToBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreedToBtn;
}
- (UILabel *)friendRequestsLabel {
    if (!_friendRequestsLabel) {
        _friendRequestsLabel = [UILabel labelWithText:@"好友请求" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:12];
    }
    return _friendRequestsLabel;
}

@end
