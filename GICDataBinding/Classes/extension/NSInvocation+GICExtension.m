//
//  NSInvocation+GICExtension.m
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/19.
//

#import "NSInvocation+GICExtension.h"

@implementation NSInvocation (GICExtension)
-(NSString *)getStringParama:(NSInteger)index{
    return [self getObjectParama:index];
}

-(id)getObjectParama:(NSInteger)index{
    id __unsafe_unretained obj;
    [self getArgument:&obj atIndex:index];
    return obj;
}
@end
