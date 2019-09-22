//
//  GICDataBindingLock.h
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GICDataBindingLock : NSObject
-(void)lock;
-(void)unlock;
@end

NS_ASSUME_NONNULL_END
