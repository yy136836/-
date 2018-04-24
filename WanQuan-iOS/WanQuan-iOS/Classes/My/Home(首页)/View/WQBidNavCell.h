//
//  WQBidNavCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/16.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WQBidNavCellDelegate <NSObject>

- (void)bidNavCellDelegateSelectAt:(NSInteger)i;

@end

@interface WQBidNavCell : UITableViewCell

@property (nonatomic, assign) id<WQBidNavCellDelegate> delegate;

@property (nonatomic, assign) BOOL havePostedToDealWith;
@property (nonatomic, assign) BOOL haveAcceptedToDealWith;
@property (nonatomic, assign) BOOL haveInquiryToDealWith;
@end
