//
//  GICDataBinding_TwoWay.m
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/13.
//

#import "GICDataBinding_TwoWay.h"

@implementation GICDataBinding_TwoWay
-(id)initWidthDataSource:(id)dataSource expression:(NSString *)exp{
    _propertyName = exp;
    return  [super initWidthDataSource:dataSource expression:[NSString stringWithFormat:@"$.%@",exp]];
}
@end


@implementation NSObject (GICDataBinding_TwoWay)
-(GICDataBinding_TwoWay *)gic_anyTwowayBinding{
    for(id item in self.gicDataBindings){
        if([item isKindOfClass:[GICDataBinding_TwoWay class]]){
            return item;
        }
    }
    return nil;
}
@end

GICDataBinding_TwoWay* createTwowayDataBinding(id dataSource,NSString *propertyName){
    GICDataBinding_TwoWay *b = [[GICDataBinding_TwoWay alloc] initWidthDataSource:dataSource expression:propertyName];
    return b;
}
