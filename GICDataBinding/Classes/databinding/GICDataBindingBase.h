//
//  GICDataBindinng.h
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/13.
//

#import <Foundation/Foundation.h>
#import "GICBinding.h"
NS_ASSUME_NONNULL_BEGIN



typedef void (^GICDataBindinngValueChangedBlock)(id target,id newValue);

/**
 基本的单向绑定
 */
@interface GICDataBindingBase : GICBinding

/**
 获取当前正在执行绑定脚本的DataBinding。

 @return <#return value description#>
 */
+(instancetype)currentCalcuBinding;

/**
数据更新回调
 */
@property (nonatomic,copy,readonly)GICDataBindinngValueChangedBlock valueChangedBlock;

/**
 是否在主线程更新数据，默认为YES。否则会在 GICDataBindingUpdateValue 队列上更新
 */
@property (nonatomic,assign)BOOL isMainThread;

-(instancetype)updateValueChangedBlock:(GICDataBindinngValueChangedBlock)block;
@end

GICDataBindingBase* createDataBinding(id dataSource,NSString *expression,GICDataBindinngValueChangedBlock block);

NS_ASSUME_NONNULL_END
