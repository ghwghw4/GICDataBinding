//
//  NSObject+GICObserver.m
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/13.
//

#import "NSObject+GICObserver.h"
#import "GICDataBindingBase.h"
#import "GICDataBindingBase+Private.h"
#import "GICObserver_MutableDictionary.h"
#import "GICObserver+Private.h"
#import "GICObserver_MutableArray.h"
#import "GICObserver_Array.h"
#import "GICObserver_Dictionary.h"
#import "GICObserver_DefualtClass.h"
#import "GICDataBindingLock.h"

@implementation NSObject (GICObserver)
-(instancetype)gic_observer{
    return [GICObserver proxyForObject:self];
}

-(void)gic_addWatch:(GICObserverWatch *)watch{
    if(!self.isProxy){
        NSAssert(NO, @"watch 只能对经过 observer 后的对象调用");
    }
    [(GICObserver *)self watch:watch];
}

-(void)gic_removeWatch:(GICObserverWatch *)watch{
    if(!self.isProxy){
        NSAssert(NO, @"watch 只能对经过 observer 后的对象调用");
    }
    [(GICObserver *)self removeWatch:watch];
}
@end



@implementation GICObserver


/**
 串行队列

 @return <#return value description#>
 */
+(dispatch_queue_t)setValueQueue{
    static dispatch_queue_t setValueQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        setValueQueue = dispatch_queue_create("GICDataBindingUpdateValue", NULL);
    });
    return setValueQueue;
}

static GICObserver *currentSetValueObserver;
+(GICObserver *)currentSetValueObserver{
    return currentSetValueObserver;
}

+ (id)proxyForObject:(id)obj {
    if(obj == nil)
        return obj;
    if ([obj isProxy]){
        return obj;
    }
    
    GICObserver *instance = nil;
    if([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]){
        return obj;
    }else if([obj isKindOfClass:[NSMutableDictionary class]]){
        instance = [[GICObserver_MutableDictionary alloc] init];
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        instance = [[GICObserver_Dictionary alloc] init];
    }else if ([obj isKindOfClass:[NSMutableArray class]]){
        instance = [[GICObserver_MutableArray alloc] init];
    }else if ([obj isKindOfClass:[NSArray class]]){
        instance = [[GICObserver_Array alloc] init];
    }else if ([obj conformsToProtocol:@protocol(GICObserverProtocol)]){
        instance = [[GICObserver_DefualtClass alloc] init];
    }else{
        return obj;
    }
    instance->_object = obj;
    [instance observe];
    return instance;
}

-(id)init{
    watchersSet = [NSMutableSet set];
    return self;
}

-(void)watch:(GICObserverWatch *)watch{
    [self->watchersSet addObject:watch];
}

-(void)removeWatch:(GICObserverWatch *)watch{
    [self->watchersSet removeObject:watch];
}

-(void)observe{
    
}

-(void)onCallGetMethod:(NSString *)propertName{
//    NSLog(@"onCallGetMethod:%@",propertName);
    [[GICDataBindingBase currentCalcuBinding] onGetPropertCall:self propertyName:propertName];
}

-(void)onCallSetMethod:(NSString *)propertName oldValue:(id)oldValue{
//    NSLog(@"onCallSetMethod:%@",propertName);
    
    id newValue = [self.object valueForKey:propertName];
    if(![newValue isEqual:oldValue]){
        [self forceNotifyValueChanged:newValue oldVlaue:oldValue propertyName:propertName];
    }
}


-(void)forceNotifyValueChanged:(id)newValue oldVlaue:(id)oldValue propertyName:(NSString *)propertyName{
    if(self->watchersSet.count == 0) return;
    dispatch_async([GICObserver setValueQueue], ^{
        NSMutableArray *finds = [NSMutableArray array];
        [self->watchersSet enumerateObjectsUsingBlock:^(GICObserverWatch *item, BOOL * _Nonnull stop) {
            if([item.propertyName isEqualToString:propertyName]){
                [finds addObject:item];
            }
        }];
        // 用来
        currentSetValueObserver =  newValue;
        [finds enumerateObjectsUsingBlock:^(GICObserverWatch * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.valueChangedBlock(newValue,oldValue);
        }];
        currentSetValueObserver =  nil;
    });
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [_object methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    if ([_object respondsToSelector:invocation.selector]){
        [invocation invokeWithTarget:_object];
    }
}


- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.object respondsToSelector:aSelector];
}

- (Class)superclass {
    return [self.object superclass];
}

- (Class)class {
    return [self.object class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [self.object isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [self.object isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [self.object conformsToProtocol:aProtocol];
}

- (BOOL)isProxy {
    return YES;
}

- (NSString *)description {
    return [self.object description];
}

- (NSString *)debugDescription {
    return [self.object debugDescription];
}
@end
