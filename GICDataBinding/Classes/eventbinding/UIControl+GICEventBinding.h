//
//  UIControl+GICEventBinding.h
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/20.
//

#import "GICEventBinding.h"
#import "GICObserverMethodWatch.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (GICEventBinding)
-(void)gic_addEventBinding:(GICEventBinding *)eventBinding forControlEvents:(UIControlEvents)controlEvents;

-(GICObserverMethodWatch *)gic_addEventWatch:(GICObserverMethodWatchBlock)watchBlock forControlEvents:(UIControlEvents)controlEvents;

//-(void)gic_addEventBinding:(GICEventBinding *)eventBinding forControlEvents:(UIControlEvents)controlEvents;
@end

NS_ASSUME_NONNULL_END
