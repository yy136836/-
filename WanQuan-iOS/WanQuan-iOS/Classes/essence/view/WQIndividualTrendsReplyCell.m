//
//  WQIndividualTrendsReplyCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2018/1/15.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQIndividualTrendsReplyCell.h"
#import "WQUserProfileController.h"
@interface WQIndividualTrendsReplyCell()<YYTextViewDelegate>
@end

@implementation WQIndividualTrendsReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _commentView = [[YYTextView alloc] init];
    _commentView.editable = NO;
    [self.contentView addSubview:_commentView];
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
    }];
    _commentView.textContainerInset = UIEdgeInsetsZero;
    _commentView.delegate = self;
    _commentView.dataDetectorTypes =   UIDataDetectorTypePhoneNumber|UIDataDetectorTypeLink;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}



- (void)setModel:(WQIndividualTrendSecondaryCommentModel *)model {
    _model = model;
    
    UIFont * font = [UIFont systemFontOfSize:14];
    UIColor * linkColor = [UIColor colorWithHex:0x9767d0];
    UIColor * commenColor = [UIColor colorWithHex:0x333333];
    NSMutableParagraphStyle * style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    style.lineSpacing = 5;
    
    
    NSDictionary * userNameAttr = @{
                                    NSForegroundColorAttributeName:linkColor,
                                    NSLinkAttributeName:model.user_id?:@"",
                                    NSFontAttributeName:font,
                                    NSParagraphStyleAttributeName:style
                                    };
    
    NSDictionary * replyNameAttr = @{
                                     NSForegroundColorAttributeName:linkColor,
                                     NSLinkAttributeName:model.reply_user?model.reply_user_id:@"",
                                     NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName:style
                                     };
    
    NSDictionary * commonAttr = @{
                                  NSForegroundColorAttributeName:commenColor,
                                  NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName:style
                                  };
    
    
    
    NSMutableAttributedString * attrText = [[NSMutableAttributedString alloc] init];
    
    NSString * reply = [NSString stringWithFormat:@":%@",model.content];
    
    if (model.reply_user) {
        [attrText appendAttributedString:[[NSAttributedString alloc] initWithString:model.user_name attributes:userNameAttr]];
        
        NSRange range = [attrText.string rangeOfString:model.user_name];
        
        [attrText yy_setTextHighlightRange:range color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            WQUserProfileController * vc = [[WQUserProfileController alloc] initWithUserId:model.user_id];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }];
        
        [attrText appendAttributedString:[[NSAttributedString alloc] initWithString:@"回复" attributes:commonAttr]];
        [attrText appendAttributedString:[[NSAttributedString alloc] initWithString:model.reply_user_name attributes:replyNameAttr]];
        NSRange range1 = [attrText.string rangeOfString:model.reply_user_name];
        
        
        [attrText yy_setTextHighlightRange:range1 color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            WQUserProfileController * vc = [[WQUserProfileController alloc] initWithUserId:model.user_id];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }];
        
        
        [attrText appendAttributedString:[[NSAttributedString alloc] initWithString:reply attributes:commonAttr]];
        
    } else {
        
        [attrText appendAttributedString:[[NSAttributedString alloc] initWithString:model.user_name?:@"" attributes:userNameAttr]];
        
        [attrText appendAttributedString:[[NSAttributedString alloc] initWithString:reply attributes:commonAttr]];
        NSRange range = [attrText.string rangeOfString:model.user_name];
        [attrText yy_setTextHighlightRange:range color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            WQUserProfileController * vc = [[WQUserProfileController alloc] initWithUserId:model.user_id];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }];
    }
    
    self.commentView.attributedText = attrText;

}


- (CGFloat)heightWithModel:(WQIndividualTrendSecondaryCommentModel *)model {
    
    NSString * userName = model.user_name;
    NSString * replyUserName;
    NSString * addOn;
    if (model.reply_user_name.length) {
        replyUserName = model.reply_user_name;
        addOn = @"回复:";
    } else {
        replyUserName = @"";
        addOn = @":";
    }
    
    NSString * replyContent = [NSString stringWithFormat:@"%@%@%@%@",userName,replyUserName,addOn,model.content];
    NSMutableParagraphStyle * style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    style.lineSpacing = 5;
    
    CGRect rect = [replyContent boundingRectWithSize:CGSizeMake(kScreenWidth - 105, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                                       NSParagraphStyleAttributeName : style}
                                             context:nil];
    
    
    return rect.size.height + 5;
}


@end
