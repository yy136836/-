//
//  WQUserProfileCommonSectionHeaderView.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQSwitch.h"
@protocol WQUserProfileCommonSectionHeaderViewSwitchDelegate<NSObject>
- (void)profileCommonSectionHeaderViewSwitchStateChanged:(UISwitch *)aSwitch;

@end

typedef void(^GoRecommendPage)(void);

@interface WQUserProfileCommonSectionHeaderView : UIView



@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *conttentLabel;
@property (weak, nonatomic) IBOutlet WQSwitch *switch1;

@property (weak, nonatomic) IBOutlet UILabel *labAllShow;
@property (nonatomic, copy) GoRecommendPage goRecommendPage;
@property (weak, nonatomic) IBOutlet UIButton *goReco;

- (CGFloat)headerHeightForHeaderConttent:(NSString *)conttent;

@property (nonatomic, assign) id<WQUserProfileCommonSectionHeaderViewSwitchDelegate> delegate;

@end
