
//
//  WQMyHomeHeaderView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/11.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQMyHomeHeaderView.h"

@implementation WQMyHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    UIImageView *avatarImage = [[UIImageView alloc] init];
    self.avatarImage = avatarImage;
    avatarImage.contentMode = UIViewContentModeScaleAspectFill;
    avatarImage.layer.cornerRadius = 5;
    avatarImage.layer.masksToBounds = YES;
    
    [self addSubview:avatarImage];
    
    [avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(50);
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(15);
    }];
    
    UILabel *userName = [[UILabel alloc] init];
    self.userName = userName;
    userName.font = [UIFont systemFontOfSize:18];
    userName.textColor = [UIColor colorWithHex:0x303030];
    
    [self addSubview:userName];
    
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarImage.mas_right).offset(15);
        make.top.equalTo(avatarImage.mas_top).offset(7);
    }];
    
    UILabel *tagoncLabel = [[UILabel alloc] init];
    self.tagoncLabel = tagoncLabel;
    tagoncLabel.font = [UIFont systemFontOfSize:14];
    tagoncLabel.textColor = [UIColor colorWithHex:0x666666];
    
    [self addSubview:tagoncLabel];
    
    [tagoncLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userName.mas_left);
        make.top.equalTo(userName.mas_bottom).offset(8);
    }];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn addTarget:self action:@selector(btnClike) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
//        make.top.right.bottom.equalTo(self);
//        make.left.equalTo(userName.mas_left);
    }];
    
    
    _flagImageView = ({
        UIImageView * imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"zhanweitu"];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_centerY);
        }];
        imageView;
    });
}

#pragma mark - 响应事件
- (void)btnClike {
    if (self.MyHomeHeaderbtnClikeBlock) {
        self.MyHomeHeaderbtnClikeBlock();
    }
}

@end
