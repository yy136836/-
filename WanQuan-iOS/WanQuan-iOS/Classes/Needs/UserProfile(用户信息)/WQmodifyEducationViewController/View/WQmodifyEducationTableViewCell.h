//
//  WQmodifyEducationTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQmodifyEducationTableViewCell;

@protocol WQmodifyEducationTableViewCellDelegate <NSObject>

- (void)wqkaishishijianBtnClikeDelegate:(WQmodifyEducationTableViewCell *)kaishiDelegate;
- (void)wqjieshushijianBtlClikeDelegata:(WQmodifyEducationTableViewCell *)jieshuDelegata;

@end

@interface WQmodifyEducationTableViewCell : UITableViewCell

@property (nonatomic, weak) id <WQmodifyEducationTableViewCellDelegate>delegata;
@property (weak, nonatomic) IBOutlet UILabel *kaishiTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiesuTimeLabel;

//学校名称
@property (weak, nonatomic) IBOutlet UITextField *schoolTextField;
//入学时间
@property (weak, nonatomic) IBOutlet UITextField *enteringSchoolTextField;
//毕业时间
@property (weak, nonatomic) IBOutlet UITextField *graduateTextField;
//专业名称
@property (weak, nonatomic) IBOutlet UITextField *specialtyTextField;
//学位名称
//@property (weak, nonatomic) IBOutlet UITextField *degreesTextField;
/**
 textField返回的内容
 */
@property (weak, nonatomic) IBOutlet UILabel *aDegreeInLabel;
@property (nonatomic, copy) void (^contentBlock)(NSString *content);
@property (nonatomic, copy) void (^aDegreeInBtnClikeBlock)();

@end
