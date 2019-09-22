//
//  GICObserverWatch.h
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/13.
//

#import <Foundation/Foundation.h>

@class GICObserver;
typedef void (^GICObserverValueChangedBlock)(id _Nullable  newValue,id _Nullable oldValue);

NS_ASSUME_NONNULL_BEGIN

@interface GICObserverWatch : NSObject{
}
@property (nonatomic,readonly)NSString *propertyName;
@property (nonatomic,copy)GICObserverValueChangedBlock valueChangedBlock;
@property (nonatomic,readonly,weak)GICObserver *observer;
+(instancetype)watchForPropertName:(NSString *)propertyName valueChanged:(GICObserverValueChangedBlock)valueChanged;

-(void)beginWatch:(GICObserver *)observe;
// 停止监听，使得监听无效
-(void)endwatch;
@end

NS_ASSUME_NONNULL_END
