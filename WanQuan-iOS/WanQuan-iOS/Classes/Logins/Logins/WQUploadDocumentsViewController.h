//
//  WQUploadDocumentsViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/2/7.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQUploadDocumentsViewController;

@protocol WQUploadDocumentsVCDelegate <NSObject>

- (void)WQUploadDocumentsVCDelegate:(WQUploadDocumentsViewController *)vc picId:(NSMutableArray *)picIdArray;

@end

@interface WQUploadDocumentsViewController : UIViewController
@property (nonatomic, weak) id <WQUploadDocumentsVCDelegate> delegate;
@end
