//
//  GICObserver+Private.h
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/14.
//

#import <GICDataBinding/GICDataBinding.h>

NS_ASSUME_NONNULL_BEGIN

@interface GICObserver (Private)
+(GICObserver *)currentSetValueObserver;
-(id)init;
-(void)observe;
-(void)onCallGetMethod:(NSString *)propertName;
-(void)onCallSetMethod:(NSString *)propertName oldValue:(id)oldValue;
-(void)watch:(GICObserverWatch *)watch;
-(void)removeWatch:(GICObserverWatch *)watch;

/**
 强制触发改变事件
 */
-(void)forceNotifyValueChanged:(id _Nullable)newValue oldVlaue:(id _Nullable)oldValue propertyName:(NSString *)propertyName;
@end

NS_ASSUME_NONNULL_END
