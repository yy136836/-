//
//  WQSearchController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQSearchController.h"
#import "WQSearchResultController.h"

@interface WQSearchController ()

@end

@implementation WQSearchController

- (instancetype)initWithResultCellClassNameOrNibName:(NSString *)classNameOrNibName resultModelClass:(Class)modelClass cellHeight:(CGFloat)cellHeight {
    
    WQSearchResultController * vc = [WQSearchResultController new];
    
    if (self = [super initWithRootViewController:vc]) {
        
//        vc.registCell = cell.copy;
//        vc.modelClass = modelClass;
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
