//
//  WQUserCreditAndFriendDegreeView.h
//  WanQuan-iOS
//
//  Created by hanyang on 2018/1/11.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQUserCreditAndFriendDegreeView : UIView

- (void)setCreditNumber:(NSInteger)creditNumber;
- (void)setFriendDegree:(NSInteger)friendDegree;
- (instancetype)init;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
