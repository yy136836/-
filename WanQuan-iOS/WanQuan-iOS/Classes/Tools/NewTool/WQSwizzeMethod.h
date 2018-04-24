//
//  WQSwizzeMethod.h
//  WanQuan-iOS
//
//  Created by Shmily on 2018/4/16.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQSwizzeMethod : NSObject

void SwizzlingMethod(Class c, SEL origSEL, SEL newSEL);


@end
