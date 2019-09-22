//
//  NSInvocation+GICExtension.h
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSInvocation (GICExtension)
-(NSString *)getStringParama:(NSInteger)index;

-(id)getObjectParama:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
