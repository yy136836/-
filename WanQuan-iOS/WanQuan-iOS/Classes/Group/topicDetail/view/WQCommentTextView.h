//
//  WQCommentTextView.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/16.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYTextView.h>
#import "WQGroupReplyModel.h"



@interface WQCommentTextView : YYTextView



@property (nonatomic, retain) WQGroupReplyModel * model;

@property (nonatomic, retain) NSMutableArray * rectsForTouch;


@end
