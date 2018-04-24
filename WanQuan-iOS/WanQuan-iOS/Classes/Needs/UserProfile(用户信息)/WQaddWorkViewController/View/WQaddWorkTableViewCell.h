//
//  WQaddWorkTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQaddWorkTableViewCell;

@protocol WQaddWorkTableViewCellDelegate <NSObject>

- (void)wqkaishishijianBtnClikeDelegate:(WQaddWorkTableViewCell *)kaishiDelegate;
- (void)wqjieshushijianBtnClikeDelegate:(WQaddWorkTableViewCell *)jieshuDelegate;

@end

@interface WQaddWorkTableViewCell : UITableViewCell
@property (nonatomic, weak) id <WQaddWorkTableViewCellDelegate> delegate;
@property (nonatomic, copy) void (^contentBlock)(NSString *);

@property (weak, nonatomic) IBOutlet UITextField *gongsimingcheng;
@property (weak, nonatomic) IBOutlet UILabel *kaishishijian;
@property (weak, nonatomic) IBOutlet UILabel *jiesushijian;
@property (weak, nonatomic) IBOutlet UITextField *zhiweimingcheng;

@end
