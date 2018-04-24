//
//  WQChatListController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/31.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQChatListController.h"
#import "WQConversationListHeader.h"
@interface WQChatListController ()

@property (nonatomic, retain)WQConversationListHeader * listHeader;

@end

@implementation WQChatListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _listHeader = (WQConversationListHeader *)self.tableView.tableHeaderView;
    
    [self fetchDotInfo];
    
}



- (void)fetchDotInfo {
    [self fetchSystemDot];
    [self fetchCircleInfo];
}

- (void)fetchSystemDot {
//    NSString * strURL = @"api/message/reddot";
//    
//    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
//    if (!secreteKey.length) {
//        return;
//    }
//    NSDictionary * param = @{@"secretkey":secreteKey};
//    
//    WQNetworkTools *tools = [WQNetworkTools sharedTools];
//    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
//        if (error) {
//            return ;
//        }
//        
//        
//        if ([response isKindOfClass:[NSData class]]) {
//            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
//        }
//        
//        ROOT(root);
//        
//        root.haveBidInfoToDealWith = [response[@"message_count"] boolValue];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:WQShouldHideRedNotifacation object:nil];
//    }];
    [[WQNetworkTools sharedTools] fetchRedDot];
}

- (void)fetchCircleInfo {
    
}



@end
