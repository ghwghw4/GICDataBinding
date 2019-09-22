//
//  GICObserver_Array.m
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/18.
//

#import "GICObserver_Array.h"

@implementation GICObserver_Array
-(void)observe{
    NSMutableArray *mutarray = [NSMutableArray array];
    [(NSArray *)self.object enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mutarray addObject:[obj gic_observer]];
    }];
    self->_object = [mutarray copy];
}
@end
