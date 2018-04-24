//
//  WQWaitOrderCollectionViewCell.h

//
//  Created
//  Copyright © 2016年 shihua. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 root-> 我的->我发的需求->待选定 cell
 */
@interface WQWaitOrderCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSMutableArray *detailOrderData;

@property (nonatomic, copy) void(^pushxiangqingClikeBlock)(NSString *);
@property (nonatomic, copy) void(^xiangqingWQDefaultTasksBlock)(NSString *);
- (void)loadData;


@end
