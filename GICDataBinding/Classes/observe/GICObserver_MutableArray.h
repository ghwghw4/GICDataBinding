//
//  GICObserver_MutableArray.h
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/14.
//

#import "GICObserver_Array.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const GICMutableArrayChangedPropertyName;

typedef NS_ENUM(NSInteger, GICMutableArrayChangedType) {
    GICMutableArrayChangedAddObject, // 添加元素
    GICMutableArrayChangedRemoveObject, // 删除元素
    GICMutableArrayChangedInsertObject, // 插入元素
    GICMutableArrayChangedRemoveLastObject, // 删除最后一个元素
    GICMutableArrayChangedReplaceObject,//替换元素
    GICMutableArrayChangedRemoveAllObjects,//清空array
    GICMutableArrayChangedSortArray//排序
};

typedef void(^GICObserverMutableArrayChangedBlock)(NSMutableArray *mutArray,GICMutableArrayChangedType changedType,NSArray * _Nullable params);

@interface GICObserver_MutableArray : GICObserver_Array

/**
 数组更改的回调。
 NOTE:回调的时候是异步回调，并且在非主线程上回调。
 */
@property (nonatomic,copy)GICObserverMutableArrayChangedBlock changedBlock;
@end

NS_ASSUME_NONNULL_END
