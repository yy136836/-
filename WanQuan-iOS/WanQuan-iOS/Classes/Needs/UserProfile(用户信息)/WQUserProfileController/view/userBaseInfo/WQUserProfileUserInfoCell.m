//
//  WQUserProfileUserInfoCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/18.
//  Copyright © 2017年 WQ. All rights reserved.
//




#import "WQUserProfileUserInfoCell.h"
#import "CLImageScrollDisplayView.h"

@interface WQUserProfileUserInfoCell ()

/**
 头像
 */
@property (strong, nonatomic) UIImageView *avatar;

/**
 姓名
 */
@property (strong, nonatomic) UILabel *userNamelabel;

/**
 信用分
 */
@property (strong, nonatomic) UIButton *userCridit;

/**
 第一个标签
 */
@property (strong, nonatomic) UILabel *userCompany;

/**
 第二个标签
 */
@property (strong, nonatomic) UILabel *userSchool;

/**
 需求数
 */
@property (strong, nonatomic) UILabel *postNeedCount;

/**
 帮助数
 */
@property (strong, nonatomic) UILabel *recieveNeedCount;

/**
 聊天
 */
@property (strong, nonatomic) UIButton *chatOrFriendApply;

/**
 关注动态
 */
@property (strong, nonatomic) UIButton *follow;


/**
 头像下的相机
 */
@property (strong, nonatomic) UIButton *changePicBtn;

/**
 我要实名认证的按钮
 */
//@property (strong, nonatomic) UIButton *confim;

/**
 几度好友
 */
@property (strong, nonatomic) UILabel *friendDegreeLabel;

