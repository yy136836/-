//
//  WQUserProfileTableHeaderView.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/4/12.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUserProfileTableHeaderView.h"
#import "WQTwoUserProfileModel.h"
#import "WQComfimController.h"
#import "WQPhotoBrowser.h"
@interface CreditsView : UIView
@property (nonatomic, copy) NSString * creditsString;
@end

@implementation CreditsView {
    UILabel *  _creditsLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
        self.backgroundColor = HEX(0xf2edff);
    }
    return self;
}


- (void)setUpView {
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, 27, 27)];
    imageView.image = [UIImage imageNamed:@"xinyongfen"];
    imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:imageView];
    
    
    _creditsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [self addSubview:_creditsLabel];
    [_creditsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right);
        make.right.equalTo(self);
        make.top.bottom.equalTo(self);
    }];
    _creditsLabel.font = [UIFont systemFontOfSize:15];
    _creditsLabel.textColor = [UIColor colorWithHex:0x901f82];
    _creditsLabel.textAlignment = NSTextAlignmentCenter;
    _creditsLabel.text = @"信用值";
    
}

-(void)setCreditsString:(NSString *)creditsString {
    _creditsLabel.text = creditsString;
}

@end





@interface WQUserProfileTableHeaderView ()/*<MWPhotoBrowserDelegate>*/


/**
 姓名
 */
@property (nonatomic, retain) UILabel * userNameLabel;

/**
 信用额
 */
@property (nonatomic, retain) CreditsView * userCrediteView;

/**
 公司
 */
@property (nonatomic, retain) UILabel * userCompanyLabel;

/**
 学校
 */
@property (nonatomic, retain) UILabel * userSchoolLabel;

/**
 发单数
 */
@property (nonatomic, strong) UILabel * quantityLabel;

/**
 接单数
 */
@property (nonatomic, strong) UILabel * joinLabel;

/**
 我要认证图片(当还未认证时)
 */
@property (nonatomic, retain) UIImageView * identificationImageView;

/**
 我要认证上面的三角箭头(当未认证时)
 */
@property (nonatomic, retain) UIImageView * rightArrow;

/**
 实名认证按钮底色为透明色
 */
@property (nonatomic, retain) UIButton * identificationButton;

@end

@implementation WQUserProfileTableHeaderView

-(instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)]) {
        [self setUpView];
    }
    return self;
}


- (void)setUpView {
    [self addHeadImageView];
    [self addUserNameLabel];
    [self addcredits];
    [self addCompanyLabel];
    [self addSchoolLabel];
    [self addQuantityLabel];
    [self addJoinLabel];
    [self addLines];
    [self addIdentificationImageView];
    [self addRightArrow];
    [self addIdentificationButton];
}

- (void)addHeadImageView {
    _userHeadImageView =({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"holder"];
        imageView.backgroundColor = [UIColor redColor];
        imageView.layer.cornerRadius = 6;
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@75);
            make.height.equalTo(@75);
            make.top.equalTo(self).offset(15);
            make.left.equalTo(self).offset(15);
        }];
        imageView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
        imageView.backgroundColor = [UIColor whiteColor];
//        [imageView addGestureRecognizer:tap];
        imageView;
    });
}

- (void)addUserNameLabel {
    _userNameLabel = ({
        
        UILabel *label = [[UILabel alloc]init];
        [self addSubview:label];

        label.font = [UIFont systemFontOfSize:19];
        label.text = @"用户名";
        label.textColor = [UIColor colorWithHex:0x111111];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self).offset(15);
            make.left.equalTo(_userHeadImageView.mas_right).offset(15);
            //make.width.equalTo(@80);
            make.height.equalTo(@25);
        }];
        label;
    });
}

- (void)addcredits {
    _userCrediteView= ({
        CreditsView * crediteView = [[CreditsView alloc] initWithFrame:CGRectZero];
        [self addSubview:crediteView];

        [crediteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_userHeadImageView.mas_top);
            make.left.equalTo(_userNameLabel.mas_right).offset(0);
            make.width.equalTo(@60);
            make.height.equalTo(@25);
        }];
        crediteView;
    });
    
}

