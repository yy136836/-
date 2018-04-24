//
//  WQInvidualTrendsCommentAndReplyCellTableViewCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2018/1/11.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQIndividualTrendsCommentAndReplyCell.h"
#import "WQCommentTextView.h"
#import "WQIndividualTrendsTableView.h"
@interface WQIndividualTrendsCommentAndReplyCell()
@property (weak, nonatomic) IBOutlet IBInspectable IB_DESIGNABLE UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet IBInspectable IB_DESIGNABLE UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet IBInspectable IB_DESIGNABLE UILabel *timeLabel;
@property (nonatomic, retain) WQIndividualTrendsTableView * commetsTabelView;

@end


@implementation WQIndividualTrendsCommentAndReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatarButton.showsTouchWhenHighlighted = NO;
    
    
}

- (void)setModel:(WQIndividualTrendCommentModel *)model {
    _model = model;
}



- (CGFloat)heightWithModel:(WQIndividualTrendCommentModel *)model {
    
    // TODO: 计算高度
    return 100;
}
- (IBAction)avatarOnClick:(UIButton *)sender {
}
- (IBAction)zanOnClick:(id)sender {
}
- (IBAction)commentOnClick:(id)sender {
}




@end
