//
//  GICBinding.m
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/20.
//

#import "GICBinding.h"
#import <objc/runtime.h>

@implementation GICBinding
-(instancetype)initWidthDataSource:(id)dataSource expression:(NSString *)exp{
    self = [self init];
    if(![dataSource isProxy]){
        NSAssert(NO, @"数据源必须是GICObserver");
    }
    _dataSource = dataSource;
    _expression = exp;
    return self;
}

+(instancetype)bindingWidthDataSource:(id)dataSource expression:(NSString *)exp{
    return [[[self class] alloc] initWidthDataSource:dataSource expression:exp];
}

-(void)install:(id)target{
    NSAssert(NO, @"由子类实现");
}

-(void)uninstall{
    NSAssert(NO, @"由子类实现");
}
@end


@implementation NSObject (GICBinding)
-(NSMutableArray<GICBinding *> *)gicDataBindings{
    NSMutableArray *array = objc_getAssociatedObject(self, "gicDataBindings");
    if(array == nil){
        array = [NSMutableArray array];
        objc_setAssociatedObject(self, "gicDataBindings", array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return array;
}

-(void)gic_addBinding:(GICBinding *)databinding{
    [self.gicDataBindings addObject:databinding];
    [databinding install:self];
}

-(void)gic_removeBinding:(GICBinding *)databinding{
    [self.gicDataBindings removeObject:databinding];
    [databinding uninstall];
}
@end
