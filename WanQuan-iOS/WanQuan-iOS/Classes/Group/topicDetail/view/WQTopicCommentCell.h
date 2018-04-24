//
//  WQTopicCommentCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQCommentAndReplyModel.h"
@class WQTopicCommentCell;
@protocol WQTopicCommentCellDelegate <NSObject>

- (void)WQTopicCommentCellD:(WQTopicCommentCell *)cell addCommentWithId:(NSString *)tid;
- (void)WQTopicCommentCellDelegateshowMore:(WQCommentAndReplyModel *)model;

@end


@interface WQTopicCommentCell : UITableViewCell

@property (nonatomic, retain) WQCommentAndReplyModel * model;
@property (nonatomic, assign) id<WQTopicCommentCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (nonatomic, assign) CGFloat addHeight;

@end
