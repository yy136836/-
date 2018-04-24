//
//  WQInvidualTrendsCommentAndReplyCellTableViewCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2018/1/11.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQIndividualTrendCommentModel.h"

@interface WQIndividualTrendsCommentAndReplyCell : UITableViewCell

@property (nonatomic, retain) WQIndividualTrendCommentModel * model;

- (CGFloat)heightWithModel:(WQIndividualTrendCommentModel *)model;
@end
