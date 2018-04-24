//
//  WQpublishTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/22.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQpublishTableViewCell.h"
#import "WQUserProfileController.h"

@interface WQpublishTableViewCell ()
@property (weak, nonatomic) IBOutlet UISwitch *anonymitySwitch;

@end

@implementation WQpublishTableViewCell
- (IBAction)switchConlOperation:(UISwitch *)sender {
    
    if (![WQDataSource sharedTool].isVerified) {
        // 快速注册的用户
        UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"实名认证后可选择匿名"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 NSLog(@"取消");
                                                             }];
        UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"实名认证"
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      NSLog(@"%@",[WQDataSource sharedTool].userIdString);
                                                                      WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:[WQDataSource sharedTool].userIdString];
                                                                      
                                                                      [self.viewController.navigationController pushViewController:vc animated:YES];
                                                                  }];
        [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
        [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
        
        [alertController addAction:cancelButton];
        [alertController addAction:destructiveButton];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
        [sender setOn:NO];
    }
    
    BOOL whetheranonymous;
    if (sender.isOn) {
        NSLog(@"打开了");
        whetheranonymous = YES;
        if (self.boolwhetheranonymousBlock != nil) {
            self.boolwhetheranonymousBlock(whetheranonymous);
        }
    }else{
        NSLog(@"关闭了");
        whetheranonymous = NO;
        if (self.boolwhetheranonymousBlock != nil) {
            self.boolwhetheranonymousBlock(whetheranonymous);
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.anonymitySwitch.on = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
