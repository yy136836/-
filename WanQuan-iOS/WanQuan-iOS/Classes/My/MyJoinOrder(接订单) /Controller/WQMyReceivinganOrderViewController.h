//
//  WQMyReceivinganOrderViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/7.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQMyOrderViewController.h"
//typedef NS_ENUM(NSUInteger, BidType) {
//    BidTypeToSelect,
//    BidTypeSelected,
//    BidTypeComplete
//};

@interface WQMyReceivinganOrderViewController : UIViewController
@property (nonatomic, retain) NSArray * toSelectBidIds;
@property (nonatomic, retain) NSArray * selectedBidIds;
@property (nonatomic, retain) NSArray * completeBidIds;
@property (nonatomic, retain) UIButton *AwaitOrderBtn;
@property (nonatomic, retain) UIButton *GetingBtn;
@property (nonatomic, retain) UIButton *GettedBtn;

- (void)hideOrShowDotForBills:(NSArray *)billIds ofBidType:(BidType)type;
@end
