//
//  WQMyOrderViewController.h
//
//  Created
//  Copyright © 2016年 shihua. All rights reserved.
//    

#import <UIKit/UIKit.h>

/**
 root-> 我的->我发的订单
 */

typedef NS_ENUM(NSUInteger, BidType) {
    BidTypeToSelect,
    BidTypeSelected,
    BidTypeComplete
};

@interface WQMyOrderViewController : UIViewController

@property (nonatomic, retain) NSArray * toSelectBidIds;
@property (nonatomic, retain) NSArray * selectedBidIds;
@property (nonatomic, retain) NSArray * completeBidIds;
@property (nonatomic, retain) UIButton *AwaitOrderBtn;
@property (nonatomic, retain) UIButton *GetingBtn;
@property (nonatomic, retain) UIButton *GettedBtn;

- (void)hideOrShowDotForBills:(NSArray *)billIds ofBidType:(BidType)type;

@end
