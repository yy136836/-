//
//  WQorderDetailsTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYLabel.h>

@class WQHomeNearby,WQorderDetailsTableViewCell;

@protocol WQorderDetailsTableViewCellDelegate <NSObject>

- (void)wqToReceiveBtnClike:(WQorderDetailsTableViewCell *)orderDetailsTableViewCell;
- (void)wqdeleteBtnClike:(WQorderDetailsTableViewCell *)orderDetailsTableViewCell;

@end

@interface WQorderDetailsTableViewCell : UITableViewCell

@property (nonatomic, weak) id <WQorderDetailsTableViewCellDelegate>delegate;
@property (nonatomic, strong) WQHomeNearby *model;
// 是否从群组BBS来的
@property (nonatomic, assign) BOOL isGroup;
// 是否从群组过来,并且是不是群主
@property (nonatomic, assign) BOOL isGroupManager;
// 是否是自己发的订单
@property (nonatomic, assign) BOOL isYourOwn;
// 标题
@property (nonatomic, strong) UILabel *subjectLabel;
// 内容
@property (nonatomic, strong) YYLabel *contentLabel;
// 金额
//@property (nonatomic, strong) UILabel *moneyLabel;
// 标题下的线
@property (nonatomic, strong) UIView *separatedView;
// 图片arrAy
@property (nonatomic, strong) NSArray *picArray;
// 资质要求
@property (nonatomic, strong) UILabel *qualificationContentLabel;
// 是否领取
@property (nonatomic, assign) BOOL whetherOrNotToReceive;
// 红包
@property (nonatomic, strong) UIImageView *redEnvelopeImageView;
// 红包下的label
@property (nonatomic, strong) UILabel *redEnvelopeLabel;
@end