- (void)addCompanyLabel {
    _userCompanyLabel = ({
        UILabel * label = [[UILabel alloc] init];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_userNameLabel.mas_bottom).offset(4);
            make.left.equalTo(_userHeadImageView.mas_right).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@25);
        }];

        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x333333];
        
        label.text = @"用户公司名称";
        label.adjustsFontSizeToFitWidth = YES;
        label;
    });
}

- (void)addSchoolLabel {


    _userSchoolLabel = ({
        
        UILabel * label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x666666] ;
        label.text = @"用户学校名称";
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_userCompanyLabel.mas_bottom).offset(0);
            make.left.equalTo(_userCompanyLabel.mas_left);
            make.right.equalTo(self.mas_right).offset(15);
            make.height.equalTo(@25);
        }];
        
        
        label;
    });
    
}

- (void)addQuantityLabel {
    _quantityLabel = ({
        
        UILabel * label = [[UILabel alloc] init];
        [self addSubview:label];
        label.font = [UIFont systemFontOfSize:19];
        label.textColor = [UIColor colorWithHex:0x5d2a89] ;
        label.text = @"发单数";
        label.textAlignment = NSTextAlignmentCenter;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_userHeadImageView.mas_bottom).offset(19);
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width).multipliedBy(0.5);
            make.height.equalTo(@25);
        }];
        
        label;
    });
    
    
    UILabel * label = [[UILabel alloc] init];
    [self addSubview:label];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHex:0x666666] ;
    label.text = @"发单数";
    label.textAlignment = NSTextAlignmentCenter;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_quantityLabel.mas_bottom).offset(-2);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
        make.height.equalTo(@25);
    }];

}

- (void)addJoinLabel {
    _joinLabel = ({
        
        UILabel * label = [[UILabel alloc] init];
        [self addSubview:label];
        label.font = [UIFont systemFontOfSize:19];
        label.textColor = [UIColor colorWithHex:0x5d2a89] ;
        label.text = @"接单数";
        label.textAlignment = NSTextAlignmentCenter;

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_userHeadImageView.mas_bottom).offset(19);
            make.left.equalTo(_quantityLabel.mas_right);
            make.width.equalTo(self.mas_width).multipliedBy(0.5);
            make.height.equalTo(@25);
        }];
        label;
    });
    UILabel * label = [[UILabel alloc] init];
    [self addSubview:label];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHex:0x666666] ;
    label.text = @"接单数";
    label.textAlignment = NSTextAlignmentCenter;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_joinLabel.mas_bottom).offset(-2);
        make.left.equalTo(_quantityLabel.mas_right);
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
        make.height.equalTo(@25);
    }];

}

- (void)addLines {
    
    UIView * line = [UIView new];
    [self addSubview:line];

    line.backgroundColor = [UIColor colorWithHex:0xefefef];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-56);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@0.5);
    }];
    
    
    
    line = [UIView new];
    [self addSubview:line];

    line.backgroundColor = [UIColor colorWithHex:0xefefef];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userHeadImageView.mas_bottom).offset(25);
        make.left.equalTo(self.joinLabel.mas_left);
        make.width.equalTo(@0.5);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
}

- (void)addIdentificationImageView {
    _identificationImageView  = ({
        UIImageView * imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(70);
            make.right.equalTo(self);
            make.width.equalTo(@100);
            make.height.equalTo(@27);
        }];
        imageView.image = [UIImage imageNamed:@"woyaoshimingrenzheng"];
        imageView;
    });
}

- (void)addRightArrow {
    _rightArrow  = ({
        UIImageView * imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userHeadImageView.mas_centerY);
            make.right.equalTo(self);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        imageView.image = [UIImage imageNamed:@"rightArrow"];
        imageView.contentMode = UIViewContentModeCenter;
        imageView;
    });
}


