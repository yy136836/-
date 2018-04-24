//
//  WQSwizzeMethod.m
//  WanQuan-iOS
//
//  Created by Shmily on 2018/4/16.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQSwizzeMethod.h"

@implementation WQSwizzeMethod


void SwizzlingMethod(Class class, SEL originSEL, SEL swizzledSEL)
{
    Method originMethod = class_getInstanceMethod(class, originSEL);
    Method swizzledMethod = nil;
    
    if (!originMethod) {
        originMethod = class_getClassMethod(class, originSEL);
        if (!originMethod) {
            return;
        }
        swizzledMethod = class_getClassMethod(class, swizzledSEL);
        if (!swizzledMethod) {
            return;
        }
    } else {
        swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
        if (!swizzledMethod){
            return;
        }
    }
    
    if(class_addMethod(class, originSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, swizzledMethod);
    }
}



@end
