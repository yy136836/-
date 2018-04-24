//
//  ConversationListViewController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/11/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "OriginalEaseConversationListViewController.h"

@interface ConversationListViewController : OriginalEaseConversationListViewController

@property (strong, nonatomic) NSMutableArray *conversationsArray;

- (void)refresh;
- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;



@end
