//
//  WQInvidualFavoredCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQUserProfileInvidualTrendsModel.h"
@interface WQInvidualFavoredCell : UITableViewCell
@property (nonatomic, retain) WQUserProfileInvidualTrendsModel * model;
- (void)adjustSapratorForLast;
- (void)adjustForCommon;
- (CGFloat)heightWithModel:(WQUserProfileInvidualTrendsModel *)model;
@end
