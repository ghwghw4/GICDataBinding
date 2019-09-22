//
//  GICObserver_Dictionary.m
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/18.
//

#import "GICObserver_Dictionary.h"

@implementation GICObserver_Dictionary
-(void)observe{
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
    [(NSDictionary *)self.object enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [mutDict setObject:[obj gic_observer] forKey:key];
    }];
    self->_object = [mutDict copy];
}
@end
