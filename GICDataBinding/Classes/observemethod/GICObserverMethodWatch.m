//
//  GICObserverMethodWatch.m
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/20.
//

#import "GICObserverMethodWatch.h"

@implementation GICObserverMethodWatch
+(instancetype)watch:(SEL)method block:(GICObserverMethodWatchBlock)watchBlock{
    GICObserverMethodWatch *w = [[GICObserverMethodWatch alloc] init];
    w->_method = method;
    w.watchBlock = watchBlock;
    return w;
}
@end