/**
 背景图
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatBtnRightConstant;

@property (strong, nonatomic) UIView *topView;



@end

@implementation WQUserProfileUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark -- 初始化contentView
- (void)setupContentView {
    // 顶部视图
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScaleX(184)));
        make.top.left.right.equalTo(self.contentView);
    }];
    
    UITapGestureRecognizer * tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(changeBackGroundImage:)];
    [_topView addGestureRecognizer:tap];
    

    
    
    UIView *maskView = [[UIView alloc]init];
    [self.contentView addSubview:maskView];
    maskView.backgroundColor = [UIColor whiteColor];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kScaleX(184));
        make.bottom.left.right.equalTo(self.contentView);
    }];

    
    
    // 头像
    self.avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    self.avatar.userInteractionEnabled = YES;
    _avatar.layer.cornerRadius = 42.5;
    _avatar.layer.masksToBounds = YES;
    _avatar.userInteractionEnabled = YES;
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
    [_avatar addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHeadImage:)]];
    [self.contentView addSubview:self.avatar];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(85, 85));
        make.left.equalTo(self.contentView).offset(ghSpacingOfshiwu);
        make.top.equalTo(_topView.mas_bottom).offset(-42.5);
    }];
    
    // 头像下的相机
    self.changePicBtn = [[UIButton alloc] init];
    [self.changePicBtn addTarget:self action:@selector(changeAvatar:) forControlEvents:UIControlEventTouchUpInside];
    [self.changePicBtn setImage:[UIImage imageNamed:@"xiangji"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.changePicBtn];
    [self.changePicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.avatar);
    }];
    
    // 姓名
    self.userNamelabel = [UILabel labelWithText:@"姓名" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:22];
    self.userNamelabel.numberOfLines = 1;
    [self.contentView addSubview:self.userNamelabel];
    [self.userNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar.mas_bottom).offset(ghSpacingOfshiwu);
        make.left.equalTo(self.avatar);
    }];
    
    // 工作经历标签
    self.userCompany = [UILabel labelWithText:@"工作经历" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:14];
    [self.contentView addSubview:self.userCompany];
    [self.userCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar);
        make.top.equalTo(self.userNamelabel.mas_bottom).offset(6);
    }];
    
    // 学历经历标签
    self.userSchool = [UILabel labelWithText:@"学习经历" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:14];
    [self.contentView addSubview:self.userSchool];
    [self.userSchool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar);
        make.top.equalTo(self.userCompany.mas_bottom).offset(6);
        make.bottom.equalTo(self.contentView).offset(-ghDistanceershi);
    }];
    
    // 信用分
    self.userCridit = [[UIButton alloc] init];
    self.userCridit.titleLabel.font = [UIFont systemFontOfSize:12];
    self.userCridit.backgroundColor = [UIColor colorWithHex:0xf4f0ff];
    self.userCridit.layer.cornerRadius = 2;
    self.userCridit.layer.masksToBounds = YES;
    [self.userCridit setTitleColor:[UIColor colorWithHex:0x9871C9] forState:UIControlStateNormal];
    [self.userCridit setImage:[UIImage imageNamed:@"userprofilexinyong"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.userCridit];
    [self.userCridit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(56, 20));
        make.left.equalTo(self.userNamelabel.mas_right).offset(ghStatusCellMargin);
        make.centerY.equalTo(self.userNamelabel.mas_centerY);
    }];
    
    // 几度好友
    self.friendDegreeLabel = [UILabel labelWithText:@"二度好友" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    self.friendDegreeLabel.layer.cornerRadius = 2;
    self.friendDegreeLabel.layer.masksToBounds = YES;
    self.friendDegreeLabel.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [self.contentView addSubview:self.friendDegreeLabel];
    [self.friendDegreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 20));
        make.centerY.equalTo(self.userNamelabel.mas_centerY);
        make.left.equalTo(self.userCridit.mas_right).offset(ghStatusCellMargin);
    }];
    
    // 帮助数的label
    UILabel *helpNumberTextLabel = [UILabel labelWithText:@"帮助数" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:14];
    [self.contentView addSubview:helpNumberTextLabel];
    [helpNumberTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
        make.bottom.equalTo(self.contentView).offset(-ghDistanceershi);
    }];
    
    // 需求数的Label
    UILabel *demandTextLabel = [UILabel labelWithText:@"需求数" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:14];
    [self.contentView addSubview:demandTextLabel];
    [demandTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(helpNumberTextLabel.mas_left).offset(-30);
        make.centerY.equalTo(helpNumberTextLabel.mas_centerY);
    }];
    
    // 帮助数量的label
    UILabel *helpNumberLabel = [UILabel labelWithText:@"1" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:22];
    self.recieveNeedCount = helpNumberLabel;
    [self.contentView addSubview:helpNumberLabel];
    [helpNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(helpNumberTextLabel.mas_left);
        make.bottom.equalTo(helpNumberTextLabel.mas_top).offset(-5);
    }];
    
    // 需求数量的Label
    UILabel *demandLabel = [UILabel labelWithText:@"1" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:22];
    self.postNeedCount = demandLabel;
    [self.contentView addSubview:demandLabel];
    [demandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(demandTextLabel.mas_left);
        make.bottom.equalTo(demandTextLabel.mas_top).offset(-5);
    }];
    
    // 关注动态
    self.follow = [[UIButton alloc] init];
    self.follow.titleLabel.font = [UIFont systemFontOfSize:15];
    self.follow.backgroundColor = [UIColor whiteColor];
    self.follow.layer.cornerRadius = 5;
    self.follow.layer.masksToBounds = YES;
    [self.follow setTitleColor:WQ_LIGHT_PURPLE forState:UIControlStateNormal];
    [self.follow setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    self.follow.layer.borderColor = WQ_LIGHT_PURPLE.CGColor;
    self.follow.layer.borderWidth = 1;
    [self.follow setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
                       forState:UIControlStateNormal];
    
    [self.follow setBackgroundImage: [UIImage imageWithColor:WQ_LIGHT_PURPLE]
                       forState:UIControlStateSelected];
    [self.follow setTitle:@"关注动态" forState:UIControlStateNormal];
    [self.follow setTitleColor:[UIColor colorWithHex:0x9767D0] forState:UIControlStateNormal];
    
    [self.follow addTarget:self action:@selector(folowOrCancle:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.follow];
    [self.follow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(74, 30));
        make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
        make.top.equalTo(_topView.mas_bottom).offset(ghSpacingOfshiwu);
    }];
    
    // 聊天
    self.chatOrFriendApply = [[UIButton alloc] init];
    self.chatOrFriendApply.titleLabel.font = [UIFont systemFontOfSize:15];
    self.chatOrFriendApply.backgroundColor = [UIColor whiteColor];
    [self.chatOrFriendApply setTitle:@"聊天" forState:UIControlStateNormal];
    [self.chatOrFriendApply setTitleColor:[UIColor colorWithHex:0x9767D0] forState:UIControlStateNormal];
    [self.chatOrFriendApply addTarget:self action:@selector(chatWithOrFriendApply:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.chatOrFriendApply];
    [self.chatOrFriendApply mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(82, 30));
        make.right.equalTo(self.follow.mas_left).offset(-ghSpacingOfshiwu);
        make.centerY.equalTo(self.follow.mas_centerY);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _avatar.layer.cornerRadius = 42;
    _avatar.layer.masksToBounds = YES;
    _avatar.userInteractionEnabled = YES;
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
    [_avatar addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self
                                             action:@selector(showHeadImage:)]];
    _userCridit.titleLabel.textAlignment = NSTextAlignmentCenter;

    _userCridit.layer.cornerRadius = 2;
    _userCridit.layer.masksToBounds = YES;
    
    _friendDegreeLabel.layer.cornerRadius = 2;
    _friendDegreeLabel.layer.masksToBounds = YES;

    _follow.layer.cornerRadius = 5;
    _follow.layer.masksToBounds = YES;
    [_follow setTitleColor:WQ_LIGHT_PURPLE forState:UIControlStateNormal];
    [_follow setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    _follow.layer.borderColor = WQ_LIGHT_PURPLE.CGColor;
    _follow.layer.borderWidth = 1;
    [_follow setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
                       forState:UIControlStateNormal];
    
    [_follow setBackgroundImage: [UIImage imageWithColor:WQ_LIGHT_PURPLE]
                       forState:UIControlStateSelected];
    

    UITapGestureRecognizer * tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(changeBackGroundImage:)];
    [_topView addGestureRecognizer:tap];
    
}

- (void)setModel:(WQUserInfoModel *)model {
    _model = model;
//    当前用户的认证状态实名认证状态：
//    STATUS_UNVERIFY=未实名认证；
//    STATUS_VERIFIED=已实名认证；
//    STATUS_VERIFING=已提交认证正在等待管理员审批
    
    BOOL userConfimed = [self.model.idcard_status isEqualToString:@"STATUS_VERIFIED"];
    // 是否是我的账号
    BOOL myAccount = self.model.ismyaccount;
    // 是不是好友
    BOOL isFriend = self.model.isfriend;
    
    BOOL isPhoneNumberUser = [model.true_name hasPrefix:@"+"];
    
    
    // 不是实名认证
    if (!userConfimed) {
        _avatar.image = [UIImage imageNamed:@"kuaisuzhuceyonghu"];
    } else {
        // 已经实名认证
        [_avatar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_MIDDLE_URLSTRING(model.pic_truename)]
                        placeholder:[UIImage imageNamed:@"kuaisuzhuceyonghu"]];
    }
    
    _changePicBtn.hidden = (!self.selfEditing) || (!self.model.ismyaccount);
    _userSchool.hidden = !userConfimed ;
    _userCompany.hidden = !userConfimed;
    _userCridit.hidden = (!userConfimed) || isPhoneNumberUser;
    _friendDegreeLabel.hidden = (!userConfimed) || isPhoneNumberUser;
    _follow.hidden = self.model.ismyaccount || (isPhoneNumberUser);
    
    _follow.selected = self.model.user_followed;
    
    _userNamelabel.text = model.true_name;
    _userCompany.text = model.tag.count ? model.tag[0] : @"暂未填写工作学习经历";
    if ([_userCompany.text isEqualToString:@"暂未填写工作学习经历"]) {
        [self.userSchool mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.avatar);
//            make.top.equalTo(self.userCompany.mas_bottom).offset(6);
            make.bottom.equalTo(self.contentView).offset(-40);
        }];
    }
    _userSchool.text = model.tag.count > 1 ? model.tag[1] : @"";
    
    _postNeedCount.text =  model.need_count.stringValue;
    _recieveNeedCount.text = model.need_bidded_count.stringValue;
    
    
    _chatOrFriendApply.layer.cornerRadius = 5;
    _chatOrFriendApply.layer.masksToBounds = YES;
    _chatOrFriendApply.hidden = !userConfimed;
    
    UIImage * btnImage;
    NSString * btnTitle;
    UIColor * btnTitleColor;
    
    if (myAccount) {
        // 是自己不显示关注按钮
        self.follow.hidden = YES;
        // 是自己不显示好友度数
        _friendDegreeLabel.hidden = YES;
        if (self.selfEditing) {
            btnImage = [UIImage imageNamed:@"yulan"];
            btnTitle = @" 预览";
            btnTitleColor = WQ_LIGHT_PURPLE;
            [self.chatOrFriendApply mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
                make.size.mas_equalTo(CGSizeMake(82, 30));
                make.top.equalTo(self.topView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
        } else {
            _chatOrFriendApply.hidden = YES;
        }
    } else {
        // 是否是好友
        if (isFriend) {
            // 是好友直接显示聊天
            [self.chatOrFriendApply mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
                make.size.mas_equalTo(CGSizeMake(82, 30));
                make.top.equalTo(self.topView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
            btnImage = [UIImage imageNamed:@"liaotian"];
            btnTitle = @" 聊天";
            btnTitleColor = HEX(0x666666);
            // 是好友不显示关注按钮
            self.follow.hidden = YES;
        } else {
            // 不是好友显示关注按钮
            self.follow.hidden = NO;
            [self.follow mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(74, 30));
                make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
                make.top.equalTo(self.topView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
            [self.chatOrFriendApply mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(82, 30));
                make.right.equalTo(self.follow.mas_left).offset(-ghSpacingOfshiwu);
                make.centerY.equalTo(self.follow.mas_centerY);
            }];
            btnImage = [UIImage imageNamed:@"jiahaoyou"];
            btnTitle = @" 加好友";
            btnTitleColor = WQ_LIGHT_PURPLE;
        }
    }

    // 好友度数
    NSString *user_degree;
    if (model.user_degree == 0) {
        user_degree = [@"  " stringByAppendingString:[@"自己" stringByAppendingString:@" "]];
    }else if (model.user_degree <= 2) {
        user_degree = [@"  " stringByAppendingString:[@"2度内好友" stringByAppendingString:@" "]];
        
        _follow.hidden = YES;
        [self.chatOrFriendApply mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
            make.size.mas_equalTo(CGSizeMake(82, 30));
            make.top.equalTo(self.topView.mas_bottom).offset(ghSpacingOfshiwu);
        }];
        
    }else if (model.user_degree == 3) {
        user_degree = [@"  " stringByAppendingString:[@"3度好友" stringByAppendingString:@" "]];
    }else {
        user_degree = [@"  " stringByAppendingString:[@"4度外好友" stringByAppendingString:@" "]];
    }
    self.friendDegreeLabel.text = user_degree;
    
    [_userCridit setTitle:[NSString stringWithFormat:@"%@分",model.credit_score.stringValue] forState:UIControlStateNormal];
    _userCridit.titleLabel.textAlignment = NSTextAlignmentLeft;
    _userCridit.userInteractionEnabled = NO;
 
    [_chatOrFriendApply setTitle:btnTitle forState:UIControlStateNormal];
    [_chatOrFriendApply setTitleColor:btnTitleColor forState:UIControlStateNormal];
    [_chatOrFriendApply setImage:btnImage forState:UIControlStateNormal];
    _chatOrFriendApply.layer.cornerRadius = 5;
    _chatOrFriendApply.layer.masksToBounds = YES;
    _chatOrFriendApply.layer.borderColor = btnTitleColor.CGColor;
    _chatOrFriendApply.layer.borderWidth = 1;
    
    [self.userNamelabel sizeToFit];
    CGFloat w = kScreenWidth - self.userNamelabel.width - ghSpacingOfshiwu;
    if (w > 160) {
        // 信用分
        [self.userCridit mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(56, 20));
            make.left.equalTo(self.userNamelabel.mas_right).offset(ghStatusCellMargin);
            make.centerY.equalTo(self.userNamelabel.mas_centerY);
        }];
        // 几度好友
        [self.friendDegreeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 20));
            make.centerY.equalTo(self.userNamelabel.mas_centerY);
            make.left.equalTo(self.userCridit.mas_right).offset(ghStatusCellMargin);
        }];
        // 工作经历标签
        [self.userCompany mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatar);
            make.top.equalTo(self.userNamelabel.mas_bottom).offset(6);
        }];
    }else {
        // 信用分
        [self.userCridit mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(56, 20));
            make.left.equalTo(self.userNamelabel);
            make.top.equalTo(self.userNamelabel.mas_bottom).offset(6);
        }];
        // 几度好友
        [self.friendDegreeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 20));
            make.centerY.equalTo(self.userCridit.mas_centerY);
            make.left.equalTo(self.userCridit.mas_right).offset(ghStatusCellMargin);
        }];
        // 工作经历标签
        [self.userCompany mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatar);
            make.top.equalTo(self.userCridit.mas_bottom).offset(6);
        }];
    }
}

#pragma mark -- 头像下相机的响应事件
- (void)changeAvatar:(id)sender {
    
    if (!self.selfEditing) {
        return;
    }
    if (self.changeAvartar) {
        self.changeAvartar();

    }
}

#pragma mark -- 聊天的响应事件
- (void)chatWithOrFriendApply:(id)sender {
    if (self.selfEditing) {
        if (self.goPreview) {
            self.goPreview();
            return;
        }
    }
    if (self.model.isfriend) {
        if (self.goTalking) {
            self.goTalking();
            return;
        }
    }
    if (!self.model.isfriend) {
        if (self.friendApply) {
            self.friendApply();
            return;
        }
    }
 
}

#pragma mark -- 关注动态的响应事件
- (void)folowOrCancle:(id)sender {
    
    if (self.follwOrUnfollow) {
        self.follwOrUnfollow(sender);
    }
}

- (void)changeBackGroundImage:(UITapGestureRecognizer *)sender {
    UIGestureRecognizerState state = sender.state;
    if(state == UIGestureRecognizerStateEnded && _changeBackGroundImage) {
        _changeBackGroundImage();
    }
}

#pragma mark -- 头像的响应事件
- (void)showHeadImage:(UITapGestureRecognizer *)sender {
    BOOL userConfimed = [self.model.idcard_status isEqualToString:@"STATUS_VERIFIED"];
    if (userConfimed) {

        UIImageView * imageVIew = (UIImageView * )(sender.view);
        
        if (!imageVIew.image) {
            return;
        }
        if (sender.view) {
            CGRect rect = sender.view.frame;
            CLImageScrollDisplayView *imageShowView = [[CLImageScrollDisplayView alloc] initWithConverFrame:rect index:0 willShowImageUrls:@[WEB_IMAGE_LARGE_URLSTRING(_model.pic_truename)]];
            //        imageShowView.showPageControl = YES;
            [[UIApplication sharedApplication].keyWindow addSubview:imageShowView];
        }
    }
}
@end
