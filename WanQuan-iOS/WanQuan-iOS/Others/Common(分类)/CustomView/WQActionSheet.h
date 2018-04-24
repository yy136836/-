//
//  WQActionSheet.h
//  WanQuan-iOS
//
//  Created by Shmily on 2018/4/4.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQdynamicTableViewCell.h"

@class WQActionSheet;
@protocol WQActionSheetDelegate <NSObject>

- (void)clickedButton:(WQActionSheet *)sheetView ClickedName:(NSString *)name;




@end


@interface WQActionSheet : UIView
-(instancetype)initWithTitles:(NSArray *)names;


@property (nonatomic,weak)id<WQActionSheetDelegate>delegate;
- (void)show;


@property (nonatomic,retain)WQdynamicTableViewCell *dynamicCell;


@property (nonatomic,copy)NSString *saveImage;

@end
