//
//  WQCommentDetailInfoCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/16.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQCommentAndReplyModel.h"

@protocol WQCommentDetailInfoCellShowDetailDelagete <NSObject>

- (void)WQCommentDetailInfoCellShowDetail:(WQCommentAndReplyModel*)model;
- (void)WQCommentDetailInfoCellDeleteComment:(WQCommentAndReplyModel *)model;

@end


//typedef void(^ShowTopicInfo)();

@interface WQCommentDetailInfoCell : UITableViewCell
@property (nonatomic, retain) WQCommentAndReplyModel * model;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *feedBackButton;
@property (nonatomic, retain) UIImageView * commentImageView;
@property (nonatomic, assign) CGFloat imageHeight;

//@property (nonatomic, assign) ShowTopicInfo showTopic;
@property (nonatomic, assign) id<WQCommentDetailInfoCellShowDetailDelagete> delegate;

- (CGFloat)heightWithModel:(WQCommentAndReplyModel *)model;
@end
