//
//  WQParticularCommentCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/30.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQcommentListModel.h"

@protocol ParticularCommentCellReplyDelegate <NSObject>

- (void)particularCommentCellReplyTo:(WQcommentListModel *)model;
- (void)particularCommentCellshowLogin;

@end

@interface WQParticularCommentCell : UITableViewCell
@property (nonatomic, strong) WQcommentListModel *model;
@property (nonatomic, assign) id<ParticularCommentCellReplyDelegate> delegate;

- (CGFloat)heightWhithModel:(WQcommentListModel *)model;
@end
