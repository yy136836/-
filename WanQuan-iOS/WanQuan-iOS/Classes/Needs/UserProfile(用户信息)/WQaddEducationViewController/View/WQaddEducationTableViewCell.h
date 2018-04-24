//
//  WQaddEducationTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQaddEducationTableViewCell;

@protocol WQaddEducationTableViewCellDelegate <NSObject>

- (void)wqkaishishijianBtnClikeDelegate:(WQaddEducationTableViewCell *)kaishiDelegate;
- (void)wqbiyeshijianBtnClikeDelegate:(WQaddEducationTableViewCell *)jieshuDelegate;

@end

@interface WQaddEducationTableViewCell : UITableViewCell
@property (nonatomic, weak) id <WQaddEducationTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *schoolTextField;   //学校名称
@property (weak, nonatomic) IBOutlet UILabel *enteringSchool;        //入学时间
@property (weak, nonatomic) IBOutlet UILabel *graduate;              //毕业时间
@property (weak, nonatomic) IBOutlet UITextField *specialtyTextField;//专业名称
@property (weak, nonatomic) IBOutlet UILabel *aDegreeInLabel;

@property (nonatomic, copy) void (^contentBlock)(NSString *);
@property (nonatomic, copy) void (^addAdegreeInBtnClikeBlock)();

@end