- (void)addIdentificationButton {
    _identificationButton = ({
        UIButton * btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userNameLabel.mas_left);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(@100);
        }];
        [btn addTarget:self action:@selector(identificationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
}

- (void)setModel:(WQUserProfileModel *)model {
    _model = model;
    if (![model.im_namelogin isEqualToString:[EMClient sharedClient].currentUsername]) {
        self.identificationButton.hidden = YES;
        self.identificationImageView.hidden = YES;
        self.rightArrow.hidden = YES;
    }
    NSString * picURLString = model.pic_truename;
    picURLString = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",picURLString]];
   
    [_userHeadImageView yy_setImageWithURL:[NSURL URLWithString:picURLString] options:0];
    
    _userNameLabel.text = model.true_name;
//    //工作经历
//    @property (nonatomic, strong) NSArray<WQTwoUserProfileModel *> *work_experience;
//    //教育经历
//    @property (nonatomic, strong) NSArray<WQTwoUserProfileModel *> *education
    
    
    if (model.tag.count) {
        _userCompanyLabel.text = model.tag[0];
    } else {
        _userCompanyLabel.text = @"";
    }
    
    if (model.tag.count > 1) {
        
        _userSchoolLabel.text = model.tag[1];
    } else {
        _userSchoolLabel.text = @"";
    }
    
    _userCrediteView.creditsString = [NSString stringWithFormat:@"%.0f",model.credit_score];
    _quantityLabel.text = [NSString stringWithFormat:@"%d",model.need_count];
    _joinLabel.text = [NSString stringWithFormat:@"%d",model.need_bidded_count];
//STATUS_UNVERIFY=未实名认证；STATUS_VERIFIED=已实名认证；STATUS_VERIFING=已提交认证正在等待管理员审批
    if ([_model.idcard_status isEqualToString:@"STATUS_UNVERIFY"]) {
        //TODO
        _identificationImageView.image = [UIImage imageNamed:@"woyaoshimingrenzheng"];
        _rightArrow.hidden = NO;
        _userCrediteView.hidden = YES;
        _userNameLabel.center = CGPointMake(_userNameLabel.centerX, _userHeadImageView.centerY);
        
    }
    
    if ([_model.idcard_status isEqualToString:@"STATUS_VERIFING"]) {
        _identificationImageView.image = [UIImage imageNamed:@"dengdaihoutaishenhe"];
        _userCrediteView.hidden = YES;
        _rightArrow.hidden = YES;
        _userNameLabel.center = CGPointMake(_userNameLabel.centerX, _userHeadImageView.centerY);
    }
    
    if ([_model.idcard_status isEqualToString:@"STATUS_VERIFIED"]) {
        _identificationImageView.hidden = YES;
        _rightArrow.hidden = YES;
        _userCrediteView.hidden = NO;
    }
}

- (void)identificationButtonClicked:(UIButton *)sender {
    if ([_model.idcard_status isEqualToString:@"STATUS_UNVERIFY"]) {
        WQComfimController * vc = [[WQComfimController alloc] init];
        vc.phoneNumber = _model.cellphone;

        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

//- (void)handleTapGes:(id)sender {
//    
//    WQPhotoBrowser * browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
//    browser .currentPhotoIndex = 0;
//    browser.alwaysShowControls = NO;
//    
//    browser.displayActionButton = NO;
//    
//    browser.shouldTapBack = YES;
//    
//    browser.shouldHideNavBar = YES;
//    [self.viewController.navigationController pushViewController:browser animated:YES];
//
//}
//
//
//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
//    return 1;
//}
//
//- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
//    NSURL * url = [NSURL URLWithString:[imageUrlString stringByAppendingString:_model.pic_truename]];
//    
//    MWPhoto * photo = [MWPhoto photoWithURL:url];
//    return photo;
//    
//}



@end
