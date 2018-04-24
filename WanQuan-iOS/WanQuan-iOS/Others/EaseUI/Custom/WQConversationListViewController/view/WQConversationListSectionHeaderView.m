//
//  WQConversationListSectionHeaderView.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQConversationListSectionHeaderView.h"

@implementation WQConversationListSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)foldBidChat:(id)sender {
    
//    self.foldButton.selected = !self.foldButton.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(WQConversationListSectionHeaderViewFoldBidChatButtonOnclick:)]) {
        [self.delegate WQConversationListSectionHeaderViewFoldBidChatButtonOnclick:sender];
    }
}

@end
