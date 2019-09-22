//
//  GICBlockCallbackProxy.m
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/20.
//

#import "GICObserveMethod.h"
#import <objc/runtime.h>

@implementation GICObserveMethod{
    __weak id object;
    NSMutableArray<GICObserverMethodWatch *> *watchsArray;
}

+ (id)proxyForObject:(id)obj{
    if([obj isProxy])
        return obj;
    GICObserveMethod *proxy = [GICObserveMethod alloc];
    proxy->object = obj;
    proxy->watchsArray = [NSMutableArray array];
    return proxy;
}

-(void)addWatch:(GICObserverMethodWatch *)watch{
    [watchsArray addObject:watch];
}

-(void)removeWatch:(GICObserverMethodWatch *)watch{
    [watchsArray removeObject:watch];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    if ([object respondsToSelector:invocation.selector]){
        [invocation invokeWithTarget:object];
    }
    NSMutableArray *finds = [NSMutableArray array];
    [watchsArray enumerateObjectsUsingBlock:^(GICObserverMethodWatch *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.method == invocation.selector){
            [finds addObject:obj];
        }
    }];
    
    [finds enumerateObjectsUsingBlock:^(GICObserverMethodWatch *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.watchBlock){
            obj.watchBlock(nil);
        }
    }];
    
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [object respondsToSelector:aSelector];
}

- (Class)superclass {
    return [object superclass];
}

- (Class)class {
    return [object class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [object isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [object isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [object conformsToProtocol:aProtocol];
}

- (BOOL)isProxy {
    return YES;
}

- (NSString *)description {
    return [object description];
}

- (NSString *)debugDescription {
    return [object debugDescription];
}

@end


@implementation NSObject (GICObserveMethod)
static char *kGICObserveMethod = "kGICObserveMethod";
-(GICObserveMethod *)gicObserveMethod{
    GICObserveMethod *obmethod = objc_getAssociatedObject(self, kGICObserveMethod);
    if(obmethod == nil){
        obmethod = [GICObserveMethod proxyForObject:self];
        objc_setAssociatedObject(self,kGICObserveMethod, obmethod, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obmethod;
}
@end
