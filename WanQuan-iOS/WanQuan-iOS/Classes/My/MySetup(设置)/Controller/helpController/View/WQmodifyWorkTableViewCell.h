//
//  WQmodifyWorkTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/9.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQTwoUserProfileModel,WQmodifyWorkTableViewCell;

@protocol WQmodifyWorkTableViewCellDelegate <NSObject>

- (void)wqkaishishijianBtnClikeDelegate:(WQmodifyWorkTableViewCell *)kaishiDelegate;
- (void)wqjieshushijianBtlClikeDelegata:(WQmodifyWorkTableViewCell *)jieshuDelegata;

@end

@interface WQmodifyWorkTableViewCell : UITableViewCell

@property (nonatomic, weak) id<WQmodifyWorkTableViewCellDelegate>delegate;

@property (nonatomic, strong) WQTwoUserProfileModel *model;
@property (nonatomic, strong) UILabel *titleLabel;
/**
 textField返回的内容
 */
@property(nonatomic,copy)void(^contentBlock)(NSString *content);
@property (weak, nonatomic) IBOutlet UILabel *kaishiTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jieshuTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *kaishiTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *jieshuTimeBtn;

@property (weak, nonatomic) IBOutlet UITextField *gongsimingcheng;
@property (weak, nonatomic) IBOutlet UITextField *kaishishijian;
@property (weak, nonatomic) IBOutlet UITextField *jiesushijian;
@property (weak, nonatomic) IBOutlet UITextField *zhiweimingcheng;

@end
