//
//  EaseBubbleView+WQGroupRecommend.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "EaseBubbleView+WQGroupRecommend.h"

#define LEFT (self.isSender?10:15)
#define RIGHT (self.isSender?-10:-5)
#define LEFT0 (self.isSender?3:7)
#define RIGHT0 (self.isSender?-7:-3)

@implementation EaseBubbleView (WQGroupRecommend)

#pragma mark - private

- (void)setupGroupRecommendBubbleConstraints {
    
//    @property (strong, nonatomic) YYLabel * groupNamelabel;
//    @property (strong, nonatomic) UIImageView * groupImageView;
//    @property (strong, nonatomic) YYLabel * groupInfoLabel;
//    @property (strong, nonatomic) YYLabel * groupMemberNumberLabel;
//    @property (strong, nonatomic) UIView * line;
//    [self.marginConstraints removeAllObjects];
    
    [self.groupNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView).offset(10);
        make.left.equalTo(self.backgroundImageView).offset(LEFT);
        make.right.equalTo(self.backgroundImageView).offset(RIGHT);
//        make.height.equalTo(@20);
    }];
    
    
//    if (!self.isSender) {
        [self.groupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backgroundImageView).offset(LEFT);
            make.top.equalTo(self.groupNamelabel.mas_bottom).offset(10);
            make.width.height.equalTo(@40);
        }];
        
        [self.groupInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.groupImageView.mas_right).offset(5);
            make.right.equalTo(self.backgroundImageView).offset(RIGHT);
            make.top.equalTo(self.groupImageView);
            make.height.equalTo(self.groupImageView);
        }];
//    } else {
//        [self.groupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.backgroundImageView).offset(RIGHT);
//            make.top.equalTo(self.groupNamelabel.mas_bottom).offset(3);
//            make.width.height.equalTo(@40);
//        }];
//        
//        [self.groupInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.backgroundImageView.mas_left).offset(5);
//            make.right.equalTo(self.backgroundImageView).offset(RIGHT);
//            make.top.equalTo(self.groupImageView);
//            make.height.equalTo(self.groupImageView);
//        }];
//    }


        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backgroundImageView).offset(LEFT0);
            make.right.equalTo(self.backgroundImageView).offset(RIGHT0);
            make.height.equalTo(@0.5);
        }];


    
    [self.groupMemberNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundImageView).offset(LEFT);
        make.right.equalTo(self.backgroundImageView).offset(RIGHT);
        make.top.equalTo(self.line).offset(4);
        make.bottom.equalTo(self.backgroundImageView).offset(-6);
        make.height.equalTo(@12);
    }];

    self.userInteractionEnabled = YES;
}



#pragma mark - public




- (void)setupGroupRecommendBubbleView {
    
    
    self.groupNamelabel = [[YYLabel alloc] init];
    self.groupNamelabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.groupNamelabel.backgroundColor = [UIColor clearColor];
//    self.groupNamelabel.textContainerInset = UIEdgeInsetsMake(0, 0, 5, 5);
    [self.backgroundImageView addSubview:self.groupNamelabel];
//    self.groupNamelabel.attributedTex = [UIColor]
    
    self.groupImageView = [[UIImageView alloc] init];
    self.groupImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.groupImageView.backgroundColor = [UIColor clearColor];
    self.groupImageView.animationDuration = 1;
    [self.backgroundImageView addSubview:self.groupImageView];
    
    self.groupInfoLabel = [[YYLabel alloc] init];
    self.groupInfoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.groupInfoLabel.backgroundColor = [UIColor clearColor];
    self.groupInfoLabel.numberOfLines = 3;
//    self.groupInfoLabel.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.groupInfoLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    [self.backgroundImageView addSubview:self.groupInfoLabel];
    
    self.groupMemberNumberLabel = [[YYLabel alloc] init];
    self.groupMemberNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.groupMemberNumberLabel.backgroundColor = [UIColor clearColor];
//    self.groupMemberNumberLabel.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.backgroundImageView addSubview:self.groupMemberNumberLabel];
    
    self.line = [[UIView alloc] init];
    [self.backgroundImageView addSubview:self.line];
    self.line.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    [self setupGroupRecommendBubbleConstraints];
}

- (void)updateGroupRecommendBubbleViewMargin:(UIEdgeInsets)margin {
    
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    
    [self removeConstraints:self.marginConstraints];
    [self setupGroupRecommendBubbleView];
    
    
}








@end
