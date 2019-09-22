//
//  GICEventBinding.h
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/20.
//

#import <Foundation/Foundation.h>
#import "GICBinding.h"
NS_ASSUME_NONNULL_BEGIN

/**
 事件绑定
 */
@interface GICEventBinding : GICBinding
/**
 直接触发事件

 @param eventInfo <#eventInfo description#>
 */
-(id)fireEvent:(id _Nullable)eventInfo;
@end

NS_ASSUME_NONNULL_END
