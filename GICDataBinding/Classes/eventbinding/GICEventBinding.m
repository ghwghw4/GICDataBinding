//
//  GICEventBinding.m
//  GICDataBinding
//
//  Created by 龚海伟 on 2019/9/20.
//

#import "GICEventBinding.h"
#import "GICJSContextManager.h"

@implementation GICEventBinding

-(void)install:(id)target{
    
}

-(void)uninstall{
    
}

-(id)fireEvent:(id)eventInfo{
    NSMutableArray *params = [@[self.dataSource,self.expression] mutableCopy];
    if(eventInfo){
        [params addObject:eventInfo];
    }
    JSValue *result= [[GICJSContextManager manager].jsContext[@"fireEvent"] callWithArguments:params];
    if(result.isUndefined){
        return nil;
    }
    return result.toObject;
}
@end
