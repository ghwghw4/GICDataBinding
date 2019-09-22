//
//  GICBlockCallbackProxy.h
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/20.
//

#import <UIKit/UIKit.h>
#import "GICObserverMethodWatch.h"

NS_ASSUME_NONNULL_BEGIN

@interface GICObserveMethod : NSProxy
-(void)addWatch:(GICObserverMethodWatch *)watch;
-(void)removeWatch:(GICObserverMethodWatch *)watch;
@end
/**
 进行方法拦截
 */
@interface NSObject (GICObserveMethod)
@property (nonatomic,readonly,strong)GICObserveMethod *gicObserveMethod;
@end

NS_ASSUME_NONNULL_END
