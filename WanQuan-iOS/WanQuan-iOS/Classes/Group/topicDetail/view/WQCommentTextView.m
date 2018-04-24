//
//  WQCommentTextView.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/16.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQCommentTextView.h"
#import <NSAttributedString+YYText.h>
#import "WQUserProfileController.h"
@implementation WQCommentTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHex:0xededed];
        self.editable = NO;
        self.textContainerInset = UIEdgeInsetsMake(7, 5, 5, 5);
        self.selectable = NO;
    }
    return self;
}



- (void)setModel:(WQGroupReplyModel *)model {
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
                                     NSLinkAttributeName:model.reply_user_name?:@"",
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
    
   

//    如果是二级回复
    if (model.reply) {
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
    

    
    self.attributedText = attrText;
    

    
    self.frame = CGRectMake(self.x, self.y, self.width, self.contentSize.height);
}







- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}




@end
