//
//  WQTopicTypeMessageHeader.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/4.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Ontap)();

@interface WQTopicTypeMessageHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *groupNamelabel;

@property (nonatomic, copy) Ontap ontap;
- (IBAction)showTopicInfo:(id)sender;

@end
