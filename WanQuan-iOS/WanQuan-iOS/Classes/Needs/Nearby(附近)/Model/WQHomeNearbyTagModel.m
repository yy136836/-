//
//  WQHomeNearbyTagModel.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/1.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQHomeNearbyTagModel.h"

@implementation WQHomeNearbyTagModel
/**
 根据字典反对model模型
 
 @param dict NSDictionary
 
 @return ZXModel
 */
//+(instancetype)modelWithDict:(NSDictionary *) dict
//{
//    WQHomeNearbyTagModel *model = [[self alloc] init];
//    for (NSString *key in [self properties]) {
//        if (dict[key]) {
//            if ([dict[key] isEqual:[NSNull null]]) {
//                [model setValue:nil forKey:key];
//                
//            }else{
//                [model setValue:dict[key] forKey:key];
//            }
//        }
//    }
//    return model;
//}
//
//
//+(NSArray *)properties
//{
//    unsigned int count = 0;
//    
//    objc_property_t *properties = class_copyPropertyList([self class], &count);
//    
//    NSMutableArray *arryM = [NSMutableArray arrayWithCapacity:count];
//    
//    for (unsigned int i = 0; i < count; i ++) {
//        objc_property_t parmeter = properties[i];
//        
//        const char *pname =  property_getName(parmeter);
//        [arryM addObject:[NSString stringWithUTF8String:pname]];
//    }
//    
//    return  arryM.copy;
//}
//
////重写copy方法
//-(id)copyWithZone:(NSZone *)zone
//{
//    
//    WQHomeNearbyTagModel *model = [[[self class] allocWithZone:zone] init];
//    
//    unsigned int count = 0;
//    
//    objc_property_t *properties = class_copyPropertyList([self class], &count);
//    
//    for (unsigned int i = 0; i < count; i ++) {
//        objc_property_t parmeter = properties[i];
//        
//        const char *pname =  property_getName(parmeter);
//        
//        [model setValue:[self valueForKey:[NSString stringWithUTF8String:pname]] forKey:[NSString stringWithUTF8String:pname]];
//        
//    }
//    return model;
//}
//
//-(NSString *)description
//{
//    //得到当前class的所有属性
//    uint count;
//    objc_property_t *properties = class_copyPropertyList([self class], &count);
//    
//    NSMutableString *str = [NSMutableString string];
//    
//    //循环并用KVC得到每个属性的值
//    for (int i = 0; i < count; i++) {
//        objc_property_t property = properties[i];
//        NSString *name = @(property_getName(property));
//        id value = [self valueForKey:name] ? : @"nil";//默认值为nil字符串
//        [str appendString:[NSString stringWithFormat:@"%@:%@ , ",name,value]];
//    }
//    
//    //释放
//    free(properties);
//    
//    //return
//    return [NSString stringWithFormat:@"<%@ : %p> %@",[self class],self,str];
//}

@end
