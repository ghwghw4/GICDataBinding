//
//  GICObserver_MutableDictionary.m
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/14.
//

#import "GICObserver_MutableDictionary.h"
#import "GICObserver+Private.h"
#import "NSInvocation+GICExtension.h"

@implementation GICObserver_MutableDictionary
-(void)observe{
    [super observe];
    self->_object = [self.object mutableCopy];
}

-(void)onCallObjectForKey:(NSInvocation *)invocation key:(NSString *)key{
    id value = [self.object objectForKey:key];
    if(![value isProxy]){
        value = [value gic_observer];
        [self.object setObject:value forKey:key];
    }
    [invocation setReturnValue:&value];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([self.object respondsToSelector:invocation.selector]) {
        NSString *properyName = nil;
        BOOL isSet = NO;
        id oldValue = nil;
        if(invocation.selector == @selector(valueForKey:) || invocation.selector == @selector(objectForKey:) || invocation.selector == @selector(objectForKeyedSubscript:)){ // get方法
            properyName = [invocation getStringParama:2];
            [self onCallObjectForKey:invocation key:properyName];
            [self onCallGetMethod:properyName];
            return;
        }else if(invocation.selector == @selector(setObject:forKey:) || invocation.selector == @selector(setObject:forKeyedSubscript:)){
            // set方法
            properyName = [invocation getStringParama:3];
            oldValue = [self.object objectForKey:properyName];
            isSet = YES;
        }
        [invocation invokeWithTarget:self.object];
        if (isSet){
            [self onCallSetMethod:properyName oldValue:oldValue];
        }
    }
}
@end
