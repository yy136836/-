//
//  WQDatataskAlertView.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/10/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQDatataskAlertView : UIAlertView
@property (nonatomic, retain) NSURLSessionDataTask * dataTask;

- (void)resumeTask;
- (void)cancelTask;

@end
