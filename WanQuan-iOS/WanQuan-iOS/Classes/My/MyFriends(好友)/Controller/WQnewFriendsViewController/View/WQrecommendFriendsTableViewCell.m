//
//  WQrecommendFriendsTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQrecommendFriendsTableViewCell.h"
#import "WQrecommendnewFriendsModel.h"
#import "WQfriend_listModel.h"
#import "WQUserProfileController.h"


@interface WQrecommendFriendsTableViewCell()  
@property (nonatomic, strong) UIImageView *headimageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIButton * agreeBtn;
@property (nonatomic, retain) UILabel * creditLabel;
@property (nonatomic, retain) UILabel * friendDegreeLabel;
@end

@implementation WQrecommendFriendsTableViewCell

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

#pragma mark -- 初始化UI
- (void)setupUI
{
    [self addSubview:self.headimageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.additionalInformationLabel];
    [self addSubview:self.agreeBtn];
    [self addSubview:self.friendDegreeLabel];
    [self addSubview:self.creditLabel];
    
    [_headimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(44);
        make.top.left.equalTo(self).offset(15);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headimageView.mas_top);
        make.left.equalTo(_headimageView.mas_right).offset(10);
    }];
    

    
    [_additionalInformationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.bottom.equalTo(_headimageView.mas_bottom);
    }];
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        //make.top.equalTo(self).offset(8);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(54, 25));
    }];
}

- (void)friendsAddBtnClike
{
    if (self.friendsAddBtnClikeBlock) {
        self.friendsAddBtnClikeBlock();
    }
}

- (void)setFriend_listModel:(WQfriend_listModel *)friend_listModel {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _friend_listModel = friend_listModel;
        //NSString *imageUrl = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",friend_listModel.pic_truename]];
        [self.headimageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(friend_listModel.pic_truename)] options:0];
        self.nameLabel.text = friend_listModel.true_name;
    
    });
}

- (void)setModel:(WQrecommendnewFriendsModel *)model {
    _model = model;
    //NSString *imageUrl = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",model.pic_truename]];
    [self.headimageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)] placeholder:[UIImage imageWithColor:HEX(0xededed)]];
    self.nameLabel.text = model.true_name.length ? model.true_name : @" ";
    
    
    NSInteger degree = model.degree;
    NSString * degreeText;
    if (degree == 0) {
        degreeText = @"自己";
    }else if (degree <= 2) {
        degreeText = @"2度内好友";
    } else if (degree == 3){
        degreeText = @"3度好友";
    } else {
        degreeText = @"4度外好友";
    }
    
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] init];
    NSTextAttachment * atta = [[NSTextAttachment alloc] init];
    UIImage * img = [UIImage imageNamed:@"shouyexinyongfen"];
    atta.image = img;
    atta.bounds = CGRectMake(0,-3, 11, 12);
    NSAttributedString * attach = [NSAttributedString attributedStringWithAttachment:atta];
    [att appendAttributedString:attach];
    NSString * str = [NSString stringWithFormat:@" %@分",model.creditscore];
    NSAttributedString * number = [[NSAttributedString alloc] initWithString:str
                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9], NSForegroundColorAttributeName:WQ_LIGHT_PURPLE}];
    [att appendAttributedString:number];
    _creditLabel.attributedText = att;
    
    
    CGSize size = [_creditLabel sizeThatFits:CGSizeMake(MAXFLOAT, 14)];
    CGFloat labWidth = size.width + 5;
    
    [_creditLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(5);
        make.height.equalTo(@14);
        make.width.equalTo(@(labWidth));
        make.centerY.equalTo(_nameLabel.mas_centerY);
    }];
    
    _friendDegreeLabel.text = degreeText;
    CGSize size1 = [_friendDegreeLabel sizeThatFits:CGSizeMake(0, 14)];
//    _friendDegreeLabel.frame = CGRectMake(_friendDegreeLabel.x, _friendDegreeLabel.y, size1.width + 5, 14);
    
    [_friendDegreeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_creditLabel.mas_right).offset(10);
        make.centerY.equalTo(_creditLabel.mas_centerY);
        make.width.equalTo(@(size1.width + 5));
        make.height.equalTo(@14);
    }];
    
    
    
}

#pragma mark -- 懒加载
- (UIImageView *)headimageView {
    if (!_headimageView) {
        _headimageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
        _headimageView.contentMode = UIViewContentModeScaleAspectFill;
        _headimageView.layer.cornerRadius = 22;
        _headimageView.layer.masksToBounds = YES;
        _headimageView.userInteractionEnabled = YES;
        [_headimageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontap)]];
    }
    return _headimageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"用户名";
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = HEX(0x333333);
    }
    return _nameLabel;
}

- (UILabel *)creditLabel {
    if (!_creditLabel) {
        _creditLabel = [[UILabel alloc] init];
        _creditLabel.textAlignment = NSTextAlignmentCenter;
        _creditLabel.backgroundColor = HEX(0xf2eeff);
    }
    return _creditLabel;
}

- (UILabel *)friendDegreeLabel {
    if (!_friendDegreeLabel) {
        _friendDegreeLabel = [[UILabel alloc] init];
        _friendDegreeLabel.font = [UIFont systemFontOfSize:9];
        _friendDegreeLabel.textColor = HEX(0x999999);
        _friendDegreeLabel.backgroundColor = HEX(0xf3f3f3);
        _friendDegreeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _friendDegreeLabel;
}


- (UIButton *)agreeBtn {
    if (!_agreeBtn) {
        _agreeBtn = [[UIButton alloc]init];
        [_agreeBtn addTarget:self action:@selector(friendsAddBtnClike) forControlEvents:UIControlEventTouchUpInside];
        _agreeBtn.layer.cornerRadius = 5;
        _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        _agreeBtn.backgroundColor = [UIColor colorWithHex:0x5d2a89];
        [_agreeBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:WQ_LIGHT_PURPLE forState:UIControlStateNormal];
        _agreeBtn.layer.borderColor = WQ_LIGHT_PURPLE.CGColor;
        _agreeBtn.layer.borderWidth = 1;
        
    }
    return _agreeBtn;
}
- (UILabel *)additionalInformationLabel {
    if (!_additionalInformationLabel) {
        _additionalInformationLabel = [[UILabel alloc]init];
        _additionalInformationLabel.font = [UIFont systemFontOfSize:14];
        _additionalInformationLabel.textColor = [UIColor colorWithHex:0X999999];
    }
    return _additionalInformationLabel;
}


- (void)setType:(NewFriendType)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        _type = type;
//        if (_type == NewFriendTypeToAgree) {
//            _additionalInformationLabel.text = @"好友请求";
//            [_agreeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//            [_agreeBtn setTitle:@"同意" forState: UIControlStateNormal];
//        }
        
        if (_type ==  NewFriendTypeToAddressBook) {
            _additionalInformationLabel.text = @"通讯录好友";
        }
        
        if (_type == NewFriendTypeToRecommond) {
            _additionalInformationLabel.text = @"推荐好友";
        }
    });
}



- (void)ontap {
    
    // 是当前账户
    
//    WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:self.friend_listModel.user_id];
//    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}
@end
