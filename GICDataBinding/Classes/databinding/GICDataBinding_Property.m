//
//  GICDataBinding_Property.m
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/19.
//

#import "GICDataBinding_Property.h"

@implementation GICDataBinding_Property
-(id)initWidthDataSource:(id)dataSource expression:(NSString *)exp withPropertyName:(NSString *)propertyName{
    self = [super initWidthDataSource:dataSource expression:exp];
    _propertyName = propertyName;
    __weak GICDataBinding_Property *wself = self;
    [super updateValueChangedBlock:^(id  _Nonnull target, id  _Nonnull newValue) {
        [target setValue:newValue forKey:propertyName];
        if(wself.propertyChangedBlock){
            wself.propertyChangedBlock(target,newValue);
        }
    }];
    return self;
}

-(GICDataBindingBase *)updateValueChangedBlock:(GICDataBindinngValueChangedBlock)block{
    NSAssert(NO, @"GICDataBinding_Property 不允许设置 block 回调");
    return nil;
}
@end


GICDataBinding_Property* createPropertyDataBinding(id dataSource,NSString *expression,NSString *propertyName){
    GICDataBinding_Property *b = [[GICDataBinding_Property alloc] initWidthDataSource:dataSource expression:expression withPropertyName:propertyName];
    return b;
}


GICDataBinding_Property* createPropertyDataBindingWithBlock(id dataSource,NSString *expression,NSString *propertyName,GICDataBindinngPropertyChangedBlock propertyChangedBlock){
    GICDataBinding_Property *b = createPropertyDataBinding(dataSource,expression,propertyName);
    b.propertyChangedBlock = propertyChangedBlock;
    return b;
}
