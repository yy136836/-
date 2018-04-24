//
//  WQEssencePraiseView.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/11/9.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WQEssencePraiseViewDelegate <NSObject>
- (void)WQEssencePraiseViewZanOnClick:(UIButton *)sender;
- (void)WQEssencePraiseViewPraiseOnClick:(UIButton *)sender;
@end

@interface WQEssencePraiseView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet IBInspectable  UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UILabel *commentTypeLabel;

@property (nonatomic, weak)id<WQEssencePraiseViewDelegate> delegate;
@end
