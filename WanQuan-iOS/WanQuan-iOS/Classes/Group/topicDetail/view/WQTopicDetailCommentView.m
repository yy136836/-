//
//  WQTopicDetailCommentView.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTopicDetailCommentView.h"

@implementation WQTopicDetailCommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSDictionary *titleDict = @{NSFontAttributeName : [UIFont systemFontOfSize:12],
                                NSForegroundColorAttributeName : [UIColor colorWithHex:0x878787]};
    // 图片文本
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"comment_pinglun"];
    attachment.bounds = CGRectMake(0, 0, 13, 13);
    NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attachment];
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:@" 评论" attributes:titleDict];
    // 合并文字
    NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] initWithAttributedString:imageText];
    [attM appendAttributedString:text];
    
    _commentField.attributedPlaceholder = attM;
    self.layer.borderColor = [UIColor colorWithHex:0xcbcbcb].CGColor;
    self.layer.borderWidth = 0.5;
    
    _commentField.returnKeyType = UIReturnKeySend;
    
}



@end
