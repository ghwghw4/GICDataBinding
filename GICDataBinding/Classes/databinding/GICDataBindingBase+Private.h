//
//  GICDataBinding_Oneway+Private.h
//  GICDataBinding
//
//  Created by gonghaiwei on 2019/9/13.
//

#import <GICDataBinding/GICDataBinding.h>

NS_ASSUME_NONNULL_BEGIN

@interface GICDataBindingBase (Private)
-(void)onGetPropertCall:(GICObserver*)observer propertyName:(NSString *)propertyName;
-(id)getTarget;
@end

NS_ASSUME_NONNULL_END
