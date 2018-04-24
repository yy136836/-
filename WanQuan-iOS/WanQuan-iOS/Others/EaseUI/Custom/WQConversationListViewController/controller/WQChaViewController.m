//
//  WQChaViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/6.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQChaViewController.h"
#import "WQTabBarController.h"
@interface WQChaViewController ()

@end

@implementation WQChaViewController

//- (instancetype)initWithConversationId:(NSString *)ConversationId ConversationType:(EMConversationType)ConversationType
//{
//    self = [super initWithNibName:@"WQChaViewController" bundle:nil];
//    if (self) {
//        _conversation = [[EMClient sharedClient].chatManager getConversation:ConversationId type:ConversationType createIfNotExist:YES];
//    }
//    return self;
//}
//- (IBAction)btnClike:(id)sender {
//    EMTextMessageBody *body = [[EMTextMessageBody alloc]initWithText:_inputText.text];
//    EMMessage *message = [[EMMessage alloc]initWithConversationID:_conversation.conversationId from:[EMClient sharedClient].currentUsername to:_conversation.conversationId body:body ext:nil];
//    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
//        if (!error) {
//            NSLog(@"消息发送成功");
//        }else
//        {
//            NSLog(@"消息发送失败");
//        }
//    }];
//}

- (void)dealloc {
    WQTabBarController * main = (WQTabBarController * )[UIApplication sharedApplication].delegate.window.rootViewController;
    if (![main isKindOfClass:[WQTabBarController class]]) {
        return;
    }
    
    [main setupUnreadMessageCount:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    EMMessage * message = [[EMMessage alloc] initWithConversationID:nil from:nil to:nil body:nil ext:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
