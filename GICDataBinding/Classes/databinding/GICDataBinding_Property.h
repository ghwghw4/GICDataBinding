//
//  GICDataBinding_Property.h
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/19.
//

#import <Foundation/Foundation.h>
#import "GICDataBindingBase.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^GICDataBindinngPropertyChangedBlock)(id target,id newValue);
/**
 属性数据绑定，当value发生变更的时候自动会将数据设置到目标对象的某个属性
 */
@interface GICDataBinding_Property : GICDataBindingBase
@property (nonatomic,readonly)NSString *propertyName;
@property (nonatomic,copy)GICDataBindinngPropertyChangedBlock propertyChangedBlock;
@end

GICDataBinding_Property* createPropertyDataBinding(id dataSource,NSString *expression,NSString *propertyName);
GICDataBinding_Property* createPropertyDataBindingWithBlock(id dataSource,NSString *expression,NSString *propertyName,GICDataBindinngPropertyChangedBlock propertyChangedBlock);
NS_ASSUME_NONNULL_END
