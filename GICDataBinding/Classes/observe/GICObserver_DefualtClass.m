//
//  GICObserver_DefualtClass.m
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/18.
//

#import "GICObserver_DefualtClass.h"
#import "GICObserver+Private.h"
#import "NSInvocation+GICExtension.h"

@implementation GICObserver_DefualtClass
-(void)observe{
    proertyInfos = [NSObject gic_reflectProperties:[self.object class]];
    allPropertKeys = proertyInfos.allKeys;
    // 嵌套observer
    [allPropertKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self observeProperty:obj];
    }];
}

-(void)observeProperty:(NSString *)propertName {
    GICReflectorPropertyInfo *propertyInfo = [proertyInfos objectForKey:propertName];
    switch (propertyInfo.propertyType) {
        case GICPropertyType_OtherNSObjectClass:{
            // NOTE:对其他的Object 实例进行嵌套 observer
            id value = [[self.object valueForKey:propertName] gic_observer];
            [self.object setValue:value forKey:propertName];
            break;
        }
            //        case GICPropertyType_MutableDictionary:{
            //            id value = [[self.object valueForKey:propertName] gic_observer];
            //            [self.object setValue:value forKey:propertName];
            //            break;
            //        }
        case GICPropertyType_Array:{
            break;
        }
        default:
            break;
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([_object respondsToSelector:invocation.selector]) {
        NSString *selectorName = NSStringFromSelector(invocation.selector);
        
        BOOL isGet = NO;
        BOOL isSet = NO;
        id oldValue = nil;
        NSString *properyName;
        if([allPropertKeys containsObject:selectorName]){ // get方法
            properyName = selectorName;
            isGet = YES;
        }else if(invocation.selector == @selector(valueForKey:)){ // get方法
            properyName = [invocation getStringParama:2];
            if([allPropertKeys containsObject:properyName]){
                isGet = YES;
            }else{
                // NOTE:访问了不存在的 key
                return;
            }
        }else if(invocation.selector == @selector(setValue:forKey:)){
            properyName = [invocation getStringParama:3];
            if([allPropertKeys containsObject:properyName]){
                oldValue = [self.object valueForKey:properyName];
                isSet = YES;
            }else{
                // 如果target 不存在 对应的key ，那么直接忽略
                return;
            }
        }else if([selectorName hasPrefix:@"set"] && [selectorName hasSuffix:@":"]){         // 调用属性的set方法
            properyName = [selectorName substringWithRange:NSMakeRange(3, selectorName.length - 4)];
            // 将首字母小写
            properyName = [properyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[properyName substringToIndex:1] lowercaseString]];
            if([allPropertKeys containsObject:properyName]){
                oldValue = [self.object valueForKey:properyName];
                isSet = YES;
            }
        }
        
        [invocation invokeWithTarget:_object];
        //        NSLog(@"After calling \"%@\".", selectorName);
        
//         properyName = @"backgroundColor";
        // 判断调用的是get 还是 set 方法
        if(isGet){
            // 调用属性的get方法
            [self onCallGetMethod:properyName];
        }else if(isSet){
           
            [self observeProperty:properyName];
            [self onCallSetMethod:properyName oldValue:oldValue];
        }
    }
}
@end
