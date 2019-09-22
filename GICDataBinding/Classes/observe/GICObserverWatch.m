//
//  GICObserverWatch.m
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/13.
//

#import "GICObserverWatch.h"
#import "GICObserver+Private.h"

@implementation GICObserverWatch

+(instancetype)watchForPropertName:(NSString *)propertyName valueChanged:(GICObserverValueChangedBlock)valueChanged{
    GICObserverWatch *watch = [GICObserverWatch new];
    watch->_propertyName = [propertyName copy];
    watch.valueChangedBlock = valueChanged;
    return watch;
}

-(void)beginWatch:(GICObserver *)observe{
    NSAssert(_observer == nil, @"不允许重复watch");
    _observer = observe;
    [observe watch:self];
}

-(void)endwatch{
    [_observer removeWatch:self];
}
@end
