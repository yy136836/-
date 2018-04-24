//
//  WQBidNavCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/16.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQBidNavCell.h"


@interface WQBidNavBtn : UIButton<WZLBadgeProtocol>

@end
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wobjc-protocol-property-synthesis"
@implementation WQBidNavBtn

#pragma clang diagnostic pop

@end

#define TAG_NAV_BTN 10000

@interface WQBidNavCell ()
@property (nonatomic, retain) UIButton * left;
@property (nonatomic, retain) UIButton * middle;
@property (nonatomic, retain) UIButton * right;
@property (nonatomic, retain) UIButton * selectedButton;

@end

@implementation WQBidNavCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEX(0xf9f9f9);
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _left = [[WQBidNavBtn alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth / 3 + 10, 43.5)];
    _middle = [[WQBidNavBtn alloc] initWithFrame:CGRectMake(kScreenWidth / 3 - 10, 0, kScreenWidth / 3 + 20, 43.5)];
    _right = [[WQBidNavBtn alloc] initWithFrame:CGRectMake(kScreenWidth / 3 * 2 - 10, 0, kScreenWidth / 3 + 10, 43.5)];
    [self.contentView addSubview:_left];
    [self.contentView addSubview:_right];
    [self.contentView addSubview:_middle];
    
    
    UIImage * leftBg = [UIImage imageNamed:@"zuo"];
    leftBg = [leftBg stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    UIImage * rightBg = [UIImage imageNamed:@"you"];
    rightBg = [rightBg stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    UIImage * middleBg = [UIImage imageNamed:@"zhong"];
    middleBg = [middleBg stretchableImageWithLeftCapWidth:40 topCapHeight:0];
    
    [_left setBackgroundImage:leftBg forState:UIControlStateSelected];
    [_right setBackgroundImage:rightBg forState:UIControlStateSelected];
    [_middle setBackgroundImage:middleBg forState:UIControlStateSelected];
    
    _left.titleLabel.font = kScreenWidth == 320?[UIFont boldSystemFontOfSize:14] : [UIFont boldSystemFontOfSize:15];
    _right.titleLabel.font = kScreenWidth == 320?[UIFont boldSystemFontOfSize:14] : [UIFont boldSystemFontOfSize:15];
    _middle.titleLabel.font = kScreenWidth == 320?[UIFont boldSystemFontOfSize:14] : [UIFont boldSystemFontOfSize:15];
    
    [_left setTitle:@"我发的需求" forState:UIControlStateNormal];
    [_right setTitle:@"我询问的需求" forState:UIControlStateNormal];
    [_middle setTitle:@"我接的需求" forState:UIControlStateNormal];
    

    
    [_left setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(100, 100)] forState:UIControlStateNormal];
    [_right setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(100, 100)] forState:UIControlStateNormal];
    [_middle setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(100, 100)] forState:UIControlStateNormal];
    
    [_right setTitleColor:HEX(0x212121) forState:UIControlStateSelected];
    [_right setTitleColor:HEX(0x878787) forState:UIControlStateNormal];
    
    [_left setTitleColor:HEX(0x212121) forState:UIControlStateSelected];
    [_left setTitleColor:HEX(0x878787) forState:UIControlStateNormal];
    
    [_middle setTitleColor:HEX(0x212121) forState:UIControlStateSelected];
    [_middle setTitleColor:HEX(0x878787) forState:UIControlStateNormal];
    

    _left.tag = TAG_NAV_BTN;
    _middle.tag = TAG_NAV_BTN + 1;
    _right.tag = TAG_NAV_BTN + 2;
    
    _left.selected = YES;
    _selectedButton = _left;
    [_left addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_right addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_middle addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
 

}

- (void)setHavePostedToDealWith:(BOOL)havePostedToDealWith {
    
    _havePostedToDealWith = havePostedToDealWith;
    if (havePostedToDealWith) {
        [_left showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
        _left.badge.frame = CGRectMake(_left.badge.x - 10, _left.badge.y, _left.badge.width, _left.badge.height);


    }
}

- (void)setHaveAcceptedToDealWith:(BOOL)haveAcceptedToDealWith {
    _haveAcceptedToDealWith = haveAcceptedToDealWith;
    if (haveAcceptedToDealWith) {
        [_middle showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
        _middle.badge.frame = CGRectMake(_middle.badge.x - 10, _middle.badge.y, _middle.badge.width, _middle.badge.height);
    }
}


- (void)setHaveInquiryToDealWith:(BOOL)haveInquiryToDealWith {
    _haveInquiryToDealWith = haveInquiryToDealWith;
    if (haveInquiryToDealWith) {
        [_right showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
        _right.badge.frame = CGRectMake(_right.badge.x - 10, _right.badge.y, _right.badge.width, _right.badge.height);
        
    }
}

- (void)onClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    _selectedButton.selected = NO;
    _selectedButton = sender;
    sender.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(bidNavCellDelegateSelectAt:)]) {
        
        [self.delegate bidNavCellDelegateSelectAt:sender.tag - TAG_NAV_BTN];
    }
}



@end
