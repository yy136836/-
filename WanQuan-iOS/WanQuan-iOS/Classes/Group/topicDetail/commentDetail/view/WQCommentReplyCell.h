//
//  WQCommentReplyCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/16.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQCommentTextView.h"
#import "WQGroupReplyModel.h"

@class WQCommentReplyCell;
typedef void(^DeleteReply)(WQGroupReplyModel * model);

typedef void(^SelectAt)(WQCommentReplyCell * cell);

@interface WQCommentReplyCell : UITableViewCell



@property (nonatomic, retain) WQGroupReplyModel * model;
@property (retain, nonatomic) YYTextView *commentTextVIew;
@property (nonatomic, copy) DeleteReply deleteReply;
@property (nonatomic, copy) SelectAt select;
@end
