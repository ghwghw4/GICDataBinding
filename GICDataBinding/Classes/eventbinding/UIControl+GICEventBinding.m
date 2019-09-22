//
//  UIControl+GICEventBinding.m
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/20.
//

#import "UIControl+GICEventBinding.h"
#import "GICObserveMethod.h"

@implementation UIControl (GICEventBinding)
-(void)gic_addEventBinding:(GICEventBinding *)eventBinding forControlEvents:(UIControlEvents)controlEvents{
    [self gic_addBinding:eventBinding];
    [self gic_addEventWatch:^(NSArray * _Nullable params) {
           [eventBinding fireEvent:nil];
    } forControlEvents:controlEvents];
}


-(GICObserverMethodWatch *)gic_addEventWatch:(GICObserverMethodWatchBlock)watchBlock forControlEvents:(UIControlEvents)controlEvents{
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"gic_events_UIControlEvent%@",@(controlEvents)]);
    GICObserverMethodWatch *watch = [GICObserverMethodWatch watch:sel block:watchBlock];
    [[self gicObserveMethod] addWatch:watch];
    [self addTarget:[self gicObserveMethod] action:sel forControlEvents:controlEvents];
    return watch;
}
@end
