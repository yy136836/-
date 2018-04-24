//
//  WQIndividualTrendsReplyCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2018/1/15.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQIndividualTrendSecondaryCommentModel.h"
@interface WQIndividualTrendsReplyCell : UITableViewCell
@property (retain, nonatomic) YYTextView *commentView;
@property (nonatomic, retain) WQIndividualTrendSecondaryCommentModel * model;
- (CGFloat)heightWithModel:(WQIndividualTrendSecondaryCommentModel *)model;
@end
