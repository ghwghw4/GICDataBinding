//
//  GICObserver_MutableArray.m
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/14.
//

#import "GICObserver_MutableArray.h"
#import "GICObserver+Private.h"
#import "NSInvocation+GICExtension.h"

NSString * const GICMutableArrayChangedPropertyName = @"arrayChanged";

@implementation GICObserver_MutableArray
-(void)observe{
    [super observe];
    self->_object = [self.object mutableCopy];
}

-(void)onArrayItemsChanged:(GICMutableArrayChangedType)type params:(NSArray *)params{
    [self forceNotifyValueChanged:nil oldVlaue:nil propertyName:GICMutableArrayChangedPropertyName];
    if(self.changedBlock){
        dispatch_async([GICObserver setValueQueue], ^{
           self.changedBlock((NSMutableArray *)self, type, params);
        });
    }
}

-(void)onCallObjectAtIndex:(NSInvocation *)invocation{
    NSInteger index = 0;
    [invocation getArgument:&index atIndex:2];
    id value = [self.object objectAtIndex:index];
    if(![value isProxy]){
        value = [value gic_observer];
        [self.object setObject:value atIndex:index];
    }
    [invocation setReturnValue:&value];
    [self onCallGetMethod:GICMutableArrayChangedPropertyName];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([self.object respondsToSelector:invocation.selector]) {
        if(invocation.selector == @selector(objectAtIndexedSubscript:) || invocation.selector == @selector(objectAtIndex:)){
            [self onCallObjectAtIndex:invocation];
        }else{
            // array changed
            if(invocation.selector == @selector(addObject:)){
                id obj = [invocation getObjectParama:2];
                if(obj)
                [self onArrayItemsChanged:GICMutableArrayChangedAddObject params:@[obj]];
            }else if (invocation.selector == @selector(removeObject:)){
                id obj = [invocation getObjectParama:2];
                if(obj)
                    [self onArrayItemsChanged:GICMutableArrayChangedRemoveObject params:@[obj]];
            }else if (invocation.selector == @selector(removeObjectAtIndex:)){
                NSInteger index = 0;
                [invocation getArgument:&index atIndex:2];
                id obj = [self.object objectAtIndex:index];
                if(obj)
                    [self onArrayItemsChanged:GICMutableArrayChangedRemoveObject params:@[obj]];
            }else if (invocation.selector == @selector(insertObject:atIndex:)){
                id obj = [invocation getObjectParama:2];
                NSInteger index = 0;
                [invocation getArgument:&index atIndex:3];
                [self onArrayItemsChanged:GICMutableArrayChangedInsertObject params:@[obj,@(index)]];
            }else if (invocation.selector == @selector(removeLastObject)){
                id obj = [self.object lastObject];
                if(obj)
                    [self onArrayItemsChanged:GICMutableArrayChangedRemoveLastObject params:@[(obj)]];
            }else if (invocation.selector == @selector(replaceObjectAtIndex:withObject:)){
                id obj = [invocation getObjectParama:3];
                NSInteger index = 0;
                [invocation getArgument:&index atIndex:2];
                [self onArrayItemsChanged:GICMutableArrayChangedReplaceObject params:@[obj,@(index)]];
            }else if (invocation.selector == @selector(removeAllObjects)){
                [self onArrayItemsChanged:GICMutableArrayChangedRemoveAllObjects params:nil];
            }else if (invocation.selector == @selector(sortUsingFunction:context:) || invocation.selector == @selector(sortUsingComparator:) || invocation.selector == @selector(sortUsingSelector:)){
                // sort
                [self onArrayItemsChanged:GICMutableArrayChangedSortArray params:nil];
            }
            [invocation invokeWithTarget:self.object];
        }
    }
}
@end
