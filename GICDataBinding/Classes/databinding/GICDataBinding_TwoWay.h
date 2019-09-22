//
//  GICDataBinding_TwoWay.h
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/13.
//

#import <Foundation/Foundation.h>
#import "GICDataBindingBase.h"

NS_ASSUME_NONNULL_BEGIN


/**
 双向绑定，propertyName只能指定单个需要绑定的属性名称，不能是表达式。否则无法绑定成功
 */
@interface GICDataBinding_TwoWay : GICDataBindingBase
@property (nonatomic,readonly)NSString *propertyName;
@end

@interface NSObject (GICDataBinding_TwoWay)
-(GICDataBinding_TwoWay *)gic_anyTwowayBinding;
@end


GICDataBinding_TwoWay* createTwowayDataBinding(id dataSource,NSString *propertyName);


NS_ASSUME_NONNULL_END
