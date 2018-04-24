//
//  WQMyCriditView.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQMyCriditView.h"

@interface WQMyCriditView ()
@property (weak, nonatomic) IBOutlet UIImageView *creditValueBG;
@property (weak, nonatomic) IBOutlet UILabel *creditValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *knowMore;

@end

@implementation WQMyCriditView


- (void)setCreditValue:(NSInteger)creditValue {
    _creditValue = creditValue;
    if (creditValue < 40) {
        
        _creditValueBG.image = [UIImage imageNamed:@"xinyongbuzu"];
    }else if (creditValue >= 40 && creditValue < 60){
        
        _creditValueBG.image = [UIImage imageNamed:@"xinyongyiban"];
    }else if (creditValue >= 60 && creditValue < 80){
        
        _creditValueBG.image = [UIImage imageNamed:@"xinyonglianghao"];
    }else{
        
        _creditValueBG.image = [UIImage imageNamed:@"xinyongjihao"];
    }
    _creditValueLabel.text = [NSString stringWithFormat:@"%zd",creditValue];

}
- (IBAction)toKnowMore:(id)sender {
    
    if (self.toKnowMore) {
        self.toKnowMore();
    }
}
@end
