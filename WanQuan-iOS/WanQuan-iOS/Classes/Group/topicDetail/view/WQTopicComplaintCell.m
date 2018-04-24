//
//  WQTopicComplaint Cell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/7.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTopicComplaintCell.h"

@interface WQTopicComplaintCell ()

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end


@implementation WQTopicComplaintCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _deleteBtn.hidden = YES;
    
    
}

- (IBAction)deleteOnclick:(id)sender {
    
    if (self.deleteTopic) {
        self.deleteTopic();
    }
}
- (IBAction)complaintOnclick:(id)sender {
    
    if (self.complaintTopic) {
        self.complaintTopic();
    }
}


@end
