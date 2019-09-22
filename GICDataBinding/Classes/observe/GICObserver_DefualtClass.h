//
//  GICObserver_DefualtClass.h
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/18.
//

#import "NSObject+GICObserver.h"
#import <GICJsonParser/NSObject+Reflector.h>

NS_ASSUME_NONNULL_BEGIN

@interface GICObserver_DefualtClass : GICObserver{
    NSArray<NSString *> *allPropertKeys;
    NSDictionary<NSString *,GICReflectorPropertyInfo *> *proertyInfos;
}
@end

NS_ASSUME_NONNULL_END
