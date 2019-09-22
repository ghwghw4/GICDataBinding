//
//  NSObject+GICObserver.h
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/13.
//

#import <Foundation/Foundation.h>
#import "GICObserverWatch.h"
#import "GICObserverProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GICObserver : NSProxy{
    id _object;
    NSMutableSet<GICObserverWatch*> *watchersSet;
}
+ (id)proxyForObject:(id)obj;

/**
 触发set 操作的队列

 @return 串行队列
 */
+(dispatch_queue_t)setValueQueue;
@property (nonatomic,strong,readonly)id object;
@end

@interface NSObject (GICObserver)
-(instancetype)gic_observer;
@end

NS_ASSUME_NONNULL_END
