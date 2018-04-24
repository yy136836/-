//
//  WQTopicDetailCommentView.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddImage)(UIButton * sender);

@interface WQTopicDetailCommentView : UIView
@property (weak, nonatomic) IBOutlet UITextField *commentField;

@end
