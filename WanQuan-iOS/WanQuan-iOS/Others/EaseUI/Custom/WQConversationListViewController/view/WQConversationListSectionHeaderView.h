//
//  WQConversationListSectionHeaderView.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WQConversationListSectionHeaderViewFoldBidChat <NSObject>

- (void)WQConversationListSectionHeaderViewFoldBidChatButtonOnclick:(UIButton *)sender;

@end


@interface WQConversationListSectionHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *foldButton;
@property (nonatomic, assign) id<WQConversationListSectionHeaderViewFoldBidChat> delegate;
@end
