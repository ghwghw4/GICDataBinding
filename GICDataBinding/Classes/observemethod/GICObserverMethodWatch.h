//
//  GICObserverMethodWatch.h
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/20.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^GICObserverMethodWatchBlock)(NSArray * _Nullable params);

@interface GICObserverMethodWatch : NSObject
@property (nonatomic,readonly)SEL method;
@property (nonatomic,copy)GICObserverMethodWatchBlock watchBlock;

+(instancetype)watch:(SEL)method block:(GICObserverMethodWatchBlock)watchBlock;
@end

NS_ASSUME_NONNULL_END
