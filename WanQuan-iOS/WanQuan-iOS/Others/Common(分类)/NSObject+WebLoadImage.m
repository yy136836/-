//
//  NSObject+WebLoadImage.m
//  WanQuan-iOS
//
//  Created by Shmily on 2018/4/9.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "NSObject+WebLoadImage.h"

@implementation NSObject (WebLoadImage)

- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects
{
    // 方法签名(对方法的描述)
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    if (signature == nil) {
        [NSException raise:@"严重错误" format:@"(%@)方法找不到", NSStringFromSelector(selector)];
    }
    /*NSInvocation : 利用一个NSInvocation对象通过调用方法签名来实现对方法的调用（方法调用者、方法名、方法参数、方法返回值）
     如果仅仅完成这步，和普通的函数调用没有区别，但是关键在于NSInvocation可以对传递进来的selector进行包装，实现可以传递无限多个参数
     普通的方法调用比如:[self performSelector: withObject: withObject:]顶多只能传递两个参数给selector*/
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self; //调用者是自己
    invocation.selector = selector; //调用的方法是selector
    // 设置参数，可以传递无限个参数
    NSInteger paramsCount = signature.numberOfArguments - 2; // 除self、_cmd以外的参数个数
    paramsCount = MIN(paramsCount, objects.count); //防止函数有参数但是不传递参数时，导致崩溃
    for (NSInteger i = 0; i < paramsCount; i++) {
        id object = objects[i];
        if ([object isKindOfClass:[NSNull class]]) continue; //如果传递的参数为null，就不处理了
        [invocation setArgument:&object atIndex:i + 2]; // +2是因为第一个和第二个参数默认是self和_cmd
    }
    // 调用方法
    [invocation invoke];
    // 获取返回值
    id returnValue = nil;
    if (signature.methodReturnLength) { // 有返回值类型，才去获得返回值
        [invocation getReturnValue:&returnValue];
    }
    return returnValue;
}


@end
