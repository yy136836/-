//
//  WQDatataskAlertView.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/10/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQDatataskAlertView.h"

@implementation WQDatataskAlertView

- (void)resumeTask {
    if (_dataTask) {
        [_dataTask resume];
    }
}

- (void)cancelTask {
    if (_dataTask) {
        [_dataTask cancel];
    }
}
@end
