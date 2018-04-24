//
//  WQInvidualCircleCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQUserProfileInvidualTrendsModel.h"

typedef void(^LinkOnTap)(void);

@interface WQInvidualCircleCell : UITableViewCell
@property (nonatomic, retain) WQUserProfileInvidualTrendsModel * model;
@property (nonatomic, copy) LinkOnTap linkOnTap;
@property (nonatomic, retain) UIView * sep;

- (void)adjustSapratorForLast;

- (void)adjustForCommon;


- (CGFloat)heightWithModel:(WQUserProfileInvidualTrendsModel *)model;
@end
