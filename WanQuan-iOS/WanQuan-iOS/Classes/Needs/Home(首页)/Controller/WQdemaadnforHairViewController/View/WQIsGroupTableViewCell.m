//
//  WQIsGroupTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQIsGroupTableViewCell.h"
#import "WQUserProfileController.h"

@interface WQIsGroupTableViewCell ()
@property (weak, nonatomic) IBOutlet UISwitch *anonymitySwitch;
@end

@implementation WQIsGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.anonymitySwitch.on = NO;
    // Initialization code
}
- (IBAction)switchConlOperation:(UISwitch *)sender {
    BOOL whetheranonymous;
    if (sender.isOn) {
        NSLog(@"打开了");
        whetheranonymous = YES;
        if (self.isForwardingNeedsBlock) {
            self.isForwardingNeedsBlock(whetheranonymous);
        }
    }else{
        NSLog(@"关闭了");
        whetheranonymous = NO;
        if (self.isForwardingNeedsBlock) {
            self.isForwardingNeedsBlock(whetheranonymous);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
