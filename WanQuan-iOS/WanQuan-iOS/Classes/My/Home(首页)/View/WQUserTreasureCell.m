//
//  WQUserTreasureCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUserTreasureCell.h"
#import "WZLBadgeImport.h"

#define TITLES @[@"我的钱包",@"我的信用",@"我的好友"]
#define IMAGE_NAMES @[@"qianbao",@"wodexinyong",@"wodehaoyou"]

@interface WQUserTreasureButton : UIButton
@property (nonatomic, retain) UIView * redDot;
@end

@implementation WQUserTreasureButton


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
        self.showsTouchWhenHighlighted = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:HEX(0x262626) forState:UIControlStateNormal];
        _redDot = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width / 2  + 25 - 10, frame.size.width /2 - 50 / 2 - 14, 10, 10)];
        [self addSubview:_redDot];
        _redDot.hidden = YES;
        _redDot.backgroundColor = [UIColor redColor];
        _redDot.layer.cornerRadius = 5;
        _redDot.layer.masksToBounds = YES;
        
        
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(kScreenWidth / 6 - 50 / 2, 20, 50, 50);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 70, kScreenWidth / 3, 50);
}



@end

@interface WQUserTreasureCell ()
@property (nonatomic, retain)WQUserTreasureButton * friendButton;
@end

@implementation WQUserTreasureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    for (NSInteger i = 0 ; i < 3 ; ++ i) {
        WQUserTreasureButton * btn = [[WQUserTreasureButton alloc] initWithFrame:CGRectMake(i * kScreenWidth / 3, 0, kScreenWidth / 3, 120)];
        [self.contentView addSubview:btn];
        [btn setTitle:TITLES[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:IMAGE_NAMES[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 2) {
            _friendButton = btn;
        }

        if (i == 0) {
            UILabel *label = [UILabel labelWithText:@"10" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:15];
            self.qianbaoyueeLabel = label;
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(btn.mas_centerX);
                make.top.equalTo(btn.imageView.mas_bottom).offset(37);
            }];
        }
        if (i == 1) {
            UILabel *label = [UILabel labelWithText:@"70" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:15];
            self.xinyongfenLabel = label;
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(btn.mas_centerX);
                make.top.equalTo(btn.imageView.mas_bottom).offset(37);
            }];
        }
        if (i == 2) {
            UILabel *label = [UILabel labelWithText:@"15" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:15];
            self.haoyouLabel = label;
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(btn.mas_centerX);
                make.top.equalTo(btn.imageView.mas_bottom).offset(37);
            }];
        }
    }
}

- (void)onclick:(UIButton *)sender {
    
    if ([sender.currentTitle isEqualToString:TITLES[0]]) {
        
        if (self.purseOnclick) {
            self.purseOnclick();
        }
    }
    if ([sender.currentTitle isEqualToString:TITLES[1]]) {
        
        if (self.creditOnclick) {
            self.creditOnclick();
        }
    }
    if ([sender.currentTitle isEqualToString:TITLES[2]]) {
        
        if (self.friendOnclick) {
            self.friendOnclick();
        }
    }
}

- (void)showFriendBadge {
    ROOT(root);
    self.friendButton.redDot.hidden = !root.haveFriendapply;
}

@end
